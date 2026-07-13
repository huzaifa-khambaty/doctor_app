<?php

namespace App\Domain\Doctor\Http\Controllers\Api;

use App\Domain\Shared\Models\Event;
use App\Domain\Shared\Models\EventRegistration;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Storage;

class EventController extends Controller
{
    public function index(Request $request)
    {
        $query = Event::published()->with('creator:id,name');

        if ($request->has('type')) {
            $query->where('type', $request->type);
        }

        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                  ->orWhere('speaker', 'like', "%{$search}%");
            });
        }

        if ($request->has('filter')) {
            if ($request->filter === 'upcoming') {
                $query->where('starts_at', '>', now());
            } elseif ($request->filter === 'past') {
                $query->where('starts_at', '<=', now());
            }
        }

        $events = $query->paginate($request->query('per_page', 15));

        $user = $request->user();
        
        $events->getCollection()->transform(function ($event) use ($user) {
            $event->is_registered = $event->registrations()->where('user_id', $user->id)->where('status', '!=', 'cancelled')->exists();
            $event->is_live = now()->between($event->starts_at, $event->ends_at ?? $event->starts_at->copy()->addHours(2));
            return $event;
        });

        return $this->jsonWithPagination($events);
    }

    public function show(Event $event, Request $request)
    {
        if ($event->status !== 'published') {
            return response()->json(['message' => 'Event not found.'], 404);
        }

        $user = $request->user();
        $event->load('creator:id,name');
        
        $event->is_registered = $event->registrations()->where('user_id', $user->id)->where('status', '!=', 'cancelled')->exists();
        $event->is_live = now()->between($event->starts_at, $event->ends_at ?? $event->starts_at->copy()->addHours(2));

        return response()->json($event);
    }

    public function register(Event $event, Request $request)
    {
        if ($event->status !== 'published') {
            return response()->json(['message' => 'Event not found.'], 404);
        }

        if ($event->starts_at < now()) {
            return response()->json(['message' => 'Cannot register for a past event.'], 422);
        }

        $user = $request->user();

        $registration = EventRegistration::where('event_id', $event->id)->where('user_id', $user->id)->first();

        if ($registration && $registration->status !== 'cancelled') {
            return response()->json(['message' => 'Already registered for this event.'], 409);
        }

        if ($registration && $registration->status === 'cancelled') {
            $registration->update(['status' => 'registered']);
        } else {
            EventRegistration::create([
                'event_id' => $event->id,
                'user_id' => $user->id,
                'status' => 'registered',
            ]);
        }

        activity()->causedBy($user)->performedOn($event)->log('Doctor registered for event');

        return response()->json(['message' => 'Successfully registered for the event.']);
    }

    public function cancelRegistration(Event $event, Request $request)
    {
        $user = $request->user();
        
        $registration = EventRegistration::where('event_id', $event->id)->where('user_id', $user->id)->first();

        if (!$registration || $registration->status === 'cancelled') {
            return response()->json(['message' => 'Registration not found or already cancelled.'], 404);
        }

        $registration->update(['status' => 'cancelled']);

        activity()->causedBy($user)->performedOn($event)->log('Doctor cancelled event registration');

        return response()->json(['message' => 'Registration cancelled successfully.']);
    }

    public function webinarDetail(Event $event, Request $request)
    {
        if ($event->status !== 'published' || $event->type !== 'webinar') {
            return response()->json(['message' => 'Event not found.'], 404);
        }

        $event->load('webinarDetail.learningObjectives', 'speakers');

        $user = $request->user();
        $isRegistered = $event->registrations()->where('user_id', $user->id)->where('status', '!=', 'cancelled')->exists();

        $speaker = $event->speakers->first();
        $detail = $event->webinarDetail;

        return response()->json([
            'id' => $event->id,
            'title' => $event->title,
            'banner' => $event->banner_url,
            'speaker' => $speaker ? [
                'name' => $speaker->full_name,
                'designation' => $detail?->speaker_designation,
                'image' => $speaker->photo_url,
            ] : null,
            'date' => $event->starts_at?->format('Y-m-d'),
            'start_time' => $event->starts_at?->format('H:i'),
            'end_time' => $event->ends_at?->format('H:i'),
            'cme_credits' => (float) ($detail?->cme_credits ?? 0),
            'format' => $detail?->format,
            'description' => $event->description,
            'syllabus' => $detail?->syllabus,
            'learning_objectives' => $detail?->learningObjectives->pluck('objective') ?? [],
            'registration_fee' => (float) ($detail?->registration_fee ?? 0),
            'is_registered' => $isRegistered,
        ]);
    }

    public function conferenceDetail(Event $event, Request $request)
    {
        if ($event->status !== 'published' || $event->type !== 'conference') {
            return response()->json(['message' => 'Event not found.'], 404);
        }

        $event->load('conferenceDetail.agendaItems', 'speakers');

        $user = $request->user();
        $isRegistered = $event->registrations()->where('user_id', $user->id)->where('status', '!=', 'cancelled')->exists();

        $detail = $event->conferenceDetail;

        return response()->json([
            'id' => $event->id,
            'title' => $event->title,
            'banner' => $event->banner_url,
            'duration' => $detail?->duration,
            'date_from' => $event->starts_at?->format('Y-m-d'),
            'date_to' => $event->ends_at?->format('Y-m-d'),
            'time' => $detail?->time,
            'format' => $detail?->format,
            'venue' => $detail?->venue ?? $event->location,
            'speakers' => $event->speakers->map(fn ($s) => [
                'name' => $s->full_name,
                'image' => $s->photo_url,
            ]),
            'agenda' => $detail?->agendaItems->map(fn ($item) => [
                'day' => $item->day,
                'time' => $item->time,
                'title' => $item->title,
                'description' => $item->description,
                'location' => $item->location,
            ]) ?? [],
            'price' => (float) ($detail?->price ?? 0),
            'currency' => $detail?->currency ?? 'USD',
            'is_registered' => $isRegistered,
        ]);
    }

    public function workshopDetail(Event $event, Request $request)
    {
        if ($event->status !== 'published' || $event->type !== 'workshop') {
            return response()->json(['message' => 'Event not found.'], 404);
        }

        $event->load('workshopDetail.prerequisites', 'speakers');

        $user = $request->user();
        $isRegistered = $event->registrations()->where('user_id', $user->id)->where('status', '!=', 'cancelled')->exists();

        $trainer = $event->speakers->first();
        $detail = $event->workshopDetail;

        return response()->json([
            'id' => $event->id,
            'title' => $event->title,
            'banner' => $event->banner_url,
            'trainer' => $trainer ? [
                'name' => $trainer->full_name,
                'designation' => $detail?->trainer_designation,
                'image' => $trainer->photo_url,
            ] : null,
            'date' => $event->starts_at?->format('Y-m-d'),
            'start_time' => $event->starts_at?->format('H:i'),
            'end_time' => $event->ends_at?->format('H:i'),
            'location' => $event->location,
            'fee' => (float) ($detail?->fee ?? 0),
            'currency' => $detail?->currency ?? 'USD',
            'description' => $event->description,
            'prerequisites' => $detail?->prerequisites->pluck('prerequisite') ?? [],
            'is_registered' => $isRegistered,
        ]);
    }

    public function myEvents(Request $request)
    {
        $user = $request->user();

        $registrations = EventRegistration::where('user_id', $user->id)
            ->where('status', '!=', 'cancelled')
            ->with('event.creator:id,name')
            ->orderByDesc(
                Event::select('starts_at')->whereColumn('id', 'event_registrations.event_id')
            )
            ->paginate($request->query('per_page', 15));

        $registrations->getCollection()->transform(function ($reg) {
            $reg->event->is_live = now()->between($reg->event->starts_at, $reg->event->ends_at ?? $reg->event->starts_at->copy()->addHours(2));
            return $reg;
        });

        return $this->jsonWithPagination($registrations);
    }
}

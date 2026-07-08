<?php

namespace App\Domain\Doctor\Http\Controllers\Api;

use App\Domain\Shared\Models\Event;
use App\Domain\Shared\Models\EventRegistration;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
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

        $events = $query->paginate(15);

        $user = $request->user();
        
        $events->getCollection()->transform(function ($event) use ($user) {
            $event->is_registered = $event->registrations()->where('user_id', $user->id)->where('status', '!=', 'cancelled')->exists();
            $event->is_live = now()->between($event->starts_at, $event->ends_at ?? $event->starts_at->copy()->addHours(2));
            return $event;
        });

        return response()->json($events);
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

    public function myEvents(Request $request)
    {
        $user = $request->user();
        
        $registrations = EventRegistration::where('user_id', $user->id)
            ->where('status', '!=', 'cancelled')
            ->with('event.creator:id,name')
            ->get()
            ->sortBy(function ($reg) {
                return $reg->event->starts_at;
            })
            ->values();

        $registrations->transform(function ($reg) {
            $reg->event->is_live = now()->between($reg->event->starts_at, $reg->event->ends_at ?? $reg->event->starts_at->copy()->addHours(2));
            return $reg;
        });

        return response()->json($registrations);
    }
}

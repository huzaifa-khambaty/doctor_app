<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Domain\Shared\Models\Event;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rule;

class EventController extends Controller
{
    public function index(Request $request)
    {
        Gate::authorize('events.view');

        $query = Event::query()->with('creator:id,name', 'speakers:id,full_name');

        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('type')) {
            $query->where('type', $request->type);
        }

        return response()->json($query->paginate(15));
    }

    public function store(Request $request)
    {
        Gate::authorize('events.create');

        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'type' => ['required', Rule::in(['webinar', 'conference', 'workshop'])],
            'speakers' => 'nullable|array',
            'speakers.*' => 'exists:users,id',
            'starts_at' => 'required|date|after:now',
            'ends_at' => 'nullable|date|after:starts_at',
            'timezone' => 'nullable|string|max:255',
            'location' => 'nullable|string|max:255',
            'description' => 'required|string',
            'banner' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:5120',
            'external_join_link' => 'nullable|url',
            'recording_link' => 'nullable|url',
            'enable_qa_session' => 'nullable|boolean',
            'certificate_of_participation' => 'nullable|boolean',
            'send_email_reminders' => 'nullable|boolean',
        ]);

        $bannerPath = null;
        if ($request->hasFile('banner')) {
            $bannerPath = $request->file('banner')->store('events/banners', 'public');
        }

        $event = Event::create(array_merge($validated, [
            'banner_path' => $bannerPath,
            'status' => 'draft',
            'created_by' => $request->user()->id,
            'timezone' => $validated['timezone'] ?? 'UTC',
        ]));

        if ($request->has('speakers')) {
            $event->speakers()->sync($request->speakers);
        }

        $event->load('speakers:id,full_name');

        return response()->json(['message' => 'Event created successfully.', 'event' => $event], 201);
    }

    public function show(Event $event)
    {
        Gate::authorize('view', $event);

        $event->load('creator:id,name', 'speakers:id,full_name');
        $event->registration_count = $event->registrations()->where('status', '!=', 'cancelled')->count();

        return response()->json($event);
    }

    public function update(Request $request, Event $event)
    {
       
        Gate::authorize('update', $event);

        $validated = $request->validate([
            'title' => 'sometimes|string|max:255',
            'type' => ['sometimes', Rule::in(['webinar', 'conference', 'workshop'])],
            'speakers' => 'nullable|array',
            'speakers.*' => 'exists:users,id',
            'starts_at' => 'sometimes|date', // Removed after:now so they can update past events if unpublished
            'ends_at' => 'nullable|date|after:starts_at',
            'timezone' => 'nullable|string|max:255',
            'location' => 'nullable|string|max:255',
            'description' => 'sometimes|string',
            'banner' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:5120',
            'external_join_link' => 'nullable|url',
            'recording_link' => 'nullable|url',
            'enable_qa_session' => 'nullable|boolean',
            'certificate_of_participation' => 'nullable|boolean',
            'send_email_reminders' => 'nullable|boolean',
        ]);

        if ($request->hasFile('banner')) {
            if ($event->banner_path) {
                Storage::disk('public')->delete($event->banner_path);
            }
            $validated['banner_path'] = $request->file('banner')->store('events/banners', 'public');
        }

        $event->update($validated);

        if ($request->has('speakers')) {
            $event->speakers()->sync($request->speakers);
        }

        $event->load('speakers:id,full_name');

        return response()->json(['message' => 'Event updated successfully.', 'event' => $event]);
    }

    public function updateStatus(Request $request, Event $event)
    {
        $validated = $request->validate([
            'status' => ['required', Rule::in(['draft', 'review', 'published', 'unpublished'])],
        ]);

        $status = $validated['status'];

        if ($status === 'review') {
            Gate::authorize('submitForReview', $event);
        } elseif ($status === 'published') {
            Gate::authorize('publish', $event);
        } elseif ($status === 'unpublished') {
            Gate::authorize('unpublish', $event);
        } else {
            Gate::authorize('update', $event);
        }

        $event->update(['status' => $status]);

        return response()->json(['message' => 'Event status updated successfully.']);
    }

    public function destroy(Request $request, Event $event)
    {
        Gate::authorize('delete', $event);

        $regCount = $event->registrations()->where('status', '!=', 'cancelled')->count();

        if ($regCount > 0 && !$request->has('confirm')) {
            return response()->json([
                'message' => 'Event has active registrations.',
                'registration_count' => $regCount,
            ], 422);
        }

        $event->delete();

        return response()->json([
            'message' => 'Event deleted successfully.',
            'registration_count' => $regCount,
        ]);
    }

    public function registrations(Event $event)
    {
        Gate::authorize('view', $event);

        $registrations = $event->registrations()->with('user')->paginate(15);

        return response()->json($registrations);
    }
}

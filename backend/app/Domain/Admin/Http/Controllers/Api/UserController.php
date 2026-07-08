<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Domain\Doctor\Models\User;
use App\Domain\Doctor\Events\UserVerified;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Gate;

class UserController extends Controller
{
    public function index(Request $request)
    {
        Gate::authorize('users.view');

        $query = User::query();

        if ($request->has('status')) {
            $query->status($request->status);
        }

        if ($request->has('specialties')) {
            $query->whereHas('specialties', function ($q) use ($request) {
                $q->whereIn('specialties.id', (array) $request->specialties);
            });
        }

        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('full_name', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%")
                  ->orWhere('phone', 'like', "%{$search}%");
            });
        }

        return response()->json($query->paginate(15));
    }

    public function store(Request $request)
    {
        Gate::authorize('users.create');

        $validated = $request->validate([
            'full_name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'phone' => 'required|string|max:20|unique:users',
            'password' => 'required|string|min:8',
            'specialties' => 'required|array',
            'specialties.*' => 'exists:specialties,id',
            'hospital_affiliation' => 'nullable|string|max:255',
            'qualifications' => 'nullable|string',
            'location' => 'nullable|string|max:255',
            'status' => 'nullable|in:pending,verified,rejected,suspended',
        ]);

        $validated['password'] = \Illuminate\Support\Facades\Hash::make($validated['password']);
        if (!isset($validated['status'])) {
            $validated['status'] = 'pending';
        }

        $specialties = $validated['specialties'] ?? [];
        unset($validated['specialties']);

        $user = User::create($validated);
        $user->specialties()->attach($specialties);

        return response()->json([
            'message' => 'User created successfully.',
            'user' => $user
        ], 201);
    }

    public function update(Request $request, User $user)
    {
        Gate::authorize('users.edit');

        $validated = $request->validate([
            'full_name' => 'sometimes|required|string|max:255',
            'email' => 'sometimes|required|string|email|max:255|unique:users,email,' . $user->id,
            'phone' => 'sometimes|required|string|max:20|unique:users,phone,' . $user->id,
            'password' => 'nullable|string|min:8',
            'specialties' => 'sometimes|required|array',
            'specialties.*' => 'exists:specialties,id',
            'hospital_affiliation' => 'nullable|string|max:255',
            'qualifications' => 'nullable|string',
            'location' => 'nullable|string|max:255',
            'status' => 'sometimes|required|in:pending,verified,rejected,suspended',
        ]);

        if (!empty($validated['password'])) {
            $validated['password'] = \Illuminate\Support\Facades\Hash::make($validated['password']);
        } else {
            unset($validated['password']);
        }

        if (isset($validated['specialties'])) {
            $user->specialties()->sync($validated['specialties']);
            unset($validated['specialties']);
        }

        $user->update($validated);

        return response()->json([
            'message' => 'User updated successfully.',
            'user' => $user->fresh()
        ]);
    }

    public function show(User $user)
    {
        Gate::authorize('users.view');

        $user->load('specialties', 'verifiedBy');

        return response()->json([
            'user' => $user,
            'summary' => [
                'registered_at' => $user->created_at,
                'last_active_at' => $user->last_active_at,
            ],
            'counts' => [
                'events_registered' => 0,
                'quiz_attempts' => 0,
                'content_bookmarks' => 0,
            ]
        ]);
    }

    public function verify(Request $request, User $user)
    {
        Gate::authorize('users.verify');
        if ($user->status !== 'pending') {
            return response()->json(['message' => 'User is not in pending status.'], 422);
        }

        $user->update([
            'status' => 'verified',
            'verified_at' => now(),
            'verified_by' => $request->user()->id,
            'rejection_reason' => null,
        ]);

        UserVerified::dispatch($user);

        return response()->json(['message' => 'User verified successfully.']);
    }

    public function reject(Request $request, User $user)
    {
        Gate::authorize('users.verify');
        if ($user->status !== 'pending') {
            return response()->json(['message' => 'User is not in pending status.'], 422);
        }

        $request->validate(['reason' => 'required|string']);

        $user->update([
            'status' => 'rejected',
            'rejection_reason' => $request->reason,
        ]);

        return response()->json(['message' => 'User rejected successfully.']);
    }

    public function suspend(Request $request, User $user)
    {
        Gate::authorize('users.suspend');
        if ($user->status !== 'verified') {
            return response()->json(['message' => 'Only verified users can be suspended.'], 422);
        }

        $request->validate(['reason' => 'nullable|string']);

        $user->update([
            'status' => 'suspended',
            'rejection_reason' => $request->reason, // Storing reason here or in a separate column?
        ]);

        $user->tokens()->delete();

        return response()->json(['message' => 'User suspended successfully.']);
    }

    public function reinstate(Request $request, User $user)
    {
        Gate::authorize('users.suspend');
        if ($user->status !== 'suspended') {
            return response()->json(['message' => 'Only suspended users can be reinstated.'], 422);
        }

        $user->update([
            'status' => 'verified',
            'rejection_reason' => null,
        ]);

        return response()->json(['message' => 'User reinstated successfully.']);
    }

    public function activity(User $user)
    {
        Gate::authorize('users.view');
        
        $activities = \App\Domain\Shared\Models\Activity::where(function ($q) use ($user) {
                $q->where('subject_id', $user->id)
                  ->where('subject_type', get_class($user));
            })
            ->orWhere(function ($q) use ($user) {
                $q->where('causer_id', $user->id)
                  ->where('causer_type', get_class($user));
            })
            ->with('causer')
            ->latest()
            ->paginate(15);

        $activities->getCollection()->transform(function ($activity) {
            if ($activity->causer) {
                $activity->setRelation('causer', [
                    'id' => $activity->causer->id,
                    'type' => class_basename($activity->causer_type), // e.g., 'Admin' or 'User'
                    'name' => $activity->causer->full_name ?? $activity->causer->name ?? 'Unknown',
                    'photo_url' => $activity->causer->photo_url ?? null,
                ]);
            }
            return $activity;
        });

        return response()->json($activities);
    }

    public function destroy(User $user)
    {
        Gate::authorize('users.delete');
        
        $user->delete();
        $user->tokens()->delete();

        return response()->json(['message' => 'User soft deleted successfully.']);
    }

    public function trashed(Request $request)
    {
        Gate::authorize('users.view');

        $query = User::onlyTrashed();

        return response()->json($query->paginate(15));
    }

    public function restore(Request $request, $id)
    {
        Gate::authorize('users.restore');
        
        $user = User::onlyTrashed()->findOrFail($id);
        $user->restore();

        return response()->json(['message' => 'User restored successfully.']);
    }

    public function forceDelete(Request $request, $id)
    {
        Gate::authorize('users.force_delete');
        
        $user = User::withTrashed()->findOrFail($id);
        $user->forceDelete();

        return response()->json(['message' => 'User permanently deleted.']);
    }
}

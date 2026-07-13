<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Domain\Shared\Models\Topic;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Gate;

class AdminTopicController extends Controller
{
    public function index()
    {
        Gate::authorize('quizzes.view');
        return response()->json(Topic::paginate(15));
    }

    public function store(Request $request)
    {
        Gate::authorize('quizzes.create');

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'slug' => 'required|string|max:255|unique:topics,slug',
            'icon' => 'nullable',
            'description' => 'nullable|string',
            'is_active' => 'nullable|boolean',
        ]);

        unset($validated['icon']);
        if ($request->hasFile('icon')) {
            $validated['icon'] = $request->file('icon')->store('topics/icons', 'public');
        }

        $topic = Topic::create($validated);

        return response()->json(['message' => 'Topic created successfully.', 'topic' => $topic], 201);
    }

    public function show(Topic $topic)
    {
        Gate::authorize('quizzes.view');
        return response()->json($topic);
    }

    public function update(Request $request, Topic $topic)
    {
        Gate::authorize('quizzes.edit');

        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'slug' => 'sometimes|required|string|max:255|unique:topics,slug,' . $topic->id,
            'icon' => 'nullable',
            'description' => 'nullable|string',
            'is_active' => 'nullable|boolean',
        ]);

        unset($validated['icon']);
        if ($request->hasFile('icon')) {
            if ($topic->icon) {
                \Storage::disk('public')->delete($topic->icon);
            }
            $validated['icon'] = $request->file('icon')->store('topics/icons', 'public');
        }

        $topic->update($validated);

        return response()->json(['message' => 'Topic updated successfully.', 'topic' => $topic]);
    }

    public function destroy(Topic $topic)
    {
        Gate::authorize('quizzes.delete');

        if ($topic->quizzes()->exists()) {
            return response()->json(['message' => 'Cannot delete topic with associated quizzes.'], 422);
        }

        $topic->delete();

        return response()->json(['message' => 'Topic deleted successfully.']);
    }
}
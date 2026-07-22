<?php

namespace App\Domain\Doctor\Http\Controllers\Api;

use App\Domain\Doctor\Models\User;
use App\Domain\Shared\Models\ContentLibrary;
use App\Domain\Shared\Models\Event;
use App\Domain\Shared\Models\EventRegistration;
use App\Domain\Shared\Models\Quiz;
use App\Domain\Shared\Models\QuizAttempt;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class HomeController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        $events = $this->getUpcomingEvents($user);
        $quiz = $this->getDailyChallenge($user);
        $contents = $this->getRecentContents($user);

        return response()->json([
            'hero' => [
                'title' => 'Engage. Learn. Collaborate.',
                'subtitle' => 'Join 5,000+ clinicians in the Respiratory Excellence Forum.',
                'button_text' => 'Explore Now',
            ],
            'user' => [
                'full_name' => $user->full_name,
                'photo_url' => $user->photo_url,
            ],
            'events' => $events,
            'quiz' => $quiz,
            'contents' => $contents,
        ]);
    }

    private function getUpcomingEvents(User $user): array
    {
        $eventIds = Event::published()
            // ->where('starts_at', '>=', now())
            ->orderBy('starts_at')
            ->limit(2)
            ->pluck('id');

        $registeredIds = EventRegistration::where('user_id', $user->id)
            ->whereIn('event_id', $eventIds)
            ->pluck('event_id');

        return Event::whereIn('id', $eventIds)
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(fn ($event) => [
                'id' => $event->id,
                'title' => $event->title,
                'type' => $event->type,
                'starts_at' => $event->starts_at->toISOString(),
                'banner_url' => $event->banner_url,
                'is_registered' => $registeredIds->contains($event->id),
            ])
            ->toArray();
    }

    private function getDailyChallenge(User $user): ?array
    {
        $quiz = Quiz::where('status', 'published')
            ->where(function ($q) {
                $q->whereNull('opens_at')->orWhere('opens_at', '<=', now());
            })
            ->where(function ($q) {
                $q->whereNull('closes_at')->orWhere('closes_at', '>', now());
            })
            ->withCount('questions')
            ->orderByDesc('created_at')
            ->first();

        if (!$quiz) {
            return null;
        }

        $rank = QuizAttempt::where('quiz_id', $quiz->id)
            ->where('status', 'submitted')
            ->where('score', '>', QuizAttempt::where('quiz_id', $quiz->id)
                ->where('user_id', $user->id)
                ->where('status', 'submitted')
                ->value('score') ?? -1)
            ->count() + 1;

        $hasAttempted = QuizAttempt::where('quiz_id', $quiz->id)
            ->where('user_id', $user->id)
            ->where('status', 'submitted')
            ->exists();

        $remainingSeconds = null;
        if ($quiz->closes_at && $quiz->closes_at->isFuture()) {
            $remainingSeconds = (int) now()->diffInSeconds($quiz->closes_at);
        }

        return [
            'id' => $quiz->id,
            'title' => $quiz->title,
            'description' => $quiz->description,
            'opens_at' => $quiz->opens_at?->toISOString(),
            'xp' => $quiz->questions_count * 100,
            'remaining_seconds' => $remainingSeconds,
            'banner' => $quiz->banner ? asset('storage/' . $quiz->banner) : null,
            'your_rank' => $hasAttempted ? $rank : null,
            'has_attempted' => $hasAttempted,
        ];
    }

    private function getRecentContents(User $user): array
    {
        $userSpecialtyIds = $user->specialties()->pluck('specialties.id');

        $query = ContentLibrary::published()
            ->with('type:id,name,slug');

        if ($userSpecialtyIds->isNotEmpty()) {
            $query->whereHas('specialties', fn ($q) => $q->whereIn('specialties.id', $userSpecialtyIds));
        }

        return $query->latest('published_at')
            ->limit(3)
            ->get()
            ->map(fn ($content) => [
                'id' => $content->id,
                'title' => $content->title,
                'type_slug' => $content->type->slug,
                'type_name' => $content->type->name,
                'thumbnail_url' => $content->thumbnail_url,
                'read_time' => $content->read_time,
            ])
            ->toArray();
    }
}

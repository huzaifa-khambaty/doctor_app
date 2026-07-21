<?php

namespace App\Domain\Doctor\Http\Controllers\Api;

use App\Domain\Shared\Models\ContentLibrary;
use App\Domain\Shared\Models\ContentBookmark;
use App\Domain\Shared\Models\ContentView;
use App\Domain\Shared\Models\ContentLike;
use App\Domain\Shared\Models\ContentDownload;
use App\Domain\Shared\Models\Specialty;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class ContentLibraryController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
//        $userSpecialtyIds = $user->specialties()->pluck('specialties.id');

        $query = ContentLibrary::published()
            ->with('type:id,name,slug', 'specialties:id,name');
        //    ->whereHas('specialties', fn ($q) => $q->whereIn('specialties.id', $userSpecialtyIds))
           // ->whereHas('type', fn ($q) => $q->where('slug', '!=', 'quiz'));

        $tab = $request->query('tab', 'topics');

        match ($tab) {
            'new' => $query->latest('published_at'),
            'trending' => $this->applyTrending($query),
            'saved' => $query->whereHas('bookmarks', fn ($q) => $q->where('user_id', $user->id)),
            default => null,
        };

        if ($request->has('topic_id')) {
            $query->whereHas('specialties', fn ($q) => $q->where('specialties.id', $request->topic_id));
        }

        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                  ->orWhere('description', 'like', "%{$search}%");
            });
        }

        $contents = $query->paginate($request->query('per_page', 15));

        $savedIds = $user->bookmarks()->pluck('content_id');
        $likedIds = $user->contentLikes()->pluck('content_id');

        $contents->getCollection()->transform(function ($item) use ($savedIds, $likedIds) {
            $item->is_saved = $savedIds->contains($item->id);
            $item->is_liked = $likedIds->contains($item->id);
            return $item;
        });

        $topics = Specialty::whereIn('id', function ($q) {
            $q->select('specialty_id')
              ->from('content_specialty')
              ->join('content_library', 'content_library.id', '=', 'content_specialty.content_id')
              ->where('content_library.status', 'published');
        })->get(['id', 'name']);

        return response()->json([
            'hero' => [
                'title' => 'Medical Library',
                'subtitle' => 'Access peer-reviewed pulmonary research and clinical guidelines updated daily.',
            ],
            'tabs' => ['topics', 'new', 'trending', 'saved'],
            'topics' => $topics,
            'data' => $contents->items(),
            'pagination' => [
                'page' => $contents->currentPage(),
                'per_page' => $contents->perPage(),
                'total' => $contents->total(),
                'last_page' => $contents->lastPage(),
                'has_next' => $contents->hasMorePages(),
                'has_previous' => $contents->currentPage() > 1,
            ],
        ]);
    }

    public function show(Request $request, $id)
    {
        $content = ContentLibrary::published()
            ->with('type:id,name,slug', 'specialties:id,name', 'externalLinks')
            ->findOrFail($id);

        $user = $request->user();

        // ContentView::updateOrCreate(
        //     ['user_id' => $user->id, 'content_id' => $content->id],
        //     ['created_at' => now()]
        // );
        // $content->increment('views_count');

        $contentSpecialtyIds = $content->specialties->pluck('id');
        $related = ContentLibrary::published()
            ->whereHas('specialties', fn ($q) => $q->whereIn('specialties.id', $contentSpecialtyIds))
            ->where('id', '!=', $content->id)
            ->with('type:id,name,slug')
            ->limit(5)
            ->get(['id', 'title', 'thumbnail_path', 'type_id']);

        return response()->json([
            'id' => $content->id,
            'title' => $content->title,
            'type' => $content->type->slug,
            'topic' => $content->specialties->pluck('name')->join(', '),
            'thumbnail' => $content->thumbnail_url,
            'author' => [
                'name' => $content->creator->name ?? null,
                'designation' => null,
            ],
            'published_at' => $content->published_at,
            'read_time' => $content->read_time,
            'body' => $content->description,
            'tags' => $content->specialties->pluck('name')->toArray(),
            'views' => $content->views_count,
            'likes' => $content->likes_count,
            'comments_count' => rand(5, 50),
            'is_liked' => $user->contentLikes()->where('content_id', $content->id)->exists(),
            'is_saved' => $user->bookmarks()->where('content_id', $content->id)->exists(),
            'external_url' => $content->content_link,
            'external_links' => $content->externalLinks->pluck('url'),
            'attachments' => $content->pdf_path
                ? [['name' => basename($content->pdf_path), 'url' => $content->pdf_url, 'size_mb' => round(($content->pdf_size ?? 0) / 1048576, 2)]]
                : [],
            'pages_count' => $content->pages_count ?? null,
            'downloads_count' => $content->downloads_count ?? 0,
            'webinar_url' => $content->webinar_url,
            'related_content' => $related,
        ]);
    }

    public function viewCount(Request $request, $id)
{
    $content = ContentLibrary::published()->findOrFail($id);
    $user = $request->user();

    ContentView::updateOrCreate(
        ['user_id' => $user->id, 'content_id' => $content->id],
        ['created_at' => now()]
    );
    $content->increment('views_count');

    return response()->json([
        'views_count' => $content->fresh()->views_count,
    ]);
}
    public function like(Request $request, $id)
    {
        $content = ContentLibrary::published()->findOrFail($id);
        $user = $request->user();

        ContentLike::firstOrCreate([
            'user_id' => $user->id,
            'content_id' => $content->id,
        ]);

        $content->increment('likes_count');

        return response()->json([
            'message' => 'Content liked.',
            'is_liked' => true,
            'likes_count' => $content->fresh()->likes_count,
        ]);
    }

    public function unlike(Request $request, $id)
    {
        $content = ContentLibrary::published()->findOrFail($id);
        $user = $request->user();

        ContentLike::where('user_id', $user->id)
            ->where('content_id', $content->id)
            ->delete();

        $content->decrement('likes_count');

        return response()->json([
            'message' => 'Content unliked.',
            'is_liked' => false,
            'likes_count' => $content->fresh()->likes_count,
        ]);
    }

    public function download(Request $request, $id)
    {
        $content = ContentLibrary::published()
            ->whereHas('type', fn ($q) => $q->where('slug', 'pdf'))
            ->findOrFail($id);

        $user = $request->user();

        ContentDownload::firstOrCreate([
            'user_id' => $user->id,
            'content_id' => $content->id,
        ]);

        $content->increment('downloads_count');

        return response()->json([
            'message' => 'Download recorded.',
            'url' => $content->pdf_url,
            'size_mb' => round(($content->pdf_size ?? 0) / 1048576, 2),
            'downloads_count' => $content->fresh()->downloads_count,
        ]);
    }

    public function save(Request $request, $id)
    {
        $content = ContentLibrary::published()->findOrFail($id);
        $user = $request->user();

        ContentBookmark::firstOrCreate([
            'user_id' => $user->id,
            'content_id' => $content->id,
        ]);

        return response()->json(['message' => 'Content saved successfully.']);
    }

    public function unsave(Request $request, $id)
    {
        $content = ContentLibrary::published()->findOrFail($id);
        $user = $request->user();

        ContentBookmark::where('user_id', $user->id)
            ->where('content_id', $content->id)
            ->delete();

        return response()->json(['message' => 'Content removed from saved list.']);
    }

    private function applyTrending($query)
    {
        $query->where(function ($q) {
            // PDFs with downloads > 100
            $q->whereHas('type', fn ($t) => $t->where('slug', 'pdf'))
              ->where('downloads_count', '>', 100);
        })->orWhere(function ($q) {
            // Articles with bookmarks > 100
            $q->whereHas('type', fn ($t) => $t->where('slug', 'article'))
              ->whereRaw('(SELECT COUNT(*) FROM content_bookmarks WHERE content_id = content_library.id) > 100');
        })->orWhere(function ($q) {
            // Webinars with views > 1000 AND likes > 100
            $q->whereHas('type', fn ($t) => $t->where('slug', 'webinar'))
              ->where('views_count', '>', 1000)
              ->where('likes_count', '>', 100);
        });

        $query->orderByRaw("
            CASE
                WHEN downloads_count > 100 THEN 1
                WHEN (SELECT COUNT(*) FROM content_bookmarks WHERE content_id = content_library.id) > 100 THEN 2
                WHEN views_count > 1000 AND likes_count > 100 THEN 3
                ELSE 4
            END
        ");
    }
}

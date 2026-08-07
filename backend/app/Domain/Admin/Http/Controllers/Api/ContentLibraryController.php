<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Domain\Shared\Models\ContentArticleImage;
use App\Domain\Shared\Models\ContentLibrary;
use App\Domain\Shared\Models\ContentType;
use App\Domain\Shared\Models\Specialty;
use App\Domain\Shared\Models\Event;
use App\Domain\Shared\Models\Quiz;
use App\Domain\Shared\Models\SystemLog;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\Storage;

class ContentLibraryController extends Controller
{
    private const ARTICLE_IMAGE_DIR = 'content/article-images';
    private const MAX_ARTICLE_IMAGE_BYTES = 5242880; // 5 MB

    public function index(Request $request)
    {
        Gate::authorize('content.view');

        $query = ContentLibrary::with('type:id,name,slug', 'specialties:id,name');

        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('type_id')) {
            $query->where('type_id', $request->type_id);
        }

        if ($request->has('specialty_id')) {
            $query->whereHas('specialties', fn ($q) => $q->where('specialties.id', $request->specialty_id));
        }

        if ($request->has('search')) {
            $search = $request->search;
            $query->where('title', 'like', "%{$search}%");
        }

        $contents = $query->latest()->paginate($request->query('per_page', 15));

        $stats = [
            'total' => ContentLibrary::count(),
            'webinars' => Event::where('type', 'webinar')->count(),
            'live_quizzes' => Quiz::count(),
            'upcoming_events' => Event::where('starts_at', '>', now())->count(),
        ];

        return response()->json([
            'stats' => $stats,
            'contents' => $contents,
        ]);
    }

    public function store(Request $request)
    {
        Gate::authorize('content.create');

        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'type_id' => 'required|exists:content_types,id',
            'description' => 'nullable|string',
            'specialty_ids' => 'required|array',
            'specialty_ids.*' => 'exists:specialties,id',
            'quiz_id' => 'nullable|exists:quizzes,id',
            'content_link' => 'nullable|url|max:2048',
            'external_links' => 'nullable|array',
            'external_links.*' => 'url|max:2048',
            'pdf_file' => 'nullable|file|mimes:pdf|max:10240',
            'thumbnail' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'webinar_file' => 'nullable|file|mimes:mp4,avi,mov,wmv|max:51200',
            'pages_count' => 'nullable|integer|min:0',
            'status' => 'required|in:draft,in_review,published',
            'scheduled_at' => 'nullable|date',
        ]);

        if ($request->hasFile('pdf_file')) {
            $validated['pdf_path'] = $request->file('pdf_file')->store('content/pdfs', 'public');
            $validated['pdf_size'] = $request->file('pdf_file')->getSize();
            if (empty($validated['pages_count'])) {
                $validated['pages_count'] = $this->getPdfPageCount($request->file('pdf_file'));
            }
        }

        if ($request->hasFile('thumbnail')) {
            $validated['thumbnail_path'] = $request->file('thumbnail')->store('content/thumbnails', 'public');
        }

        if ($request->hasFile('webinar_file')) {
            $validated['webinar_path'] = $request->file('webinar_file')->store('content/webinars', 'public');
        }

        unset(
            $validated['specialty_ids'],
            $validated['external_links'],
            $validated['pdf_file'],
            $validated['thumbnail'],
            $validated['webinar_file']
        );

        $validated['created_by'] = $request->user()->id;

        $content = ContentLibrary::create($validated);

        if ($content->description) {
            $content->description = $this->processBase64Images($content->description, $content->id);
            $content->save();
        }

        $content->specialties()->sync($request->specialty_ids);

        if ($request->has('external_links')) {
            foreach ($request->external_links as $index => $url) {
                $content->externalLinks()->create([
                    'url' => $url,
                    'display_order' => $index,
                ]);
            }
        }

        SystemLog::log(
            'content',
            'Content Created',
            '"' . $content->title . '" was added to the content library.',
            $request->user()->name ?? null,
            ['content_id' => $content->id, 'type_id' => $content->type_id]
        );

        return response()->json([
            'message' => 'Content created successfully.',
            'content' => $content->load('type', 'specialties', 'externalLinks'),
        ], 201);
    }

    public function show(ContentLibrary $content)
    {
        Gate::authorize('content.view');

        return response()->json([
            'content' => $content->load('type', 'specialties', 'externalLinks', 'quiz', 'creator:id,name'),
        ]);
    }

    public function update(Request $request, ContentLibrary $content)
    {
        Gate::authorize('content.edit');

        $validated = $request->validate([
            'title' => 'sometimes|required|string|max:255',
            'type_id' => 'sometimes|required|exists:content_types,id',
            'description' => 'nullable|string',
            'specialty_ids' => 'sometimes|required|array',
            'specialty_ids.*' => 'exists:specialties,id',
            'quiz_id' => 'nullable|exists:quizzes,id',
            'content_link' => 'nullable|url|max:2048',
            'external_links' => 'nullable|array',
            'external_links.*' => 'url|max:2048',
            'pdf_file' => 'nullable|file|mimes:pdf|max:10240',
            'thumbnail' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'webinar_file' => 'nullable|file|mimes:mp4,avi,mov,wmv|max:51200',
            'pages_count' => 'nullable|integer|min:0',
            'status' => 'sometimes|required|in:draft,in_review,published',
            'scheduled_at' => 'nullable|date',
        ]);

        if ($request->hasFile('pdf_file')) {
            if ($content->pdf_path) {
                Storage::disk('public')->delete($content->pdf_path);
            }
            $validated['pdf_path'] = $request->file('pdf_file')->store('content/pdfs', 'public');
            $validated['pdf_size'] = $request->file('pdf_file')->getSize();
            if (empty($validated['pages_count'])) {
                $validated['pages_count'] = $this->getPdfPageCount($request->file('pdf_file'));
            }
        }

        if ($request->hasFile('thumbnail')) {
            if ($content->thumbnail_path) {
                Storage::disk('public')->delete($content->thumbnail_path);
            }
            $validated['thumbnail_path'] = $request->file('thumbnail')->store('content/thumbnails', 'public');
        }

        if ($request->hasFile('webinar_file')) {
            if ($content->webinar_path) {
                Storage::disk('public')->delete($content->webinar_path);
            }
            $validated['webinar_path'] = $request->file('webinar_file')->store('content/webinars', 'public');
        }

        $specialtyIds = $request->specialty_ids ?? null;
        $externalLinks = $request->external_links ?? null;

        unset(
            $validated['specialty_ids'],
            $validated['external_links'],
            $validated['pdf_file'],
            $validated['thumbnail'],
            $validated['webinar_file']
        );

        $hasDescription = array_key_exists('description', $validated);
        $newDescription = $hasDescription ? $validated['description'] : null;

        if ($newDescription !== null) {
            $validated['description'] = $this->processBase64Images($newDescription, $content->id);
        }

        $content->update($validated);

        if ($hasDescription) {
            $this->reconcileArticleImages($content, $validated['description']);
        }

        if ($specialtyIds !== null) {
            $content->specialties()->sync($specialtyIds);
        }

        if ($externalLinks !== null) {
            $content->externalLinks()->delete();
            foreach ($externalLinks as $index => $url) {
                $content->externalLinks()->create([
                    'url' => $url,
                    'display_order' => $index,
                ]);
            }
        }

        return response()->json([
            'message' => 'Content updated successfully.',
            'content' => $content->load('type', 'specialties', 'externalLinks'),
        ]);
    }

    public function destroy(ContentLibrary $content)
    {
        Gate::authorize('content.delete');

        if ($content->thumbnail_path) {
            Storage::disk('public')->delete($content->thumbnail_path);
        }
        if ($content->pdf_path) {
            Storage::disk('public')->delete($content->pdf_path);
        }
        if ($content->webinar_path) {
            Storage::disk('public')->delete($content->webinar_path);
        }

        if ($content->articleImages()->exists()) {
            foreach ($content->articleImages()->get() as $image) {
                Storage::disk('public')->delete($image->path);
            }
            $content->articleImages()->delete();
        }

        $content->delete();

        return response()->json(['message' => 'Content deleted successfully.']);
    }

    public function updateStatus(Request $request, ContentLibrary $content)
    {
        Gate::authorize('content.publish');

        $validated = $request->validate([
            'status' => 'required|in:draft,in_review,published',
        ]);

        $oldStatus = $content->status;
        $newStatus = $validated['status'];

        $content->update([
            'status' => $newStatus,
            'published_at' => $newStatus === 'published' ? ($content->published_at ?? now()) : $content->published_at,
        ]);

        $statusLabel = match($newStatus) {
            'published' => 'Published',
            'in_review' => 'Submitted for Review',
            'draft' => 'Moved to Draft',
            default => ucfirst($newStatus),
        };

        SystemLog::log(
            'content',
            'Content Status Updated',
            '"' . $content->title . '" was ' . strtolower($statusLabel) . '.',
            $request->user()->name ?? null,
            ['content_id' => $content->id, 'old_status' => $oldStatus, 'new_status' => $newStatus]
        );

        return response()->json([
            'message' => 'Content status updated successfully.',
            'content' => [
                'id' => $content->id,
                'status' => $content->status,
                'published_at' => $content->published_at,
            ],
        ]);
    }

    private function processBase64Images(?string $html, int $contentId): ?string
    {
        if (empty($html)) {
            return $html;
        }

        return preg_replace_callback(
            '/<img([^>]*?)src=["\']data:image\/(png|jpe?g|gif|webp);base64,([^"\']+)["\']([^>]*?)>/i',
            function ($matches) use ($contentId) {
                $mime = strtolower($matches[2]);

                $extension = match ($mime) {
                    'png' => 'png',
                    'jpeg', 'jpg' => 'jpg',
                    'gif' => 'gif',
                    'webp' => 'webp',
                    default => 'png',
                };

                $bytes = base64_decode(preg_replace('/\s+/', '', $matches[3]), true);

                if ($bytes === false || $bytes === '' || strlen($bytes) > self::MAX_ARTICLE_IMAGE_BYTES) {
                    return $matches[0];
                }

                $filename = 'article-' . $contentId . '-' . uniqid() . '.' . $extension;
                $path = self::ARTICLE_IMAGE_DIR . '/' . $filename;

                Storage::disk('public')->put($path, $bytes);

                ContentArticleImage::create([
                    'content_library_id' => $contentId,
                    'path' => $path,
                    'filename' => $filename,
                    'mime_type' => 'image/' . $mime,
                    'size' => strlen($bytes),
                ]);

                return '<img' . $matches[1] . 'src="/storage/' . $path . '"' . $matches[4] . '>';
            },
            $html
        );
    }

    private function reconcileArticleImages(ContentLibrary $content, ?string $newHtml): void
    {
        $referenced = $this->extractArticleImagePaths($newHtml);

        foreach ($content->articleImages()->get() as $image) {
            if (!in_array($image->path, $referenced, true)) {
                Storage::disk('public')->delete($image->path);
                $image->delete();
            }
        }
    }

    private function extractArticleImagePaths(?string $html): array
    {
        if (empty($html)) {
            return [];
        }

        preg_match_all(
            '~' . preg_quote(self::ARTICLE_IMAGE_DIR, '~') . '/[A-Za-z0-9._-]+~',
            $html,
            $matches
        );

        return array_values(array_unique($matches[0] ?? []));
    }

    private function getPdfPageCount($file): int
    {
        try {
            $parser = new \Smalot\PdfParser\Parser();
            $pdf = $parser->parseFile($file->getRealPath());
            return count($pdf->getPages());
        } catch (\Exception $e) {
            return 0;
        }
    }
}

<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Domain\Shared\Models\ContentLibrary;
use App\Domain\Shared\Models\ContentType;
use App\Domain\Shared\Models\Specialty;
use App\Domain\Shared\Models\Event;
use App\Domain\Shared\Models\Quiz;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\Storage;

class ContentLibraryController extends Controller
{
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

        $content->specialties()->sync($request->specialty_ids);

        if ($request->has('external_links')) {
            foreach ($request->external_links as $index => $url) {
                $content->externalLinks()->create([
                    'url' => $url,
                    'display_order' => $index,
                ]);
            }
        }

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

        $content->update($validated);

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

        $content->delete();

        return response()->json(['message' => 'Content deleted successfully.']);
    }

    public function updateStatus(Request $request, ContentLibrary $content)
    {
        Gate::authorize('content.publish');

        $validated = $request->validate([
            'status' => 'required|in:draft,in_review,published',
        ]);

        $content->update([
            'status' => $validated['status'],
            'published_at' => $validated['status'] === 'published' ? ($content->published_at ?? now()) : $content->published_at,
        ]);

        return response()->json([
            'message' => 'Content status updated successfully.',
            'content' => [
                'id' => $content->id,
                'status' => $content->status,
                'published_at' => $content->published_at,
            ],
        ]);
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

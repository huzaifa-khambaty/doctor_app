<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Domain\Shared\Models\ContentLibrary;
use App\Domain\Shared\Models\ContentType;
use App\Domain\Shared\Models\Specialty;
use App\Domain\Admin\Models\Admin;

class ContentLibrarySeeder extends Seeder
{
    public function run(): void
    {
        $adminId = Admin::first()?->id ?? 1;

        $pdfType = ContentType::where('slug', 'pdf')->first();
        $articleType = ContentType::where('slug', 'article')->first();
        $webinarType = ContentType::where('slug', 'webinar')->first();
        $quizType = ContentType::where('slug', 'quiz')->first();

        $pulmonology = Specialty::where('name', 'Pulmonology')->first();
        $cardiology = Specialty::where('name', 'Cardiology')->first();
        $neurology = Specialty::where('name', 'Neurology')->first();

        $specialtyIds = [$pulmonology?->id, $cardiology?->id, $neurology?->id];
        $specialtyIds = array_filter($specialtyIds);

        $contents = [
            [
                'title' => 'COPD Management Guidelines 2026',
                'type_id' => $pdfType?->id,
                'description' => '<h1>COPD Management</h1><p>Comprehensive guidelines for managing Chronic Obstructive Pulmonary Disease in clinical practice.</p>',
                'status' => 'published',
                'published_at' => now()->subDays(5),
                'specialties' => [$pulmonology?->id],
            ],
            [
                'title' => 'Understanding Asthma Triggers',
                'type_id' => $articleType?->id,
                'description' => '<h1>Asthma Triggers</h1><p>A detailed article covering common and rare asthma triggers, their mechanisms, and evidence-based management strategies.</p><p>This article reviews the latest research on environmental, occupational, and pharmaceutical triggers.</p>',
                'status' => 'published',
                'published_at' => now()->subDays(3),
                'specialties' => [$pulmonology?->id],
            ],
            [
                'title' => 'Advanced Airway Management Techniques',
                'type_id' => $webinarType?->id,
                'description' => '<h1>Airway Management</h1><p>Webinar covering advanced techniques for emergency airway management.</p>',
                'status' => 'published',
                'published_at' => now()->subDays(2),
                'specialties' => [$pulmonology?->id, $cardiology?->id],
                'content_link' => 'https://example.com/webinar/airway-management',
            ],
            [
                'title' => 'Cardiac Auscultation Quiz',
                'type_id' => $quizType?->id,
                'description' => '<h1>Cardiac Auscultation</h1><p>Test your knowledge of cardiac auscultation findings.</p>',
                'status' => 'published',
                'published_at' => now()->subDay(1),
                'specialties' => [$cardiology?->id],
            ],
            [
                'title' => 'Pulmonary Function Testing Interpretation',
                'type_id' => $articleType?->id,
                'description' => '<h1>PFT Interpretation</h1><p>A step-by-step guide to interpreting pulmonary function tests including spirometry, lung volumes, and diffusion capacity.</p>',
                'status' => 'published',
                'published_at' => now()->subHours(12),
                'specialties' => [$pulmonology?->id],
            ],
            [
                'title' => 'Hypertension Management Protocol',
                'type_id' => $pdfType?->id,
                'description' => '<h1>Hypertension Protocol</h1><p>Updated protocol for managing hypertension in primary care settings.</p>',
                'status' => 'published',
                'published_at' => now()->subHours(6),
                'specialties' => [$cardiology?->id],
            ],
            [
                'title' => 'Stroke Assessment and Treatment',
                'type_id' => $articleType?->id,
                'description' => '<h1>Stroke Assessment</h1><p>Comprehensive overview of stroke assessment tools and acute treatment options.</p>',
                'status' => 'draft',
                'published_at' => null,
                'specialties' => [$neurology?->id],
            ],
            [
                'title' => 'Sleep Apnea Screening Webinar',
                'type_id' => $webinarType?->id,
                'description' => '<h1>Sleep Apnea Screening</h1><p>Learn effective screening methods for obstructive sleep apnea.</p>',
                'status' => 'in_review',
                'published_at' => null,
                'specialties' => [$pulmonology?->id],
                'content_link' => 'https://example.com/webinar/sleep-apnea',
            ],
        ];

        foreach ($contents as $index => $data) {
            $specialties = $data['specialties'] ?? [];
            unset($data['specialties']);

            $data['created_by'] = $adminId;
            $data['views_count'] = rand(50, 2000);

            $content = ContentLibrary::updateOrCreate(
                ['title' => $data['title']],
                $data
            );

            if (!empty($specialties)) {
                $content->specialties()->sync(array_filter($specialties));
            }
        }
    }
}

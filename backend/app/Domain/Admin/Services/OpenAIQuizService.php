<?php

namespace App\Domain\Admin\Services;

use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use PhpOffice\PhpWord\IOFactory as PhpWordIO;
use Spatie\PdfToText\Pdf;
use Symfony\Component\Process\Process;
use RuntimeException;

class OpenAIQuizService
{
    protected string $model;
    protected float $temperature;
    protected int $maxTokens;

    public function __construct()
    {
        $this->model = config('openai.model', 'gpt-4o');
        $this->temperature = config('openai.temperature', 0.7);
        $this->maxTokens = config('openai.max_tokens', 4000);
    }

    /**
     * Generate quiz questions using OpenAI GPT
     */
    public function generateQuiz(
        string $prompt,
        ?string $topic = null,
        int $questionCount = 10,
        string $difficulty = 'medium',
        array $questionTypes = ['single', 'multiple'],
        ?UploadedFile $document = null
    ): array {
        if (empty($topic)) {
            $topic = $this->extractTopicFromPrompt($prompt);
        }

        $documentContent = null;
        $documentFilename = null;
        $documentPath = null;

        if ($document) {
            $documentContent = $this->extractDocumentText($document);
            $documentFilename = $document->getClientOriginalName();
            $documentPath = $document->store('ai-documents', 'local');
        }

        $systemPrompt = $this->buildSystemPrompt($questionCount, $difficulty, $questionTypes);
        $userPrompt = $this->buildUserPrompt($topic, $prompt, $documentContent);

        $response = $this->callOpenAI($systemPrompt, $userPrompt);

        return [
            'questions' => $response['questions'] ?? [],
            'topic' => $topic,
            'document_filename' => $documentFilename,
            'document_path' => $documentPath,
        ];
    }

    /**
     * Extract topic from prompt text
     */
    protected function extractTopicFromPrompt(string $prompt): string
    {
        $patterns = [
            '/(?:on|about|regarding|covering|related to|of)\s+(.+?)(?:\s*,|\s*\(|\.|$)/i',
            '/(?:create|generate|make|write|build)\s+(?:\d+\s+)?(?:mcq|quiz|questions?|mcqs?)\s+(?:on|about|regarding|covering)\s+(.+?)(?:\s*,|\s*\(|\.|$)/i',
        ];

        foreach ($patterns as $pattern) {
            if (preg_match($pattern, $prompt, $matches)) {
                $topic = trim($matches[1]);
                if (mb_strlen($topic) > 5) {
                    return mb_substr($topic, 0, 255);
                }
            }
        }

        return mb_substr(trim($prompt), 0, 255);
    }

    /**
     * Call OpenAI API with chat completion
     */
    protected function callOpenAI(string $systemPrompt, string $userPrompt): array
    {
        $apiKey = config('services.openai.key');

        if (empty($apiKey)) {
            throw new RuntimeException('OpenAI API key is not configured.');
        }

        $payload = [
            'model' => $this->model,
            'messages' => [
                ['role' => 'system', 'content' => $systemPrompt],
                ['role' => 'user', 'content' => $userPrompt],
            ],
            'temperature' => $this->temperature,
            'max_tokens' => $this->maxTokens,
        ];

        $response = $this->makeHttpRequest($payload);

        $content = $response['choices'][0]['message']['content'] ?? null;

        if (!$content) {
            throw new RuntimeException('No content returned from OpenAI API.');
        }

        return $this->parseJsonResponse($content);
    }

    /**
     * Make HTTP request to OpenAI API
     */
    protected function makeHttpRequest(array $payload): array
    {
        $ch = curl_init('https://api.openai.com/v1/chat/completions');

        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => json_encode($payload),
            CURLOPT_HTTPHEADER => [
                'Content-Type: application/json',
                'Authorization: Bearer ' . config('services.openai.key'),
            ],
            CURLOPT_TIMEOUT => 120,
            CURLOPT_SSL_VERIFYPEER => true,
        ]);

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = curl_error($ch);
        curl_close($ch);

        if ($error) {
            throw new RuntimeException("OpenAI API error: {$error}");
        }

        $decoded = json_decode($response, true);

        if ($httpCode !== 200) {
            $message = $decoded['error']['message'] ?? 'Unknown error';
            throw new RuntimeException("OpenAI API returned HTTP {$httpCode}: {$message}");
        }

        return $decoded;
    }

    /**
     * Parse JSON response from OpenAI
     */
    protected function parseJsonResponse(string $content): array
    {
        $content = trim($content);

        if (str_starts_with($content, '```')) {
            $content = preg_replace('/^```(?:json)?\s*/', '', $content);
            $content = preg_replace('/\s*```$/', '', $content);
        }

        $decoded = json_decode($content, true);

        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new RuntimeException('Failed to parse OpenAI response as JSON: ' . json_last_error_msg());
        }

        if (!isset($decoded['questions']) || !is_array($decoded['questions'])) {
            throw new RuntimeException('Invalid response structure: missing questions array.');
        }

        return $decoded;
    }

    /**
     * Build system prompt for quiz generation
     */
    protected function buildSystemPrompt(int $questionCount, string $difficulty, array $questionTypes): string
    {
        $difficultyGuide = match ($difficulty) {
            'easy' => 'Focus on basic recall and understanding. Use simple, straightforward language. Test fundamental concepts.',
            'medium' => 'Mix recall with application. Include clinical scenarios requiring moderate reasoning. Test core knowledge with some clinical application.',
            'hard' => 'Focus on analysis, evaluation, and complex clinical scenarios. Include tricky distractors, nuanced explanations, and advanced concepts requiring deep understanding.',
            default => 'Mix recall with application. Include clinical scenarios requiring moderate reasoning.',
        };

        $typeGuide = in_array('multiple', $questionTypes)
            ? 'Include a mix of single-choice (exactly 1 correct answer) and multiple-choice (2-3 correct answers) questions. Clearly mark which type each question is.'
            : 'All questions must be single-choice with exactly 1 correct answer.';

        return "You are an expert medical educator creating high-quality quiz questions for healthcare professionals.

Your task is to generate exactly {$questionCount} multiple-choice questions.

DIFFICULTY LEVEL: {$difficulty}
{$difficultyGuide}

QUESTION TYPES: {$typeGuide}

RULES:
1. Generate exactly {$questionCount} questions.
2. Each question MUST have exactly 4 options.
3. Each option must have a clear explanation.
4. Mark the correct answer(s) with is_correct: true.
5. Provide a brief explanation for the question itself.
6. Ensure options are plausible distractors, not obviously wrong.
7. Use evidence-based medical information.
8. Avoid ambiguous or poorly worded questions.
9. For multiple-choice: at least 2 correct answers, at most 3.
10. For single-choice: exactly 1 correct answer.

OUTPUT FORMAT (JSON):
{
  \"questions\": [
    {
      \"question_text\": \"Question text here\",
      \"is_multiple\": false,
      \"explanation\": \"Explanation for the correct answer\",
      \"options\": [
        {\"option_text\": \"Option A\", \"is_correct\": true, \"explanation\": \"Why this is correct\"},
        {\"option_text\": \"Option B\", \"is_correct\": false, \"explanation\": \"Why this is incorrect\"},
        {\"option_text\": \"Option C\", \"is_correct\": false, \"explanation\": \"Why this is incorrect\"},
        {\"option_text\": \"Option D\", \"is_correct\": false, \"explanation\": \"Why this is incorrect\"}
      ]
    }
  ]
}

Return ONLY the JSON object, no additional text.";
    }

    /**
     * Build user prompt from topic and optional document content
     */
    protected function buildUserPrompt(string $topic, string $prompt, ?string $documentContent): string
    {
        $userPrompt = "Generate quiz questions for the following:\n\n";
        $userPrompt .= "TOPIC: {$topic}\n";
        $userPrompt .= "INSTRUCTIONS: {$prompt}\n";

        if ($documentContent) {
            $truncated = mb_substr($documentContent, 0, 8000);
            $userPrompt .= "\nREFERENCE DOCUMENT CONTENT:\n{$truncated}\n";
        }

        $userPrompt .= "\nGenerate the questions based on this information. Return the JSON response.";

        return $userPrompt;
    }

    /**
     * Extract text content from uploaded document
     */
    public function extractDocumentText(UploadedFile $file): string
    {
        $extension = strtolower($file->getClientOriginalExtension());

        return match ($extension) {
            'pdf' => $this->extractPdfText($file),
            'doc', 'docx' => $this->extractWordText($file),
            'txt' => file_get_contents($file->getRealPath()),
            default => throw new RuntimeException("Unsupported document format: {$extension}"),
        };
    }

    /**
     * Extract text from PDF
     */
    protected function extractPdfText(UploadedFile $file): string
    {
        try {
            $pdf = new Pdf();
            $text = $pdf->text($file->getRealPath());

            if (empty(trim($text))) {
                throw new RuntimeException('PDF appears to be empty or contains only images.');
            }

            return $text;
        } catch (RuntimeException $e) {
            throw $e;
        } catch (\Exception $e) {
            throw new RuntimeException('Failed to extract text from PDF: ' . $e->getMessage());
        }
    }

    /**
     * Extract text from Word document (doc/docx)
     */
    protected function extractWordText(UploadedFile $file): string
    {
        try {
            $phpWord = PhpWordIO::load($file->getRealPath());
            $text = '';

            foreach ($phpWord->getSections() as $section) {
                foreach ($section->getElements() as $element) {
                    if (method_exists($element, 'getText')) {
                        $text .= $element->getText() . "\n";
                    } elseif (method_exists($element, 'getRows')) {
                        foreach ($element->getRows() as $row) {
                            foreach ($row->getCells() as $cell) {
                                foreach ($cell->getElements() as $cellElement) {
                                    if (method_exists($cellElement, 'getText')) {
                                        $text .= $cellElement->getText() . " ";
                                    }
                                }
                            }
                            $text .= "\n";
                        }
                    }
                }
            }

            if (empty(trim($text))) {
                throw new RuntimeException('Word document appears to be empty.');
            }

            return $text;
        } catch (RuntimeException $e) {
            throw $e;
        } catch (\Exception $e) {
            throw new RuntimeException('Failed to extract text from Word document: ' . $e->getMessage());
        }
    }

    /**
     * Store document for future reference
     */
    public function storeDocument(UploadedFile $file): string
    {
        return $file->store('ai-documents', 'local');
    }
}

<?php

namespace App\Domain\Doctor\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class DoctorResource extends JsonResource
{
    public function toArray($request)
    {
        $modelData = $this->resource->toArray();

        return [
            'id' => $this->id,
            'uuid' => $this->uuid,
            'full_name' => $this->full_name,
            'email' => $this->email,
            'phone' => $this->phone,
            'specialty_ids' => $this->specialties->map(fn($s) => [
                'id' => $s->id,
                'name' => $s->name,
            ])->toArray(),
            'hospital_affiliation' => $this->hospital_affiliation,
            'photo_path' => $this->photo_path,
            'qualifications' => $this->qualifications,
            'location' => $this->location,
            'status' => $this->status,
            'biometric_enabled' => $this->biometric_enabled,
            'email_verified_at' => $modelData['email_verified_at'] ?? null,
            'phone_verified_at' => $modelData['phone_verified_at'] ?? null,
            'last_active_at' => $modelData['last_active_at'] ?? null,
            'quiz_count' => $this->submitted_quizzes_count ?? 0,
            'rank' => $this->rank_position ?? 0,
            'badge_count' => $this->user_badges_count ?? 0,
            'earned_badges' => $this->whenLoaded('userBadges', function () {
                return $this->userBadges
                    ->take(3)
                    ->map(fn ($badge) => [
                        'id' => $badge->id,
                        'name' => $badge->name,
                        'description' => $badge->description,
                        'icon' => $badge->icon_path ? asset('storage/' . $badge->icon_path) : null,
                        'earned_at' => $badge->pivot->awarded_at,
                    ]);
            }, []),
        ];
    }
}

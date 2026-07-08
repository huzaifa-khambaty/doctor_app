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
            'specialty' => $this->specialty ? [
                'id' => $this->specialty->id,
                'name' => $this->specialty->name,
                'slug' => $this->specialty->slug,
            ] : null,
            'hospital_affiliation' => $this->hospital_affiliation,
            'photo_path' => $this->photo_path,
            'qualifications' => $this->qualifications,
            'location' => $this->location,
            'status' => $this->status,
            'biometric_enabled' => $this->biometric_enabled,
            'email_verified_at' => $modelData['email_verified_at'] ?? null,
            'phone_verified_at' => $modelData['phone_verified_at'] ?? null,
            'last_active_at' => $modelData['last_active_at'] ?? null,
        ];
    }
}

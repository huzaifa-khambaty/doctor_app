<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Domain\Admin\Http\Requests\UpdateSettingsRequest;
use App\Domain\Shared\Models\Setting;
use App\Domain\Shared\Models\SystemLog;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Gate;

class SettingsController extends Controller
{
    public function index(Request $request)
    {
        Gate::authorize('settings.view');

        $settings = Setting::getSettings();

        return response()->json([
            'data' => $settings,
        ]);
    }

    public function update(UpdateSettingsRequest $request)
    {
        Gate::authorize('settings.update');

        $validated = $request->validated();

        // Handle logo upload
        if ($request->hasFile('app_logo')) {
            $validated['app_logo'] = $request->file('app_logo')->store('settings/logo', 'public');
        }

        $settings = Setting::getSettings();
        $settings->update($validated);

        // Log the update
        SystemLog::log(
            'settings',
            'Settings Updated',
            'Platform settings were updated.',
            $request->user()->name ?? null,
            ['updated_fields' => array_keys($validated)]
        );

        return response()->json([
            'message' => 'Settings updated successfully.',
            'data' => $settings->fresh(),
        ]);
    }
}

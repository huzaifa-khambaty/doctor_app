<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class PrivacyPolicyController extends Controller
{
    /**
     * Display the CareSynapse Privacy Policy page.
     */
    public function index(Request $request)
    {
        $appInfo = [
            'name' => 'CareSynapse',
            'legal_name' => 'CareSynapse',
            'package_name' => 'com.app.caresynapse',
            'logo' => asset('images/logo.png'),
            'domain' => 'https://doctorapp.bharmalsystems.net',
            'organization' => 'Bharmal Systems',
            'audience' => 'Licensed Doctors & Medical Clinicians (18+)',
            'category' => 'Medical / CME Platform',
            'contact_email' => 'support@bharmalsystems.net',
            'privacy_email' => 'privacy@bharmalsystems.net',
            'dpo_email' => 'compliance@bharmalsystems.net',
            'effective_date' => 'September 22, 2026',
            'last_updated' => 'September 22, 2026',
            'version' => '2.1.0',
        ];

        $sections = [
            [
                'id' => 'overview',
                'title' => '1. Overview & Scope',
                'icon' => 'shield-check',
                'badge' => 'General',
            ],
            [
                'id' => 'app-identity',
                'title' => '2. App Identity & Intended Audience',
                'icon' => 'stethoscope',
                'badge' => 'Audience',
            ],
            [
                'id' => 'data-collected',
                'title' => '3. Information & Data We Collect',
                'icon' => 'database',
                'badge' => 'Data Safety',
            ],
            [
                'id' => 'data-usage',
                'title' => '4. How We Use Collected Data',
                'icon' => 'cpu',
                'badge' => 'Processing',
            ],
            [
                'id' => 'third-party-services',
                'title' => '5. Third-Party Services & Processors',
                'icon' => 'share-2',
                'badge' => 'Processors',
            ],
            [
                'id' => 'permissions',
                'title' => '6. Android & Device Permissions',
                'icon' => 'lock',
                'badge' => 'Permissions',
            ],
            [
                'id' => 'data-security',
                'title' => '7. Security & Encryption Practices',
                'icon' => 'key',
                'badge' => 'Security',
            ],
            [
                'id' => 'data-retention',
                'title' => '8. Data Retention & Storage Policy',
                'icon' => 'clock',
                'badge' => 'Retention',
            ],
            [
                'id' => 'account-deletion',
                'title' => '9. Account & Data Deletion Instructions',
                'icon' => 'trash-2',
                'badge' => 'Google Policy',
                'highlight' => true,
            ],
            [
                'id' => 'user-rights',
                'title' => '10. Clinician & User Privacy Rights',
                'icon' => 'user-check',
                'badge' => 'Rights',
            ],
            [
                'id' => 'children-privacy',
                'title' => '11. Children\'s Privacy Protection',
                'icon' => 'alert-circle',
                'badge' => 'Compliance',
            ],
            [
                'id' => 'policy-changes',
                'title' => '12. Changes to This Privacy Policy',
                'icon' => 'refresh-cw',
                'badge' => 'Updates',
            ],
            [
                'id' => 'contact-us',
                'title' => '13. Contact & Grievance Officer',
                'icon' => 'mail',
                'badge' => 'Contact',
            ],
        ];

        return view('privacy-policy', compact('appInfo', 'sections'));
    }
}

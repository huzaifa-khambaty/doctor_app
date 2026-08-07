<?php

namespace App\Domain\Shared\Http\Controllers\Api;

use Illuminate\Routing\Controller;

class StaticPageController extends Controller
{
    public function terms()
    {
        return response()->json([
            'title' => 'Terms & Conditions',
            'content' => $this->termsHtml(),
            'updated_at' => '2026-08-07',
        ]);
    }

    public function privacy()
    {
        return response()->json([
            'title' => 'Privacy Policy',
            'content' => $this->privacyHtml(),
            'updated_at' => '2026-08-07',
        ]);
    }

    private function termsHtml(): string
    {
        return <<<'HTML'
<div>
    <h1>Terms &amp; Conditions</h1>

    <p>
        Welcome to our application. By accessing or using this application,
        you agree to be bound by these Terms &amp; Conditions.
        Please read them carefully before using the services.
    </p>

    <h2>1. Acceptance of Terms</h2>
    <p>
        By using this application, you acknowledge that you have read,
        understood, and agree to these Terms &amp; Conditions.
    </p>

    <h2>2. User Account</h2>
    <ul>
        <li>You are responsible for maintaining the confidentiality of your account.</li>
        <li>You must provide accurate and complete information.</li>
        <li>You are responsible for all activities performed under your account.</li>
    </ul>

    <h2>3. Acceptable Use</h2>
    <ul>
        <li>Use the application only for lawful purposes.</li>
        <li>Do not attempt unauthorized access to any system or data.</li>
        <li>Do not upload malicious software or harmful content.</li>
        <li>Do not interfere with the operation of the application.</li>
    </ul>

    <h2>4. Privacy</h2>
    <p>
        Your personal information is collected and processed in accordance
        with our Privacy Policy.
    </p>

    <h2>5. Intellectual Property</h2>
    <p>
        All content, logos, trademarks, software, and materials available
        within this application are the property of their respective owners
        and are protected by applicable intellectual property laws.
    </p>

    <h2>6. Limitation of Liability</h2>
    <p>
        The application is provided "as is" without warranties of any kind.
        We are not responsible for any direct, indirect, incidental,
        or consequential damages arising from the use of this application.
    </p>

    <h2>7. Changes to Terms</h2>
    <p>
        We reserve the right to update these Terms &amp; Conditions at any time.
        Continued use of the application after changes are published
        constitutes acceptance of the revised terms.
    </p>

    <h2>8. Termination</h2>
    <p>
        We may suspend or terminate your access to the application at our
        discretion if these Terms &amp; Conditions are violated.
    </p>

    <h2>9. Governing Law</h2>
    <p>
        These Terms &amp; Conditions shall be governed by the applicable laws
        of your jurisdiction.
    </p>

    <h2>10. Contact Us</h2>
    <p>
        If you have any questions regarding these Terms &amp; Conditions,
        please contact the application administrator.
    </p>

    <div>
        <strong>Last Updated:</strong> August 7, 2026
    </div>
</div>
HTML;
    }

    private function privacyHtml(): string
    {
        return <<<'HTML'
<div>

    <h1>Privacy Policy</h1>

    <p>
        Your privacy is important to us. This Privacy Policy explains how we
        collect, use, disclose, and protect your information when you use our
        application.
    </p>

    <h2>1. Information We Collect</h2>
    <ul>
        <li>Name and profile information.</li>
        <li>Email address and phone number.</li>
        <li>Account login credentials.</li>
        <li>Device information (device model, operating system, browser).</li>
        <li>Application usage and activity logs.</li>
        <li>Notification preferences and device tokens (if applicable).</li>
    </ul>

    <h2>2. How We Use Your Information</h2>
    <ul>
        <li>Provide and maintain our services.</li>
        <li>Authenticate your account.</li>
        <li>Improve application performance and user experience.</li>
        <li>Send important notifications and updates.</li>
        <li>Respond to customer support requests.</li>
        <li>Comply with legal obligations.</li>
    </ul>

    <h2>3. Information Sharing</h2>
    <p>
        We do not sell or rent your personal information. We may share
        information only when required by law, with trusted service providers,
        or with your consent.
    </p>

    <h2>4. Data Security</h2>
    <p>
        We implement appropriate technical and organizational measures to
        protect your information from unauthorized access, disclosure,
        alteration, or destruction.
    </p>

    <h2>5. Data Retention</h2>
    <p>
        We retain your information only for as long as necessary to provide
        our services, comply with legal obligations, resolve disputes,
        and enforce our agreements.
    </p>

    <h2>6. Your Rights</h2>
    <ul>
        <li>Access your personal information.</li>
        <li>Request correction of inaccurate information.</li>
        <li>Request deletion of your account and personal data where applicable.</li>
        <li>Withdraw consent where processing is based on consent.</li>
    </ul>

    <h2>7. Cookies and Analytics</h2>
    <p>
        The application may use cookies or similar technologies to improve
        functionality, remember preferences, and analyze usage patterns.
    </p>

    <h2>8. Third-Party Services</h2>
    <p>
        Our application may integrate with third-party services such as
        authentication, payment, analytics, cloud storage, or push
        notifications. These services have their own privacy policies.
    </p>

    <h2>9. Children's Privacy</h2>
    <p>
        Our services are not intended for children under the applicable legal
        age. We do not knowingly collect personal information from children.
    </p>

    <h2>10. Changes to This Policy</h2>
    <p>
        We may update this Privacy Policy from time to time. Any changes will
        be posted on this page with the updated effective date.
    </p>

    <h2>11. Contact Us</h2>
    <p>
        If you have any questions regarding this Privacy Policy or your
        personal information, please contact the application administrator.
    </p>

    <div>
        <strong>Effective Date:</strong> August 7, 2026
    </div>

</div>
HTML;
    }
}

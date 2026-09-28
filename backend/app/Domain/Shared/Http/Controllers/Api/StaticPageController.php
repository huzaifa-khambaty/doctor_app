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
    <h1>CareSynapse Privacy Policy</h1>

    <p>
        Your privacy and trust are paramount to us. This Privacy Policy explains how <strong>CareSynapse</strong>
        ("the App", operated by <strong>Bharmal Systems</strong>) collects, utilizes, safeguards, and handles personal and professional data for licensed clinicians and healthcare practitioners.
    </p>

    <h2>1. Information We Collect</h2>
    <ul>
        <li><strong>Personal &amp; Contact:</strong> Name, email address, phone number (for OTP verification and login), profile picture (optional).</li>
        <li><strong>Professional Credentials:</strong> Medical specialty, hospital/clinic affiliation, and medical registration ID. (Note: The app does not collect patient records or PHI).</li>
        <li><strong>App Activity &amp; Learning:</strong> Quiz scores, leaderboard rankings, webinar registrations, bookmarked articles, and liaison query messages.</li>
        <li><strong>Device &amp; Diagnostics:</strong> Device model, OS version, push notification tokens (Firebase Cloud Messaging), and crash logs.</li>
    </ul>

    <h2>2. How We Use Your Information</h2>
    <ul>
        <li>Authenticate doctor accounts and maintain profile security.</li>
        <li>Curate personalized CME medical content, webinars, and quizzes.</li>
        <li>Deliver real-time push alerts for registered webinars and query replies.</li>
        <li>Facilitate direct clinical/technical queries with our medical liaison team.</li>
    </ul>

    <h2>3. Security &amp; Biometrics</h2>
    <p>
        All network data is transmitted securely over <strong>HTTPS (TLS 1.3)</strong>. Biometric authentication (fingerprint / Face ID) is processed entirely by your local device operating system; biometric credentials are never sent to or stored on our servers.
    </p>

    <h2>4. Third-Party Processors</h2>
    <p>
        We do not sell your personal data. We utilize trusted infrastructure processors including <strong>Firebase Cloud Messaging (Google)</strong> for notifications and <strong>Pusher</strong> for real-time live events.
    </p>

    <h2>5. Account &amp; Data Deletion Instructions</h2>
    <p>
        In accordance with Google Play's User Data policy, you can delete your account and all associated personal data anytime using either method:
    </p>
    <ul>
        <li><strong>In-App Deletion:</strong> Go to <em>Profile &rarr; Delete Account</em> and confirm. Your personal data, credentials, and query history will be permanently deleted.</li>
        <li><strong>External Web / Email Request:</strong> If you uninstalled the app, email us at <a href="mailto:privacy@bharmalsystems.net">privacy@bharmalsystems.net</a> with subject <code>Delete My CareSynapse Account</code>.</li>
    </ul>

    <h2>6. Children's Privacy</h2>
    <p>
        CareSynapse is designed strictly for adult healthcare professionals (18+) and does not knowingly collect data from children.
    </p>

    <h2>7. Contact &amp; Grievances</h2>
    <p>
        For questions or data deletion requests, contact our Data Protection Officer at:
        <br>
        <strong>Email:</strong> <a href="mailto:privacy@bharmalsystems.net">privacy@bharmalsystems.net</a> / <a href="mailto:support@bharmalsystems.net">support@bharmalsystems.net</a>
        <br>
        <strong>Official Public Policy URL:</strong> <a href="https://doctorapp.bharmalsystems.net/privacy-policy">https://doctorapp.bharmalsystems.net/privacy-policy</a>
    </p>

    <div>
        <strong>Last Updated:</strong> September 22, 2026
    </div>
</div>
HTML;
    }
}


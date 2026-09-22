<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Privacy Policy | {{ $appInfo['name'] }} - Continuing Medical Education Platform</title>
    
    <!-- Meta tags for SEO & Play Store Reviewers -->
    <meta name="description" content="Official Privacy Policy and Data Safety Declaration for {{ $appInfo['name'] }} ({{ $appInfo['package_name'] }}). Learn how we collect, protect, and handle clinician data and account deletion.">
    <meta name="robots" content="index, follow">
    <link rel="canonical" href="{{ url('/privacy-policy') }}">
    <link rel="icon" type="image/png" href="{{ $appInfo['logo'] }}">

    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: {
                            50: '#f0fdfa',
                            100: '#ccfbf1',
                            200: '#99f6e4',
                            300: '#5eead4',
                            400: '#2dd4bf',
                            500: '#14b8a6',
                            600: '#0d9488',
                            700: '#0f766e',
                            800: '#115e59',
                            900: '#134e4a',
                            950: '#042f2e',
                        },
                        navy: {
                            800: '#0f172a',
                            900: '#020617',
                        }
                    }
                }
            }
        }
    </script>
    
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest"></script>

    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Plus+Jakarta+Sans:wght@500;600;700;800&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
        h1, h2, h3, .heading-font {
            font-family: 'Plus Jakarta Sans', sans-serif;
        }
        .section-anchor {
            scroll-margin-top: 6rem;
        }
        .custom-scrollbar::-webkit-scrollbar {
            width: 5px;
        }
        .custom-scrollbar::-webkit-scrollbar-track {
            background: #f1f5f9;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb {
            background: #cbd5e1;
            border-radius: 4px;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb:hover {
            background: #94a3b8;
        }
        .active-nav {
            border-left-color: #0d9488 !important;
            color: #0f766e !important;
            background-color: #f0fdfa !important;
            font-weight: 600 !important;
        }
        @media print {
            .no-print {
                display: none !important;
            }
            .section-anchor {
                page-break-inside: avoid;
            }
        }
    </style>
</head>
<body class="bg-slate-50 text-slate-800 antialiased min-h-screen flex flex-col selection:bg-teal-100 selection:text-teal-900">

    <!-- Top Announcement / Compliance Bar -->
    <div class="bg-slate-900 text-slate-300 text-xs py-2 px-4 text-center border-b border-slate-800 flex items-center justify-center gap-2 flex-wrap no-print">
        <span class="inline-flex items-center px-2 py-0.5 rounded text-[11px] font-medium bg-teal-950 text-teal-300 border border-teal-800">
            <i data-lucide="shield-check" class="w-3.5 h-3.5 mr-1 inline"></i> Verified Play Store Listing Policy
        </span>
        <span>Target Audience: <strong>Licensed Physicians & Healthcare Professionals (18+)</strong></span>
        <span class="hidden md:inline">•</span>
        <span>Package ID: <code class="font-mono text-teal-300 bg-slate-800 px-1.5 py-0.5 rounded">{{ $appInfo['package_name'] }}</code></span>
    </div>

    <!-- Header Navigation -->
    <header class="sticky top-0 z-40 bg-white/95 backdrop-blur border-b border-slate-200 shadow-sm no-print">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
            <div class="flex items-center gap-3">
                <img src="{{ $appInfo['logo'] }}" alt="{{ $appInfo['name'] }}" class="w-10 h-10 rounded-xl object-contain shadow-md shadow-teal-600/10">
                <div>
                    <a href="{{ $appInfo['domain'] }}" class="text-xl font-extrabold tracking-tight text-slate-900 flex items-center gap-1.5">
                        {{ $appInfo['name'] }}
                        <span class="text-xs font-semibold px-2 py-0.5 bg-teal-100 text-teal-800 rounded-full">Legal</span>
                    </a>
                    <p class="text-xs text-slate-500 hidden sm:block">Continuing Medical Education (CME) Platform</p>
                </div>
            </div>

            <div class="flex items-center gap-2 sm:gap-3">
                <!-- Live Search Bar -->
                <div class="relative hidden sm:block">
                    <i data-lucide="search" class="w-4 h-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
                    <input type="text" id="policySearch" placeholder="Search policy topics..." 
                           class="w-48 lg:w-64 pl-9 pr-3 py-1.5 text-xs bg-slate-100 border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-teal-500 focus:bg-white transition-all"
                           onkeyup="filterSections()">
                </div>

                <!-- Account Deletion Quick Button -->
                <a href="#account-deletion" class="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-medium text-red-700 bg-red-50 hover:bg-red-100 border border-red-200 rounded-lg transition-colors">
                    <i data-lucide="user-x" class="w-3.5 h-3.5"></i>
                    <span>Delete Account</span>
                </a>

                <!-- Print Button -->
                <button onclick="window.print()" class="inline-flex items-center gap-1 px-3 py-1.5 text-xs font-medium text-slate-700 bg-slate-100 hover:bg-slate-200 rounded-lg transition-colors" title="Print or Save as PDF">
                    <i data-lucide="printer" class="w-3.5 h-3.5"></i>
                    <span class="hidden md:inline">Print / PDF</span>
                </button>
            </div>
        </div>
    </header>

    <!-- Hero Banner -->
    <section class="bg-gradient-to-b from-slate-900 via-slate-800 to-slate-900 text-white py-12 px-4 sm:px-6 lg:px-8 border-b border-slate-700 relative overflow-hidden">
        <!-- Background accents -->
        <div class="absolute -top-24 -right-24 w-96 h-96 bg-teal-500/10 rounded-full blur-3xl pointer-events-none"></div>
        <div class="absolute -bottom-24 -left-24 w-96 h-96 bg-cyan-500/10 rounded-full blur-3xl pointer-events-none"></div>

        <div class="max-w-7xl mx-auto relative z-10">
            <div class="max-w-3xl">
                <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-medium bg-teal-500/20 text-teal-300 border border-teal-500/30 mb-4">
                    <i data-lucide="lock" class="w-3.5 h-3.5"></i>
                    <span>Google Play Data Safety &amp; Privacy Compliance</span>
                </div>
                <h1 class="text-3xl sm:text-4xl font-extrabold tracking-tight text-white mb-3">
                    Privacy Policy &amp; Data Safety
                </h1>
                <p class="text-slate-300 text-sm sm:text-base leading-relaxed mb-6">
                    This Privacy Policy details how <strong>{{ $appInfo['name'] }}</strong> (an application operated by <strong>{{ $appInfo['organization'] }}</strong>) collects, utilizes, safeguards, and provides user control over personal and professional information for practicing healthcare providers.
                </p>

                <!-- Metadata badges -->
                <div class="flex flex-wrap gap-4 text-xs text-slate-300 pt-2 border-t border-slate-700/80">
                    <div class="flex items-center gap-1.5">
                        <i data-lucide="calendar" class="w-4 h-4 text-teal-400"></i>
                        <span>Effective Date: <strong>{{ $appInfo['effective_date'] }}</strong></span>
                    </div>
                    <div class="flex items-center gap-1.5">
                        <i data-lucide="clock" class="w-4 h-4 text-teal-400"></i>
                        <span>Last Updated: <strong>{{ $appInfo['last_updated'] }}</strong></span>
                    </div>
                    <div class="flex items-center gap-1.5">
                        <i data-lucide="box" class="w-4 h-4 text-teal-400"></i>
                        <span>App ID: <strong class="font-mono">{{ $appInfo['package_name'] }}</strong></span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Content Layout -->
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 flex-grow">
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
            
            <!-- Sticky Sidebar Navigation (Desktop) -->
            <aside class="hidden lg:block lg:col-span-4 xl:col-span-3 no-print">
                <div class="sticky top-24 space-y-4">
                    <div class="bg-white rounded-2xl p-5 border border-slate-200/80 shadow-sm">
                        <div class="flex items-center justify-between mb-3 pb-2 border-b border-slate-100">
                            <h2 class="text-xs font-bold uppercase tracking-wider text-slate-500">Table of Contents</h2>
                            <span class="text-[11px] font-semibold text-teal-600 bg-teal-50 px-2 py-0.5 rounded-full">{{ count($sections) }} Sections</span>
                        </div>
                        <nav id="sidebarNav" class="space-y-1 max-h-[calc(100vh-14rem)] overflow-y-auto custom-scrollbar pr-1">
                            @foreach ($sections as $section)
                                <a href="#{{ $section['id'] }}" 
                                   class="nav-link flex items-center justify-between px-3 py-2 text-xs font-medium text-slate-600 hover:text-teal-700 hover:bg-slate-50 rounded-lg border-l-2 border-transparent transition-all {{ isset($section['highlight']) ? 'text-red-700 font-semibold' : '' }}">
                                    <span class="truncate">{{ $section['title'] }}</span>
                                    @if(isset($section['highlight']))
                                        <span class="ml-1.5 px-1.5 py-0.5 text-[10px] font-bold bg-red-100 text-red-700 rounded">Policy</span>
                                    @endif
                                </a>
                            @endforeach
                        </nav>
                    </div>

                    <!-- Quick Support Card -->
                    <div class="bg-gradient-to-br from-teal-900 to-slate-900 rounded-2xl p-4 text-white shadow-sm">
                        <div class="flex items-center gap-2 mb-2 text-teal-300 text-xs font-semibold">
                            <i data-lucide="help-circle" class="w-4 h-4"></i>
                            <span>Need Assistance?</span>
                        </div>
                        <p class="text-[12px] text-slate-300 leading-relaxed mb-3">
                            Have questions regarding clinician data privacy or request removal?
                        </p>
                        <a href="mailto:{{ $appInfo['privacy_email'] }}" class="inline-flex items-center justify-center w-full px-3 py-2 text-xs font-semibold text-slate-900 bg-teal-400 hover:bg-teal-300 rounded-lg transition-colors">
                            <i data-lucide="mail" class="w-3.5 h-3.5 mr-1.5"></i>
                            Contact Privacy Officer
                        </a>
                    </div>
                </div>
            </aside>

            <!-- Policy Content Column -->
            <article class="lg:col-span-8 xl:col-span-9 space-y-10">

                <!-- Summary Overview Highlights -->
                <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                    <div class="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-start gap-3">
                        <div class="p-2 bg-teal-50 text-teal-700 rounded-lg">
                            <i data-lucide="lock" class="w-5 h-5"></i>
                        </div>
                        <div>
                            <h3 class="text-xs font-bold text-slate-900">Encrypted in Transit</h3>
                            <p class="text-[11px] text-slate-500 mt-0.5">All transmissions strictly use HTTPS/TLS 1.3 encryption.</p>
                        </div>
                    </div>
                    <div class="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-start gap-3">
                        <div class="p-2 bg-indigo-50 text-indigo-700 rounded-lg">
                            <i data-lucide="fingerprint" class="w-5 h-5"></i>
                        </div>
                        <div>
                            <h3 class="text-xs font-bold text-slate-900">Biometric Isolation</h3>
                            <p class="text-[11px] text-slate-500 mt-0.5">Biometric data is processed locally by the device OS and never stored on servers.</p>
                        </div>
                    </div>
                    <div class="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-start gap-3">
                        <div class="p-2 bg-red-50 text-red-700 rounded-lg">
                            <i data-lucide="user-x" class="w-5 h-5"></i>
                        </div>
                        <div>
                            <h3 class="text-xs font-bold text-slate-900">Account Deletion</h3>
                            <p class="text-[11px] text-slate-500 mt-0.5">Complete account and data deletion available in-app and via external URL.</p>
                        </div>
                    </div>
                </div>

                <!-- SECTION 1: Overview & Scope -->
                <section id="overview" class="section-anchor bg-white rounded-2xl p-6 sm:p-8 border border-slate-200/90 shadow-sm transition-all">
                    <div class="flex items-center justify-between pb-4 border-b border-slate-100 mb-6">
                        <div class="flex items-center gap-3">
                            <div class="p-2.5 bg-teal-100 text-teal-800 rounded-xl">
                                <i data-lucide="shield-check" class="w-5 h-5"></i>
                            </div>
                            <div>
                                <span class="text-xs font-bold text-teal-700 uppercase tracking-wider">Section 1</span>
                                <h2 class="text-lg sm:text-xl font-bold text-slate-900">Overview &amp; Scope</h2>
                            </div>
                        </div>
                        <button onclick="copySectionLink('overview')" class="text-slate-400 hover:text-teal-600 transition-colors" title="Copy section link">
                            <i data-lucide="link" class="w-4 h-4"></i>
                        </button>
                    </div>

                    <div class="prose prose-slate max-w-none text-sm leading-relaxed space-y-4 text-slate-700">
                        <p>
                            Welcome to <strong>{{ $appInfo['name'] }}</strong> ("the App", "our platform"), designed and operated by <strong>{{ $appInfo['organization'] }}</strong> ("we", "our", or "us"). 
                            {{ $appInfo['name'] }} is a continuing medical education (CME) and professional engagement platform built specifically for licensed doctors and healthcare practitioners.
                        </p>
                        <p>
                            We are committed to maintaining the trust and confidence of our users. This Privacy Policy outlines what information is collected when you use our mobile application and website services (accessible at <a href="{{ $appInfo['domain'] }}" class="text-teal-600 font-medium hover:underline">{{ $appInfo['domain'] }}</a>), how that information is utilized, the safeguards implemented to protect it, and the controls available to you regarding your account and personal data.
                        </p>
                        <div class="bg-teal-50 border-l-4 border-teal-600 p-4 rounded-r-xl">
                            <p class="text-xs text-teal-950">
                                <strong>Professional Platform Notice:</strong> {{ $appInfo['name'] }} is a business-to-clinician platform. It is <strong>not</strong> designed for patients or the general public, and does not record or store patient health records (PHI/EMR data).
                            </p>
                        </div>
                    </div>
                </section>

                <!-- SECTION 2: App Identity & Intended Audience -->
                <section id="app-identity" class="section-anchor bg-white rounded-2xl p-6 sm:p-8 border border-slate-200/90 shadow-sm transition-all">
                    <div class="flex items-center justify-between pb-4 border-b border-slate-100 mb-6">
                        <div class="flex items-center gap-3">
                            <div class="p-2.5 bg-cyan-100 text-cyan-800 rounded-xl">
                                <i data-lucide="stethoscope" class="w-5 h-5"></i>
                            </div>
                            <div>
                                <span class="text-xs font-bold text-cyan-700 uppercase tracking-wider">Section 2</span>
                                <h2 class="text-lg sm:text-xl font-bold text-slate-900">App Identity &amp; Intended Audience</h2>
                            </div>
                        </div>
                        <button onclick="copySectionLink('app-identity')" class="text-slate-400 hover:text-teal-600 transition-colors" title="Copy section link">
                            <i data-lucide="link" class="w-4 h-4"></i>
                        </button>
                    </div>

                    <div class="space-y-4 text-sm text-slate-700 leading-relaxed">
                        <p>
                            To comply with Google Play's Families Policy and Data Safety requirements:
                        </p>
                        <div class="overflow-x-auto">
                            <table class="min-w-full text-xs border border-slate-200 rounded-lg overflow-hidden">
                                <thead class="bg-slate-100 text-slate-700 font-semibold">
                                    <tr>
                                        <th class="py-2.5 px-4 text-left border-b border-slate-200">Specification</th>
                                        <th class="py-2.5 px-4 text-left border-b border-slate-200">Details</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-200">
                                    <tr>
                                        <td class="py-2.5 px-4 font-semibold text-slate-800">Application Name</td>
                                        <td class="py-2.5 px-4">{{ $appInfo['name'] }}</td>
                                    </tr>
                                    <tr>
                                        <td class="py-2.5 px-4 font-semibold text-slate-800">Android Package ID</td>
                                        <td class="py-2.5 px-4 font-mono text-teal-700">{{ $appInfo['package_name'] }}</td>
                                    </tr>
                                    <tr>
                                        <td class="py-2.5 px-4 font-semibold text-slate-800">Target Audience</td>
                                        <td class="py-2.5 px-4">{{ $appInfo['audience'] }}</td>
                                    </tr>
                                    <tr>
                                        <td class="py-2.5 px-4 font-semibold text-slate-800">Age Rating</td>
                                        <td class="py-2.5 px-4">18+ (Strictly not directed toward or intended for children)</td>
                                    </tr>
                                    <tr>
                                        <td class="py-2.5 px-4 font-semibold text-slate-800">App Category</td>
                                        <td class="py-2.5 px-4">Medical / Health &amp; Continuing Education</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </section>

                <!-- SECTION 3: Information & Data We Collect -->
                <section id="data-collected" class="section-anchor bg-white rounded-2xl p-6 sm:p-8 border border-slate-200/90 shadow-sm transition-all">
                    <div class="flex items-center justify-between pb-4 border-b border-slate-100 mb-6">
                        <div class="flex items-center gap-3">
                            <div class="p-2.5 bg-blue-100 text-blue-800 rounded-xl">
                                <i data-lucide="database" class="w-5 h-5"></i>
                            </div>
                            <div>
                                <span class="text-xs font-bold text-blue-700 uppercase tracking-wider">Section 3</span>
                                <h2 class="text-lg sm:text-xl font-bold text-slate-900">Information &amp; Data We Collect</h2>
                            </div>
                        </div>
                        <button onclick="copySectionLink('data-collected')" class="text-slate-400 hover:text-teal-600 transition-colors" title="Copy section link">
                            <i data-lucide="link" class="w-4 h-4"></i>
                        </button>
                    </div>

                    <div class="space-y-4 text-sm text-slate-700 leading-relaxed">
                        <p>
                            In alignment with our <strong>Google Play Data Safety Declaration</strong>, we collect only the data necessary to provide core educational and networking functionality:
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 pt-2">
                            <!-- Personal info -->
                            <div class="border border-slate-200 rounded-xl p-4 bg-slate-50/60">
                                <div class="flex items-center gap-2 font-bold text-slate-900 text-xs uppercase mb-2 text-teal-800">
                                    <i data-lucide="user" class="w-4 h-4 text-teal-600"></i>
                                    <span>Personal &amp; Contact Info</span>
                                </div>
                                <ul class="list-disc list-inside text-xs space-y-1.5 text-slate-600">
                                    <li><strong>Full Name</strong> (identification on certificates &amp; queries)</li>
                                    <li><strong>Email Address</strong> (account credential &amp; OTP verification)</li>
                                    <li><strong>Phone Number</strong> (account security &amp; OTP verification)</li>
                                    <li><strong>Profile Photo</strong> (optional, clinician-uploaded)</li>
                                </ul>
                            </div>

                            <!-- Professional info -->
                            <div class="border border-slate-200 rounded-xl p-4 bg-slate-50/60">
                                <div class="flex items-center gap-2 font-bold text-slate-900 text-xs uppercase mb-2 text-teal-800">
                                    <i data-lucide="award" class="w-4 h-4 text-teal-600"></i>
                                    <span>Professional Information</span>
                                </div>
                                <ul class="list-disc list-inside text-xs space-y-1.5 text-slate-600">
                                    <li><strong>Medical Specialty</strong> (to tailor CME articles &amp; webinars)</li>
                                    <li><strong>Hospital / Clinic Affiliation</strong> (for networking)</li>
                                    <li><strong>Medical License / Reg. ID</strong> (for professional verification)</li>
                                </ul>
                            </div>

                            <!-- App Activity -->
                            <div class="border border-slate-200 rounded-xl p-4 bg-slate-50/60">
                                <div class="flex items-center gap-2 font-bold text-slate-900 text-xs uppercase mb-2 text-teal-800">
                                    <i data-lucide="activity" class="w-4 h-4 text-teal-600"></i>
                                    <span>App Activity &amp; Learning Progress</span>
                                </div>
                                <ul class="list-disc list-inside text-xs space-y-1.5 text-slate-600">
                                    <li><strong>Quiz &amp; Assessment Results</strong> (scores, leaderboards, badges)</li>
                                    <li><strong>Webinar &amp; Event Registrations</strong> (session attendance)</li>
                                    <li><strong>Saved &amp; Bookmarked Articles</strong> (offline library sync)</li>
                                    <li><strong>Clinical Query Threads</strong> (liaison support communication)</li>
                                </ul>
                            </div>

                            <!-- Diagnostics -->
                            <div class="border border-slate-200 rounded-xl p-4 bg-slate-50/60">
                                <div class="flex items-center gap-2 font-bold text-slate-900 text-xs uppercase mb-2 text-teal-800">
                                    <i data-lucide="smartphone" class="w-4 h-4 text-teal-600"></i>
                                    <span>Technical &amp; Device Diagnostics</span>
                                </div>
                                <ul class="list-disc list-inside text-xs space-y-1.5 text-slate-600">
                                    <li><strong>Device Model &amp; OS Version</strong> (compatibility &amp; bug fixes)</li>
                                    <li><strong>Push Notification Tokens (FCM)</strong> (event &amp; query alerts)</li>
                                    <li><strong>Crash Logs &amp; Performance Metrics</strong> (system stability)</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- SECTION 4: How We Use Collected Data -->
                <section id="data-usage" class="section-anchor bg-white rounded-2xl p-6 sm:p-8 border border-slate-200/90 shadow-sm transition-all">
                    <div class="flex items-center justify-between pb-4 border-b border-slate-100 mb-6">
                        <div class="flex items-center gap-3">
                            <div class="p-2.5 bg-indigo-100 text-indigo-800 rounded-xl">
                                <i data-lucide="cpu" class="w-5 h-5"></i>
                            </div>
                            <div>
                                <span class="text-xs font-bold text-indigo-700 uppercase tracking-wider">Section 4</span>
                                <h2 class="text-lg sm:text-xl font-bold text-slate-900">How We Use Collected Data</h2>
                            </div>
                        </div>
                        <button onclick="copySectionLink('data-usage')" class="text-slate-400 hover:text-teal-600 transition-colors" title="Copy section link">
                            <i data-lucide="link" class="w-4 h-4"></i>
                        </button>
                    </div>

                    <div class="space-y-3 text-sm text-slate-700 leading-relaxed">
                        <p>We process your data strictly under the following lawful bases and purposes:</p>
                        <div class="space-y-2.5 pt-1">
                            <div class="flex items-start gap-3 p-3 bg-slate-50 rounded-xl">
                                <i data-lucide="check-circle" class="w-4 h-4 text-teal-600 mt-0.5 flex-shrink-0"></i>
                                <div class="text-xs">
                                    <strong class="text-slate-900">Authentication &amp; Account Security:</strong> 
                                    Verifying doctor identity via email/phone OTP, session tokens, and biometric unlock.
                                </div>
                            </div>
                            <div class="flex items-start gap-3 p-3 bg-slate-50 rounded-xl">
                                <i data-lucide="check-circle" class="w-4 h-4 text-teal-600 mt-0.5 flex-shrink-0"></i>
                                <div class="text-xs">
                                    <strong class="text-slate-900">Personalized CME Feed:</strong> 
                                    Curating relevant webinars, clinical trials, topic-specific quizzes, and guidelines based on selected specialties.
                                </div>
                            </div>
                            <div class="flex items-start gap-3 p-3 bg-slate-50 rounded-xl">
                                <i data-lucide="check-circle" class="w-4 h-4 text-teal-600 mt-0.5 flex-shrink-0"></i>
                                <div class="text-xs">
                                    <strong class="text-slate-900">CME Assessment &amp; Milestone Tracking:</strong> 
                                    Recording assessment scores, calculating peer leaderboards, and issuing completion badges.
                                </div>
                            </div>
                            <div class="flex items-start gap-3 p-3 bg-slate-50 rounded-xl">
                                <i data-lucide="check-circle" class="w-4 h-4 text-teal-600 mt-0.5 flex-shrink-0"></i>
                                <div class="text-xs">
                                    <strong class="text-slate-900">Direct Medical Liaison Queries:</strong> 
                                    Facilitating direct communication between clinicians and our medical panel for clinical/technical guidance.
                                </div>
                            </div>
                            <div class="flex items-start gap-3 p-3 bg-slate-50 rounded-xl">
                                <i data-lucide="check-circle" class="w-4 h-4 text-teal-600 mt-0.5 flex-shrink-0"></i>
                                <div class="text-xs">
                                    <strong class="text-slate-900">Transactional Communications:</strong> 
                                    Sending webinar reminders, query resolution notifications, and critical security notices.
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- SECTION 5: Third-Party Services & Processors -->
                <section id="third-party-services" class="section-anchor bg-white rounded-2xl p-6 sm:p-8 border border-slate-200/90 shadow-sm transition-all">
                    <div class="flex items-center justify-between pb-4 border-b border-slate-100 mb-6">
                        <div class="flex items-center gap-3">
                            <div class="p-2.5 bg-violet-100 text-violet-800 rounded-xl">
                                <i data-lucide="share-2" class="w-5 h-5"></i>
                            </div>
                            <div>
                                <span class="text-xs font-bold text-violet-700 uppercase tracking-wider">Section 5</span>
                                <h2 class="text-lg sm:text-xl font-bold text-slate-900">Third-Party Services &amp; Processors</h2>
                            </div>
                        </div>
                        <button onclick="copySectionLink('third-party-services')" class="text-slate-400 hover:text-teal-600 transition-colors" title="Copy section link">
                            <i data-lucide="link" class="w-4 h-4"></i>
                        </button>
                    </div>

                    <div class="space-y-4 text-sm text-slate-700 leading-relaxed">
                        <p>
                            We do <strong>not</strong> sell, rent, or trade your personal or professional data to any third-party advertisers or data brokers. We share data only with designated cloud infrastructure and service processors under strict data protection agreements:
                        </p>

                        <div class="space-y-3">
                            <div class="p-3.5 border border-slate-200 rounded-xl flex items-start gap-3 bg-slate-50/50">
                                <div class="w-8 h-8 rounded-lg bg-amber-100 text-amber-800 flex items-center justify-center font-bold text-xs flex-shrink-0">
                                    FCM
                                </div>
                                <div class="text-xs space-y-1">
                                    <strong class="text-slate-900">Firebase Cloud Messaging (Google LLC)</strong>
                                    <p class="text-slate-600">Used for dispatching real-time push notifications regarding event registrations, query updates, and daily quizzes. Device tokens are transmitted securely.</p>
                                    <a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener" class="text-teal-600 hover:underline inline-block mt-0.5">Firebase Privacy Policy &rarr;</a>
                                </div>
                            </div>

                            <div class="p-3.5 border border-slate-200 rounded-xl flex items-start gap-3 bg-slate-50/50">
                                <div class="w-8 h-8 rounded-lg bg-purple-100 text-purple-800 flex items-center justify-center font-bold text-xs flex-shrink-0">
                                    PUSHER
                                </div>
                                <div class="text-xs space-y-1">
                                    <strong class="text-slate-900">Pusher / Real-Time WebSocket Infrastructure</strong>
                                    <p class="text-slate-600">Used for live interaction sync during interactive webinars, leaderboards, and clinical queries.</p>
                                    <a href="https://pusher.com/legal/privacy-policy" target="_blank" rel="noopener" class="text-teal-600 hover:underline inline-block mt-0.5">Pusher Privacy Policy &rarr;</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- SECTION 6: Android & Device Permissions -->
                <section id="permissions" class="section-anchor bg-white rounded-2xl p-6 sm:p-8 border border-slate-200/90 shadow-sm transition-all">
                    <div class="flex items-center justify-between pb-4 border-b border-slate-100 mb-6">
                        <div class="flex items-center gap-3">
                            <div class="p-2.5 bg-emerald-100 text-emerald-800 rounded-xl">
                                <i data-lucide="lock" class="w-5 h-5"></i>
                            </div>
                            <div>
                                <span class="text-xs font-bold text-emerald-700 uppercase tracking-wider">Section 6</span>
                                <h2 class="text-lg sm:text-xl font-bold text-slate-900">Android &amp; Device Permissions</h2>
                            </div>
                        </div>
                        <button onclick="copySectionLink('permissions')" class="text-slate-400 hover:text-teal-600 transition-colors" title="Copy section link">
                            <i data-lucide="link" class="w-4 h-4"></i>
                        </button>
                    </div>

                    <div class="space-y-4 text-sm text-slate-700 leading-relaxed">
                        <p>
                            {{ $appInfo['name'] }} requests only device permissions that are indispensable to feature execution. Below is our formal permission declaration:
                        </p>
                        
                        <div class="overflow-x-auto">
                            <table class="min-w-full text-xs border border-slate-200 rounded-lg overflow-hidden">
                                <thead class="bg-slate-100 text-slate-700 font-semibold">
                                    <tr>
                                        <th class="py-2.5 px-4 text-left border-b border-slate-200">Permission</th>
                                        <th class="py-2.5 px-4 text-left border-b border-slate-200">Type</th>
                                        <th class="py-2.5 px-4 text-left border-b border-slate-200">Operational Purpose</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-200">
                                    <tr>
                                        <td class="py-2.5 px-4 font-mono text-teal-700 font-semibold">android.permission.INTERNET</td>
                                        <td class="py-2.5 px-4"><span class="px-2 py-0.5 bg-slate-100 rounded text-slate-600">Normal</span></td>
                                        <td class="py-2.5 px-4">Enables secure API synchronization for CME content, webinar streams, quiz scoring, and cloud updates.</td>
                                    </tr>
                                    <tr>
                                        <td class="py-2.5 px-4 font-mono text-teal-700 font-semibold">android.permission.ACCESS_NETWORK_STATE</td>
                                        <td class="py-2.5 px-4"><span class="px-2 py-0.5 bg-slate-100 rounded text-slate-600">Normal</span></td>
                                        <td class="py-2.5 px-4">Detects active internet status to switch seamlessly between offline reading mode and real-time syncing.</td>
                                    </tr>
                                    <tr>
                                        <td class="py-2.5 px-4 font-mono text-teal-700 font-semibold">android.permission.USE_BIOMETRIC</td>
                                        <td class="py-2.5 px-4"><span class="px-2 py-0.5 bg-slate-100 rounded text-slate-600">Normal</span></td>
                                        <td class="py-2.5 px-4">Allows local fingerprint/face unlock for quick, secure authentication without exposing biometric data to our servers.</td>
                                    </tr>
                                    <tr>
                                        <td class="py-2.5 px-4 font-mono text-teal-700 font-semibold">POST_NOTIFICATIONS</td>
                                        <td class="py-2.5 px-4"><span class="px-2 py-0.5 bg-amber-100 text-amber-800 rounded font-medium">Runtime</span></td>
                                        <td class="py-2.5 px-4">Delivers timely reminders for registered webinars, daily quiz challenges, and responses to clinical queries. (User can toggle off anytime).</td>
                                    </tr>
                                    <tr>
                                        <td class="py-2.5 px-4 font-mono text-teal-700 font-semibold">READ_MEDIA_IMAGES / Gallery</td>
                                        <td class="py-2.5 px-4"><span class="px-2 py-0.5 bg-amber-100 text-amber-800 rounded font-medium">Runtime</span></td>
                                        <td class="py-2.5 px-4">Enables selecting an optional profile picture or attaching clinical reference diagrams to queries.</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </section>

                <!-- SECTION 7: Security & Encryption Practices -->
                <section id="data-security" class="section-anchor bg-white rounded-2xl p-6 sm:p-8 border border-slate-200/90 shadow-sm transition-all">
                    <div class="flex items-center justify-between pb-4 border-b border-slate-100 mb-6">
                        <div class="flex items-center gap-3">
                            <div class="p-2.5 bg-sky-100 text-sky-800 rounded-xl">
                                <i data-lucide="key" class="w-5 h-5"></i>
                            </div>
                            <div>
                                <span class="text-xs font-bold text-sky-700 uppercase tracking-wider">Section 7</span>
                                <h2 class="text-lg sm:text-xl font-bold text-slate-900">Security &amp; Encryption Practices</h2>
                            </div>
                        </div>
                        <button onclick="copySectionLink('data-security')" class="text-slate-400 hover:text-teal-600 transition-colors" title="Copy section link">
                            <i data-lucide="link" class="w-4 h-4"></i>
                        </button>
                    </div>

                    <div class="space-y-4 text-sm text-slate-700 leading-relaxed">
                        <ul class="space-y-3">
                            <li class="flex items-start gap-3">
                                <div class="p-1 bg-teal-100 text-teal-700 rounded mt-0.5">
                                    <i data-lucide="shield" class="w-4 h-4"></i>
                                </div>
                                <p><strong>Data Encrypted in Transit:</strong> All communication between the {{ $appInfo['name'] }} mobile application and our backend servers is strictly forced over HTTPS using Transport Layer Security (TLS 1.2 / TLS 1.3).</p>
                            </li>
                            <li class="flex items-start gap-3">
                                <div class="p-1 bg-teal-100 text-teal-700 rounded mt-0.5">
                                    <i data-lucide="fingerprint" class="w-4 h-4"></i>
                                </div>
                                <p><strong>Zero Biometric Exposure:</strong> Biometric authentication (fingerprint / face ID) is verified exclusively by the Android OS Hardware Keystore. No biometric data or raw prints ever reach or leave our servers.</p>
                            </li>
                            <li class="flex items-start gap-3">
                                <div class="p-1 bg-teal-100 text-teal-700 rounded mt-0.5">
                                    <i data-lucide="database" class="w-4 h-4"></i>
                                </div>
                                <p><strong>Data at Rest:</strong> Sensitive access tokens, passwords (hashed with Bcrypt/Argon2), and clinical queries are stored securely within isolated databases with role-based administrative access controls.</p>
                            </li>
                        </ul>
                    </div>
                </section>

                <!-- SECTION 8: Data Retention & Storage Policy -->
                <section id="data-retention" class="section-anchor bg-white rounded-2xl p-6 sm:p-8 border border-slate-200/90 shadow-sm transition-all">
                    <div class="flex items-center justify-between pb-4 border-b border-slate-100 mb-6">
                        <div class="flex items-center gap-3">
                            <div class="p-2.5 bg-amber-100 text-amber-800 rounded-xl">
                                <i data-lucide="clock" class="w-5 h-5"></i>
                            </div>
                            <div>
                                <span class="text-xs font-bold text-amber-700 uppercase tracking-wider">Section 8</span>
                                <h2 class="text-lg sm:text-xl font-bold text-slate-900">Data Retention &amp; Storage Policy</h2>
                            </div>
                        </div>
                        <button onclick="copySectionLink('data-retention')" class="text-slate-400 hover:text-teal-600 transition-colors" title="Copy section link">
                            <i data-lucide="link" class="w-4 h-4"></i>
                        </button>
                    </div>

                    <div class="space-y-4 text-sm text-slate-700 leading-relaxed">
                        <p>
                            We retain user data only for as long as necessary to fulfill the educational objectives of {{ $appInfo['name'] }} or to comply with statutory legal requirements:
                        </p>
                        <ul class="list-disc list-inside space-y-2 text-xs text-slate-600">
                            <li><strong>Active Accounts:</strong> Account profile, CME learning history, quiz scores, and saved library items are maintained while your account remains active.</li>
                            <li><strong>Inactive Accounts:</strong> Accounts with no activity for more than 24 consecutive months may be archived or scheduled for automated purging following notification.</li>
                            <li><strong>Deleted Accounts:</strong> When a deletion request is executed, all associated personal identifiers, profile data, and query histories are permanently purged or irreversibly anonymized within <strong>30 days</strong>.</li>
                        </ul>
                    </div>
                </section>

                <!-- SECTION 9: Account & Data Deletion (Google Play Mandated Section) -->
                <section id="account-deletion" class="section-anchor bg-gradient-to-br from-red-50/40 via-white to-slate-50 rounded-2xl p-6 sm:p-8 border-2 border-red-200 shadow-sm transition-all">
                    <div class="flex items-center justify-between pb-4 border-b border-red-100 mb-6">
                        <div class="flex items-center gap-3">
                            <div class="p-2.5 bg-red-100 text-red-700 rounded-xl">
                                <i data-lucide="trash-2" class="w-5 h-5"></i>
                            </div>
                            <div>
                                <div class="flex items-center gap-2">
                                    <span class="text-xs font-bold text-red-700 uppercase tracking-wider">Section 9</span>
                                    <span class="px-2 py-0.5 bg-red-600 text-white font-semibold text-[10px] rounded-full uppercase">Google Play Policy</span>
                                </div>
                                <h2 class="text-lg sm:text-xl font-bold text-slate-900">Account &amp; Data Deletion Instructions</h2>
                            </div>
                        </div>
                        <button onclick="copySectionLink('account-deletion')" class="text-slate-400 hover:text-red-600 transition-colors" title="Copy section link">
                            <i data-lucide="link" class="w-4 h-4"></i>
                        </button>
                    </div>

                    <div class="space-y-6 text-sm text-slate-700 leading-relaxed">
                        <div class="bg-white p-4 rounded-xl border border-red-100 text-xs text-slate-600">
                            In compliance with <strong>Google Play's User Data &amp; Account Deletion Policy</strong>, clinicians and registered users have full authority to delete their {{ $appInfo['name'] }} account and all associated personal data at any time.
                        </div>

                        <!-- Step-by-Step Methods -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            
                            <!-- Method 1: Inside the Mobile App -->
                            <div class="bg-white p-5 rounded-xl border border-slate-200 shadow-sm space-y-3">
                                <div class="flex items-center gap-2 text-teal-800 font-bold text-xs uppercase">
                                    <i data-lucide="smartphone" class="w-4 h-4 text-teal-600"></i>
                                    <span>Method 1: Direct In-App Deletion</span>
                                </div>
                                <p class="text-xs text-slate-600">You can permanently delete your account directly inside the {{ $appInfo['name'] }} mobile app:</p>
                                
                                <ol class="space-y-2.5 text-xs text-slate-700">
                                    <li class="flex items-start gap-2">
                                        <span class="w-5 h-5 rounded-full bg-teal-100 text-teal-800 flex items-center justify-center font-bold text-[10px] flex-shrink-0">1</span>
                                        <span>Open the <strong>{{ $appInfo['name'] }}</strong> mobile app on your Android device.</span>
                                    </li>
                                    <li class="flex items-start gap-2">
                                        <span class="w-5 h-5 rounded-full bg-teal-100 text-teal-800 flex items-center justify-center font-bold text-[10px] flex-shrink-0">2</span>
                                        <span>Navigate to the <strong>Profile</strong> tab (or tap your avatar from Home).</span>
                                    </li>
                                    <li class="flex items-start gap-2">
                                        <span class="w-5 h-5 rounded-full bg-teal-100 text-teal-800 flex items-center justify-center font-bold text-[10px] flex-shrink-0">3</span>
                                        <span>Tap <strong class="text-red-700">"Delete Account"</strong> / "Request Account Deletion".</span>
                                    </li>
                                    <li class="flex items-start gap-2">
                                        <span class="w-5 h-5 rounded-full bg-teal-100 text-teal-800 flex items-center justify-center font-bold text-[10px] flex-shrink-0">4</span>
                                        <span>Review the prompt and confirm your deletion request. Your session will immediately be invalidated and your data queued for permanent removal.</span>
                                    </li>
                                </ol>
                            </div>

                            <!-- Method 2: Web Deletion Request (External URL) -->
                            <div class="bg-white p-5 rounded-xl border border-slate-200 shadow-sm space-y-3">
                                <div class="flex items-center gap-2 text-slate-900 font-bold text-xs uppercase">
                                    <i data-lucide="globe" class="w-4 h-4 text-cyan-600"></i>
                                    <span>Method 2: External Web Deletion Request</span>
                                </div>
                                <p class="text-xs text-slate-600">If you have uninstalled the app or cannot log in, you can submit a deletion request online or via email:</p>
                                
                                <div class="bg-slate-50 p-3.5 rounded-lg border border-slate-200 space-y-2 text-xs">
                                    <p><strong>Option A — Email Request:</strong></p>
                                    <p class="text-slate-600">Send an email from your registered email address with the subject line <code class="bg-slate-200 px-1 py-0.5 rounded text-slate-800 font-mono">Delete My CareSynapse Account</code> to:</p>
                                    <a href="mailto:{{ $appInfo['privacy_email'] }}?subject=Delete%20My%20CareSynapse%20Account" class="font-bold text-teal-700 hover:underline flex items-center gap-1">
                                        <i data-lucide="mail" class="w-3.5 h-3.5"></i>
                                        {{ $appInfo['privacy_email'] }}
                                    </a>
                                </div>

                                <div class="bg-slate-50 p-3.5 rounded-lg border border-slate-200 space-y-1 text-xs">
                                    <p><strong>Option B — Support Desk:</strong></p>
                                    <p class="text-slate-600">Contact our support desk at <a href="mailto:{{ $appInfo['contact_email'] }}" class="text-teal-700 font-medium hover:underline">{{ $appInfo['contact_email'] }}</a> with your registered mobile phone number and full name.</p>
                                </div>
                            </div>
                        </div>

                        <!-- Data Deleted vs Retained -->
                        <div class="border border-slate-200 rounded-xl overflow-hidden text-xs">
                            <div class="bg-slate-100 px-4 py-2.5 font-bold text-slate-800">
                                What Happens to Your Data Upon Account Deletion:
                            </div>
                            <div class="grid grid-cols-1 sm:grid-cols-2 divide-y sm:divide-y-0 sm:divide-x divide-slate-200 bg-white">
                                <div class="p-4 space-y-2">
                                    <div class="font-bold text-red-700 flex items-center gap-1.5">
                                        <i data-lucide="x-circle" class="w-4 h-4"></i>
                                        <span>Data Permanently Purged:</span>
                                    </div>
                                    <ul class="list-disc list-inside space-y-1 text-slate-600">
                                        <li>Personal identity (Name, Email, Phone Number)</li>
                                        <li>Profile picture and license verification documents</li>
                                        <li>Specialty, hospital affiliations, and credentials</li>
                                        <li>Saved bookmarks and personal query conversation records</li>
                                        <li>Biometric and authentication session tokens</li>
                                    </ul>
                                </div>

                                <div class="p-4 space-y-2">
                                    <div class="font-bold text-slate-700 flex items-center gap-1.5">
                                        <i data-lucide="info" class="w-4 h-4"></i>
                                        <span>Data Retained or Anonymized:</span>
                                    </div>
                                    <ul class="list-disc list-inside space-y-1 text-slate-600">
                                        <li>Aggregate CME quiz attendance metrics (strictly stripped of all personal identity)</li>
                                        <li>Server security logs for mandatory audit periods (retained up to 90 days before cyclic deletion)</li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                    </div>
                </section>

                <!-- SECTION 10: Clinician & User Privacy Rights -->
                <section id="user-rights" class="section-anchor bg-white rounded-2xl p-6 sm:p-8 border border-slate-200/90 shadow-sm transition-all">
                    <div class="flex items-center justify-between pb-4 border-b border-slate-100 mb-6">
                        <div class="flex items-center gap-3">
                            <div class="p-2.5 bg-teal-100 text-teal-800 rounded-xl">
                                <i data-lucide="user-check" class="w-5 h-5"></i>
                            </div>
                            <div>
                                <span class="text-xs font-bold text-teal-700 uppercase tracking-wider">Section 10</span>
                                <h2 class="text-lg sm:text-xl font-bold text-slate-900">Clinician &amp; User Privacy Rights</h2>
                            </div>
                        </div>
                        <button onclick="copySectionLink('user-rights')" class="text-slate-400 hover:text-teal-600 transition-colors" title="Copy section link">
                            <i data-lucide="link" class="w-4 h-4"></i>
                        </button>
                    </div>

                    <div class="space-y-4 text-sm text-slate-700 leading-relaxed">
                        <p>Under applicable global privacy regulations (including GDPR, CCPA, and regional digital personal data laws), you have the right to:</p>
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs">
                            <div class="p-3 border border-slate-200 rounded-lg bg-slate-50">
                                <strong class="text-slate-900 block mb-1">Right to Access / Portability:</strong>
                                Request a comprehensive copy of your personal and CME progress data in digital format.
                            </div>
                            <div class="p-3 border border-slate-200 rounded-lg bg-slate-50">
                                <strong class="text-slate-900 block mb-1">Right to Rectification:</strong>
                                Update or correct inaccurate medical credentials, affiliations, or contact details directly in the app.
                            </div>
                            <div class="p-3 border border-slate-200 rounded-lg bg-slate-50">
                                <strong class="text-slate-900 block mb-1">Right to Erasure (To Be Forgotten):</strong>
                                Demand full deletion of your profile and records as detailed in Section 9.
                            </div>
                            <div class="p-3 border border-slate-200 rounded-lg bg-slate-50">
                                <strong class="text-slate-900 block mb-1">Right to Withdraw Consent:</strong>
                                Opt out of optional push notifications, analytics, or liaison inquiries at any moment.
                            </div>
                        </div>
                    </div>
                </section>

                <!-- SECTION 11: Children's Privacy Protection -->
                <section id="children-privacy" class="section-anchor bg-white rounded-2xl p-6 sm:p-8 border border-slate-200/90 shadow-sm transition-all">
                    <div class="flex items-center justify-between pb-4 border-b border-slate-100 mb-6">
                        <div class="flex items-center gap-3">
                            <div class="p-2.5 bg-rose-100 text-rose-800 rounded-xl">
                                <i data-lucide="alert-circle" class="w-5 h-5"></i>
                            </div>
                            <div>
                                <span class="text-xs font-bold text-rose-700 uppercase tracking-wider">Section 11</span>
                                <h2 class="text-lg sm:text-xl font-bold text-slate-900">Children's Privacy Protection</h2>
                            </div>
                        </div>
                        <button onclick="copySectionLink('children-privacy')" class="text-slate-400 hover:text-teal-600 transition-colors" title="Copy section link">
                            <i data-lucide="link" class="w-4 h-4"></i>
                        </button>
                    </div>

                    <div class="space-y-4 text-sm text-slate-700 leading-relaxed">
                        <p>
                            {{ $appInfo['name'] }} is strictly intended for licensed adult healthcare professionals and clinicians aged <strong>18 and older</strong>. We do not knowingly solicit, collect, or process any personal data from children under 18 years of age.
                        </p>
                        <p class="text-xs text-slate-600">
                            If you believe that a minor has submitted personal information to us inadvertently, please notify us immediately at <a href="mailto:{{ $appInfo['privacy_email'] }}" class="text-teal-600 font-medium hover:underline">{{ $appInfo['privacy_email'] }}</a> and we will immediately erase such data from our databases.
                        </p>
                    </div>
                </section>

                <!-- SECTION 12: Changes to This Privacy Policy -->
                <section id="policy-changes" class="section-anchor bg-white rounded-2xl p-6 sm:p-8 border border-slate-200/90 shadow-sm transition-all">
                    <div class="flex items-center justify-between pb-4 border-b border-slate-100 mb-6">
                        <div class="flex items-center gap-3">
                            <div class="p-2.5 bg-slate-100 text-slate-800 rounded-xl">
                                <i data-lucide="refresh-cw" class="w-5 h-5"></i>
                            </div>
                            <div>
                                <span class="text-xs font-bold text-slate-600 uppercase tracking-wider">Section 12</span>
                                <h2 class="text-lg sm:text-xl font-bold text-slate-900">Changes to This Privacy Policy</h2>
                            </div>
                        </div>
                        <button onclick="copySectionLink('policy-changes')" class="text-slate-400 hover:text-teal-600 transition-colors" title="Copy section link">
                            <i data-lucide="link" class="w-4 h-4"></i>
                        </button>
                    </div>

                    <div class="space-y-4 text-sm text-slate-700 leading-relaxed">
                        <p>
                            We reserve the right to revise or update this Privacy Policy to reflect modifications in our platform features, relevant regulations, or Play Store guidelines. 
                        </p>
                        <p class="text-xs text-slate-600">
                            Whenever significant changes occur, we will notify users through an in-app notice or via your registered email address prior to the change becoming effective. The latest effective date will always be prominently displayed at the top and bottom of this page.
                        </p>
                    </div>
                </section>

                <!-- SECTION 13: Contact & Grievance Officer -->
                <section id="contact-us" class="section-anchor bg-white rounded-2xl p-6 sm:p-8 border border-slate-200/90 shadow-sm transition-all">
                    <div class="flex items-center justify-between pb-4 border-b border-slate-100 mb-6">
                        <div class="flex items-center gap-3">
                            <div class="p-2.5 bg-teal-100 text-teal-800 rounded-xl">
                                <i data-lucide="mail" class="w-5 h-5"></i>
                            </div>
                            <div>
                                <span class="text-xs font-bold text-teal-700 uppercase tracking-wider">Section 13</span>
                                <h2 class="text-lg sm:text-xl font-bold text-slate-900">Contact &amp; Grievance Officer</h2>
                            </div>
                        </div>
                        <button onclick="copySectionLink('contact-us')" class="text-slate-400 hover:text-teal-600 transition-colors" title="Copy section link">
                            <i data-lucide="link" class="w-4 h-4"></i>
                        </button>
                    </div>

                    <div class="space-y-4 text-sm text-slate-700 leading-relaxed">
                        <p>
                            If you have inquiries, feedback, or grievance requests concerning this Privacy Policy, your personal data, or our Data Safety practices, please contact our designated Data Protection Officer:
                        </p>

                        <div class="bg-slate-50 border border-slate-200 rounded-xl p-5 space-y-3 text-xs">
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                <div>
                                    <span class="text-slate-500 font-medium block">Organization:</span>
                                    <strong class="text-slate-900 text-sm">{{ $appInfo['organization'] }}</strong>
                                </div>
                                <div>
                                    <span class="text-slate-500 font-medium block">Application Name:</span>
                                    <strong class="text-slate-900 text-sm">{{ $appInfo['name'] }}</strong>
                                </div>
                                <div>
                                    <span class="text-slate-500 font-medium block">General Inquiries:</span>
                                    <a href="mailto:{{ $appInfo['contact_email'] }}" class="text-teal-700 font-semibold hover:underline">{{ $appInfo['contact_email'] }}</a>
                                </div>
                                <div>
                                    <span class="text-slate-500 font-medium block">Privacy &amp; Data Officer:</span>
                                    <a href="mailto:{{ $appInfo['privacy_email'] }}" class="text-teal-700 font-semibold hover:underline">{{ $appInfo['privacy_email'] }}</a>
                                </div>
                                <div class="sm:col-span-2">
                                    <span class="text-slate-500 font-medium block">Official Web Domain:</span>
                                    <a href="{{ $appInfo['domain'] }}" target="_blank" rel="noopener" class="text-teal-700 font-semibold hover:underline font-mono">{{ $appInfo['domain'] }}</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Toast Notification for Copy Link -->
                <div id="toast" class="fixed bottom-6 right-6 bg-slate-900 text-white text-xs px-4 py-2.5 rounded-xl shadow-lg border border-slate-700 flex items-center gap-2 transform translate-y-20 opacity-0 transition-all duration-300 pointer-events-none z-50">
                    <i data-lucide="check" class="w-4 h-4 text-teal-400"></i>
                    <span id="toastMsg">Section link copied to clipboard!</span>
                </div>

            </article>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-slate-900 text-slate-400 text-xs border-t border-slate-800 py-10 mt-16 no-print">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex flex-col md:flex-row items-center justify-between gap-6">
                <div class="flex items-center gap-3">
                    <img src="{{ $appInfo['logo'] }}" alt="{{ $appInfo['name'] }}" class="w-9 h-9 rounded-xl object-contain bg-white/10 p-0.5 shadow-sm">
                    <div>
                        <span class="text-sm font-bold text-white">{{ $appInfo['name'] }}</span>
                        <p class="text-[11px] text-slate-500">&copy; {{ date('Y') }} {{ $appInfo['organization'] }}. All rights reserved.</p>
                    </div>
                </div>

                <div class="flex flex-wrap items-center gap-6 text-[12px]">
                    <a href="{{ url('/privacy-policy') }}" class="text-teal-400 hover:underline font-semibold">Privacy Policy</a>
                    <a href="{{ url('/privacy-policy#account-deletion') }}" class="text-slate-300 hover:text-white">Account Deletion</a>
                    <a href="{{ url('/privacy-policy#permissions') }}" class="text-slate-300 hover:text-white">Permissions</a>
                    <a href="mailto:{{ $appInfo['contact_email'] }}" class="text-slate-300 hover:text-white">Support</a>
                </div>
            </div>
            
            <div class="mt-8 pt-6 border-t border-slate-800/80 text-[11px] text-slate-500 text-center sm:text-left flex flex-col sm:flex-row justify-between gap-2">
                <span>Google Play Console Data Safety compliant document for <code>{{ $appInfo['package_name'] }}</code>.</span>
                <span>Published at: <a href="{{ $appInfo['domain'] }}/privacy-policy" class="text-slate-400 hover:text-teal-400">{{ $appInfo['domain'] }}/privacy-policy</a></span>
            </div>
        </div>
    </footer>

    <!-- Scripts: Lucide Icons & ScrollSpy & Search & Copy Link -->
    <script>
        // Initialize Lucide Icons
        lucide.createIcons();

        // Copy Section Link Handler
        function copySectionLink(sectionId) {
            const url = window.location.origin + window.location.pathname + '#' + sectionId;
            navigator.clipboard.writeText(url).then(() => {
                showToast('Link to section copied to clipboard!');
            }).catch(() => {
                showToast('Copied: ' + url);
            });
        }

        // Toast feedback
        function showToast(msg) {
            const toast = document.getElementById('toast');
            const toastMsg = document.getElementById('toastMsg');
            toastMsg.innerText = msg;
            toast.classList.remove('translate-y-20', 'opacity-0');
            toast.classList.add('translate-y-0', 'opacity-100');
            
            setTimeout(() => {
                toast.classList.remove('translate-y-0', 'opacity-100');
                toast.classList.add('translate-y-20', 'opacity-0');
            }, 2500);
        }

        // Live Search / Filter Sections
        function filterSections() {
            const query = document.getElementById('policySearch').value.toLowerCase().trim();
            const sections = document.querySelectorAll('article section');
            const navLinks = document.querySelectorAll('#sidebarNav .nav-link');

            sections.forEach((sec, idx) => {
                const text = sec.innerText.toLowerCase();
                const matches = text.includes(query);
                sec.style.display = matches ? 'block' : 'none';
                
                if (navLinks[idx]) {
                    navLinks[idx].style.display = matches ? 'flex' : 'none';
                }
            });
        }

        // ScrollSpy to highlight active sidebar link
        window.addEventListener('DOMContentLoaded', () => {
            const sections = document.querySelectorAll('.section-anchor');
            const navLinks = document.querySelectorAll('#sidebarNav .nav-link');

            const observerOptions = {
                root: null,
                rootMargin: '-20% 0px -70% 0px',
                threshold: 0
            };

            const observer = new IntersectionObserver((entries) => {
                entries.forEach((entry) => {
                    if (entry.isIntersecting) {
                        const id = entry.target.getAttribute('id');
                        navLinks.forEach((link) => {
                            if (link.getAttribute('href') === '#' + id) {
                                link.classList.add('active-nav');
                            } else {
                                link.classList.remove('active-nav');
                            }
                        });
                    }
                });
            }, observerOptions);

            sections.forEach((section) => {
                observer.observe(section);
            });
        });
    </script>
</body>
</html>

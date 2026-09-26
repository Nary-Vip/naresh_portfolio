const String _web3FormsPlaceholderKey = 'YOUR_ACCESS_KEY_HERE';

// Compiled in via `--dart-define-from-file=.env`. A runtime-loaded .env asset never
// reached production (Firebase skips dotfiles) and cost a fetch before first paint.
const String web3FormsAccessKey = String.fromEnvironment(
  'WEB3FORMS_ACCESS_KEY',
  defaultValue: _web3FormsPlaceholderKey,
);

bool get isWeb3FormsConfigured =>
    web3FormsAccessKey.isNotEmpty &&
    web3FormsAccessKey != _web3FormsPlaceholderKey;

class ImpactMetric {
  final String value;
  final String label;
  final String description;
  final String iconName; 

  const ImpactMetric({
    required this.value,
    required this.label,
    required this.description,
    required this.iconName,
  });
}

class PortfolioData {
  final String name;
  final String title;
  final String email;
  final String phone;
  final String githubUrl;
  final String linkedinUrl;
  final String leetcodeUrl;
  final String summary;

  // Education
  final String educationDegree;
  final String educationSchool;
  final String educationPeriod;
  final String educationCgpa;

  // Sections Data// New Pillars section data
  final List<ExploringItem> exploring;
  final List<SkillCategory> skills;
  final List<ExperienceItem> experiences;
  final List<ProjectItem> projects;
  final List<CertificationItem> certifications;
  final List<ChatbotFAQ> faqList;
  final List<ImpactMetric> impactMetrics;

  const PortfolioData({
    required this.name,
    required this.title,
    required this.email,
    required this.phone,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.leetcodeUrl,
    required this.summary,
    required this.educationDegree,
    required this.educationSchool,
    required this.educationPeriod,
    required this.educationCgpa,
    required this.exploring,
    required this.skills,
    required this.experiences,
    required this.projects,
    required this.certifications,
    required this.faqList,
    required this.impactMetrics,
  });
}

class ExploringItem {
  final String topic;
  final String description;
  final String icon; // Material Icon name or descriptor

  const ExploringItem({
    required this.topic,
    required this.description,
    required this.icon,
  });
}

class SkillCategory {
  final String categoryName;
  final List<String> skillList;

  const SkillCategory({required this.categoryName, required this.skillList});
}

class ExperienceItem {
  final String role;
  final String company;
  final String location;
  final String period;
  final List<String> bulletPoints;

  const ExperienceItem({
    required this.role,
    required this.company,
    required this.location,
    required this.period,
    required this.bulletPoints,
  });
}

class ProjectItem {
  final String title;
  final String subtitle;
  final String description;
  final List<String> bulletPoints;
  final List<String> technologies;
  final String? githubUrl;
  final String? demoUrl;

  const ProjectItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.bulletPoints,
    required this.technologies,
    this.githubUrl,
    this.demoUrl,
  });
}

class CertificationItem {
  final String title;
  final String organization;
  final String date;
  final String? certificateUrl;

  const CertificationItem({
    required this.title,
    required this.organization,
    required this.date,
    this.certificateUrl,
  });
}

class ChatbotFAQ {
  final String question;
  final String answer;

  const ChatbotFAQ({required this.question, required this.answer});
}

// Global Static Data Instance
const PortfolioData nareshPortfolioData = PortfolioData(
  name: "R M NARESH KUMAR",
  title: "Software Development Engineer",
  email: "rmnareshkumar001@gmail.com",
  phone: "+91 8508214355",
  githubUrl: "https://github.com/Nary-Vip",
  linkedinUrl: "https://linkedin.com/in/naresh25",
  leetcodeUrl: "https://leetcode.com/u/rmnareshkumar001/",
  summary:
      "Software Development Engineer with 2+ years of experience across 5+ client products, building cross-platform apps with Flutter for Android and iOS and native Android apps with Kotlin and Jetpack Compose. Experience ranges from fintech security hardening to offline-first architecture for low-connectivity regions, real-time data dashboards, and native SDK integrations. Owns delivery end to end, from technical design through release, store rollout, and post-release stability. Strong on the production side of mobile through crash triage, release automation, and app security, with a solid base in CS fundamentals, DSA, and system design (LLD/HLD).",
  educationDegree:
      "Integrated M.Sc. in Artificial Intelligence and Machine Learning",
  educationSchool: "Coimbatore Institute of Technology",
  educationPeriod: "2019 – 2024",
  educationCgpa: "8.44",

  exploring: [
    ExploringItem(
      topic: "Native Android & Compose",
      description:
          "Deepening knowledge of Kotlin, Jetpack Compose, Hilt, Room, and MVVM architectures to build highly specialized native experiences.",
      icon: "android",
    ),
    ExploringItem(
      topic: "AI Agents & MCP",
      description:
          "Exploring the Model Context Protocol (MCP) to develop autonomous coding assistants, custom agent tools, and context-aware systems.",
      icon: "smart_toy",
    ),
    ExploringItem(
      topic: "Bluetooth & BLE Devices",
      description:
          "Exploring classic Bluetooth connections and BLE (Bluetooth Low Energy) devices to engineer real-time hardware data sync and IoT communication bridges.",
      icon: "bluetooth",
    ),
    ExploringItem(
      topic: "AI Integrated Workflows",
      description:
          "Exploring AI-integrated workflows by leveraging agentic skills and automated work agents to streamline business logic and operational processes.",
      icon: "psychology",
    ),
  ],

  skills: [
    SkillCategory(
      categoryName: "Mobile Development",
      skillList: [
        "Flutter",
        "Dart",
        "Kotlin",
        "Swift",
        "BLoC",
        "Redux",
        "GoRouter",
        "Dio",
        "Hive",
        "Melos",
        "Method Channels",
        "Pigeon",
        "Flutter Web",
        "Jetpack Compose",
        "Navigation 3",
        "Coroutines",
        "Flow",
        "Hilt (Dagger)",
        "Room",
        "Realm",
        "WorkManager",
        "Media3/ExoPlayer",
        "React Native",
      ],
    ),
    SkillCategory(
      categoryName: "Web & Backend",
      skillList: [
        "React",
        "TypeScript",
        "Node.js",
        "Express.js",
        "REST APIs",
        "MongoDB",
        "Supabase",
      ],
    ),
    SkillCategory(
      categoryName: "Tools & Practices",
      skillList: [
        "Git",
        "CI/CD",
        "Azure DevOps",
        "Fastlane",
        "MVVM",
        "Unit & Integration Testing",
        "Mockito",
        "JUnit",
        "Turbine",
        "Compose UI Testing",
        "Firebase Crashlytics & Analytics",
        "FCM",
        "VAPT Remediation",
        "AI-Integrated Development Workflows",
      ],
    ),
  ],

  experiences: [
    ExperienceItem(
      role: "Software Development Engineer",
      company: "Rootquotient",
      location: "Chennai, Tamil Nadu",
      period: "Jun 2024 – Present",
      bulletPoints: [
        "Remediated VAPT findings for a fintech app, closing every finding including critical severity issues through SSL pinning, root and jailbreak detection, encrypted local storage, etc., and clearing the re-audit with no open findings.",
        "Implemented cryptographic biometric authentication with hardware-backed key pairs and built a passkey (WebAuthn/FIDO2) reference implementation in Flutter for Android and iOS, replacing local biometric flags and passwords with signature-based sign-in.",
        "Transitioned from Flutter to native Android (Kotlin), delivering features end to end across audio recording, draft and publish flows, feed, discovery, and commenting.",
        "Implemented role-based access handling, applying backend-defined permissions to control feature availability and restrict actions by user role.",
        "Tracked platform and tooling changes and adopted them ahead of enforcement deadlines, including the CocoaPods to Swift Package Manager migration and 16 KB page size support.",
        "Brought in on a short-term allocation to stabilize a product's initial releases, lifting the crash-free rate from 70% to 98% by diagnosing and fixing 10+ crashes and ANRs.",
        "Eliminated frame drops and UI freezes on data-heavy screens by fixing repaint boundaries and redundant recalculations on Flutter chart displays, and moving blocking Realm draft writes off the main thread in native Android, profiled with Flutter DevTools and Android Profiler.",
        "Integrated Razorpay payments and bridged the Trustly SDK natively via Method Channels. Streamed native geofencing updates over Event Channels on Android and iOS across foreground, background, and terminated states, adopted as the production reference.",
        "Integrated Salesforce Messaging for In-App into a mobile product, configuring pre-chat flows and in-app messaging.",
        "Built a Melos-based Flutter monorepo template (clean architecture, BLoC) where each feature is a standalone package with one-way dependencies on shared packages and centralized API error handling, so features could be built and tested in isolation.",
        "Built offline-first apps for field users in remote areas, caching API responses via Hive and a custom Dio interceptor to render cached screens instantly, syncing background data with constraint-based WorkManager, and cutting cold start times by 20% through R8 code and resource shrinking.",
        "Built the Flutter consumer app for a smart grid energy platform, streaming live meter data from up to 10 appliances per household over WebSockets, and integrated the Seam API for in-app thermostat control.",
        "Cut CI/CD pipeline time from 45-50 minutes to 25 minutes by parallelizing Android and iOS builds and caching Gradle and Flutter dependencies keyed on lockfile changes. Built reusable Azure DevOps pipeline templates used across 5+ projects for automated store releases, with working exposure to Fastlane.",
        "Maintained 90% unit and integration test coverage to ensure codebase stability, while expanding app delivery to Flutter Web with responsive design and UX parity with mobile.",
        "Actively involved in peer code reviews and knowledge sharing, and authored handover documentation covering codebase structure, setup, and third-party integrations.",
      ],
    ),
    ExperienceItem(
      role: "Software Development Engineer Intern",
      company: "Rootquotient",
      location: "Chennai, Tamil Nadu",
      period: "Jun 2022 – Jan 2023 & Dec 2023 – May 2024 (during M.Sc.)",
      bulletPoints: [
        "Contributed to 2+ production Flutter apps, building UI components, integrating REST APIs, and implementing GoRouter navigation.",
        "Worked with Redux and BLoC state management and gathered requirements directly from clients in agile sprints.",
      ],
    ),
  ],

  projects: [
    ProjectItem(
      title: "FitSync",
      subtitle: "Native Android Workout Management Application",
      description:
          "An offline-first Kotlin/Compose workout app with encrypted token storage, automatic geofence-based gym check-in, and a custom backend handling authentication and rate limiting.",
      bulletPoints: [
        "Built an offline-first Kotlin/Compose workout app with encrypted token storage, AlarmManager reminders with snooze, and geofence-based automatic gym check-in that logs visits to Room and stays active after reboots.",
        "Built the Node.js/TypeScript backend with JWT auth, session interceptors, and sliding-window API rate limiting.",
      ],
      technologies: [
        "Kotlin",
        "Jetpack Compose",
        "MVVM",
        "Hilt",
        "Room",
        "WorkManager",
        "Play Services Location",
        "Retrofit/OkHttp",
        "Node.js",
        "Express.js",
        "TypeScript",
        "JWT",
      ],
      githubUrl: "https://github.com/Nary-Vip/nary_gym_android",
    ),
    ProjectItem(
      title: "On-Device LLM Benchmark",
      subtitle: "Local Models vs. Cloud-Hosted Inference",
      description:
          "A Flutter app benchmarking on-device LLM inference across native engines on Android and iOS, with a structured harness for scoring response quality.",
      bulletPoints: [
        "Built a Flutter app with native inference engines, Kotlin on Android and a Swift actor-based MediaPipe backend on iOS, plus LiteRT-LM as a second engine behind a UI toggle.",
        "Implemented a structured benchmark harness with quality scoring on keyword match, repetition rate, and length compliance.",
      ],
      technologies: [
        "Flutter",
        "Dart",
        "Kotlin",
        "Swift",
        "MediaPipe",
        "LiteRT-LM",
        "Method Channels",
      ],
      githubUrl: "https://github.com/Nary-Vip/on_device_llm",
    ),
  ],

  certifications: [
    CertificationItem(
      title: "Introduction to Model Context Protocol",
      organization: "Anthropic",
      date: "Jun 2026",
      certificateUrl: "https://linkedin.com/in/naresh25",
    ),
    CertificationItem(
      title: "Introduction to Agent Skills",
      organization: "Anthropic",
      date: "May 2026",
      certificateUrl: "https://linkedin.com/in/naresh25",
    ),
    CertificationItem(
      title: "Claude Code in Action",
      organization: "Anthropic",
      date: "Jun 2026",
      certificateUrl: "https://linkedin.com/in/naresh25",
    ),
  ],

  faqList: [
    ChatbotFAQ(
      question: "What is Naresh's primary technical expertise?",
      answer:
          "Naresh is a Software Development Engineer with 2+ years of experience across 5+ client products, building cross-platform apps with Flutter for Android and iOS and native Android apps with Kotlin and Jetpack Compose. He owns delivery end to end, from technical design through release, store rollout, and post-release stability, with a solid base in CS fundamentals, DSA, and system design (LLD/HLD).",
    ),
    ChatbotFAQ(
      question: "Can he integrate native Android and iOS features in Flutter?",
      answer:
          "Yes, absolutely! He integrated Razorpay payments and bridged the Trustly SDK natively via Method Channels, and streamed native geofencing updates over Event Channels on Android and iOS across foreground, background, and terminated states, which was adopted as the production reference at his company.",
    ),
    ChatbotFAQ(
      question:
          "What optimizations has he delivered for build times and app stability?",
      answer:
          "He cut CI/CD pipeline time from 45-50 minutes to 25 minutes by parallelizing Android and iOS builds and caching dependencies, building reusable Azure DevOps pipeline templates used across 5+ projects. He was also brought in to stabilize a product's initial releases, lifting the crash-free rate from 70% to 98% by diagnosing and fixing 10+ crashes and ANRs.",
    ),
    ChatbotFAQ(
      question: "What is his academic background?",
      answer:
          "Naresh graduated from the Coimbatore Institute of Technology (CIT) in 2024 with an Integrated M.Sc. in Artificial Intelligence and Machine Learning, achieving a strong CGPA of 8.44.",
    ),
    ChatbotFAQ(
      question: "Is he familiar with Agentic AI and LLM integrations?",
      answer:
          "Yes, he built an On-Device LLM Benchmark app with native inference engines on Android and iOS plus a LiteRT-LM engine behind a UI toggle. He also holds certifications from Anthropic in Model Context Protocol (MCP), Agent Skills, and Claude Code, and applies AI-integrated development workflows in his day-to-day work.",
    ),
    ChatbotFAQ(
      question: "Has he worked on application security?",
      answer:
          "Yes, he remediated VAPT findings for a fintech app, closing every finding including critical severity issues through SSL pinning, root and jailbreak detection, and encrypted local storage, and clearing the re-audit with no open findings. He also implemented cryptographic biometric authentication with hardware-backed key pairs and built a passkey (WebAuthn/FIDO2) reference implementation in Flutter, replacing local biometric flags and passwords with signature-based sign-in.",
    ),
  ],
  impactMetrics: [
    ImpactMetric(
      value: "2+",
      label: "Years Experience",
      description: "Building and shipping production mobile applications across 5+ client products using Flutter and native Kotlin/Compose.",
      iconName: "work_outline",
    ),
    ImpactMetric(
      value: "98%",
      label: "Crash-Free Rate",
      description: "Lifted crash-free rate from 70% to 98% by diagnosing and fixing 10+ crashes and ANRs during a release stabilization effort.",
      iconName: "verified_outlined",
    ),
    ImpactMetric(
      value: "20%",
      label: "Faster Cold Starts",
      description: "Cut cold start times by 20% through R8 code and resource shrinking for offline-first field apps.",
      iconName: "speed_outlined",
    ),
    ImpactMetric(
      value: "90%",
      label: "Test Coverage",
      description: "Maintaining codebase reliability and stability by securing robust unit and integration test coverage.",
      iconName: "checklist_outlined",
    ),
    ImpactMetric(
      value: "50%",
      label: "Faster CI/CD Pipelines",
      description: "Cut CI/CD pipeline time from 45-50 minutes to 25 minutes, with reusable Azure DevOps templates used across 5+ projects.",
      iconName: "sync_outlined",
    ),
  ],
);

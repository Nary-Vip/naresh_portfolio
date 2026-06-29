import 'package:flutter_dotenv/flutter_dotenv.dart';

String get web3FormsAccessKey =>
    dotenv.env['WEB3FORMS_ACCESS_KEY'] ?? 'YOUR_ACCESS_KEY_HERE';


String get geminiApiKey =>
    dotenv.env['GEMINI_API_KEY'] ?? '';

class ImpactMetric {
  final String value;
  final String label;
  final String description;
  final String iconName; // e.g. 'work_outline', 'rocket_launch_outlined', 'speed_outlined', 'security_outlined', 'sync_outlined'

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
  summary:
      "Software Development Engineer with 2+ years of experience building scalable cross-platform mobile apps for Android and iOS using Flutter. Skilled in native platform integrations, reusable architecture (BLoC/Redux), CI/CD optimization, and performance tuning. Actively expanding expertise in native Android development with Kotlin and Jetpack. Experienced working in Agile environments with sprint-based delivery, mentoring developers, and independently driving features from development to release.",
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
      topic: "On-Device LLMs",
      description:
          "Researching local intelligence integration with MediaPipe and LiteRT (TensorFlow Lite) for privacy-first, low-latency mobile inference.",
      icon: "memory",
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
        "Jetpack Compose",
        "BLoC",
        "Redux",
        "Coroutines",
        "Flow",
        "Hilt",
        "Room",
        "Hive",
        "Dio",
        "GoRouter",
      ],
    ),
    SkillCategory(
      categoryName: "Web & Backend",
      skillList: [
        "React",
        "Node.js",
        "Express.js",
        "JavaScript",
        "TypeScript",
        "REST APIs",
        "MongoDB",
        "Mongoose",
        "MySQL",
        "CSS",
        "Tailwind CSS",
        "Python",
      ],
    ),
    SkillCategory(
      categoryName: "Tools & Practices",
      skillList: [
        "Git",
        "CI/CD Pipelines",
        "VAPT Remediation",
        "OOPs",
        "MVVM",
        "Android Studio",
        "Xcode",
        "Firebase Analytics",
        "Firebase Crashlytics",
        "FCM",
        "Postman",
        "MCP",
        "Automated Agents",
      ],
    ),
  ],

  experiences: [
    ExperienceItem(
      role: "SDE - 1",
      company: "Rootquotient",
      location: "Chennai, Tamil Nadu",
      period: "Jun 2024 – Present",
      bulletPoints: [
        "Architected secure, scalable Flutter apps across 5+ mobile products; remediated VAPT vulnerabilities for a fintech application.",
        "Conducted on-device LLM PoCs using MediaPipe and LiteRT LM, benchmarking latency and feasibility vs. cloud-hosted models.",
        "Bridged native platform capabilities into Flutter via Method Channels, including payment gateways and third-party SDK embedding (Android/iOS).",
        "Optimized network layers with Hive-backed interceptor caching, reducing average load times by 30–40%.",
        "Engineered real-time live dashboard streaming via WebSockets across multiple concurrent data sources.",
        "Built cross-platform background/foreground/terminated geofencing PoCs for Android & iOS.",
        "Authored reusable CI/CD pipelines with Gradle/CocoaPods/Flutter caching, cutting build times by ~30%.",
        "Maintained 80–90% unit and widget test coverage; analyzed and resolved ANRs/crashes to secure production stability.",
        "Extended application delivery to Flutter Web with dynamic, responsive UX design matched to mobile interfaces.",
        "Mentored junior developers, conducted PR reviews, and collaborated with cross-functional teams to deliver production-ready features.",
        "Managed Play Store and App Store releases, integrated deep linking, and automated workflows to accelerate delivery.",
      ],
    ),
    ExperienceItem(
      role: "SDE – Intern",
      company: "Rootquotient",
      location: "Chennai, Tamil Nadu",
      period: "Jun 2022 – Jan 2023 & Dec 2023 – May 2024",
      bulletPoints: [
        "Contributed to 4+ production Flutter apps, implementing custom UI widgets, integrating REST APIs, and configuring path routing using GoRouter.",
        "Utilized Redux & BLoC state management models and followed modular clean architecture guidelines.",
        "Participated in Agile sprints, ticketing workflows, requirements gathering, and client consultation to align technical designs with business requirements.",
      ],
    ),
  ],

  projects: [
    ProjectItem(
      title: "FitSync",
      subtitle: "Native Android Fitness & Workout Tracker",
      description:
          "An offline-first workout planning and reminder app featuring automated workout cycling, secure authentication, and advanced system integrations.",
      bulletPoints: [
        "Implemented a dynamic workout rotation system with automated transitions and persistent state management using Room and SharedPreferences.",
        "Architected a reliable notification system utilizing AlarmManager for exact alarms, supporting custom snooze logic and boot-completed persistence.",
        "Integrated secure user authentication with JWT-based sessions and EncryptedSharedPreferences for industrial-grade token security.",
        "Developed interactive Home Screen widgets using Jetpack Glance for real-time workout tracking and seamless app navigation via deep links.",
        "Configured verified Android App Links with Digital Asset Links (assetlinks.json) for a unified web-to-app user experience.",
        "Pioneered integration with the Android 16 AppFunctions SDK, exposing app capabilities to system AI agents and voice assistants.",
      ],
      technologies: [
        "Kotlin",
        "Jetpack Compose",
        "MVVM",
        "Hilt",
        "Room",
        "Retrofit",
        "Jetpack Glance",
        "AppFunctions",
        "EncryptedSharedPreferences",
        "AlarmManager",
        "Node.js",
        "Express.js",
        "JWT",
        "Firebase Hosting",
      ],
      githubUrl: "https://github.com/Nary-Vip",
    ),
    ProjectItem(
      title: "AntiGeofence",
      subtitle: "Cross-Platform Background Geofencing",
      description:
          "A robust Flutter application that monitors geographical boundaries in the background, interfacing with native iOS (CoreLocation / CLCircularRegion) and Android (Google Play Services Geofencing) APIs via Method Channels.",
      bulletPoints: [
        "Monitors geofence transitions (entering/exiting) in foreground, background, and killed/terminated application states.",
        "Allows circular geofence creation by inputting a name, coordinate (latitude/longitude), and radius in meters.",
        "Supports time-bound activation (e.g., active from 09:00 to 17:00), triggering alerts only if transitions occur within the window.",
        "Persists geofence configurations offline using Android's SharedPreferences and iOS's UserDefaults.",
        "Logs boundary crossing events with coordinates and timestamps, exporting them to a local CSV file (geofence_logs.csv).",
        "Includes a two-tab dashboard interface ('Fences' to manage toggles and configurations, 'Logs' to review and share event CSV logs).",
      ],
      technologies: [
        "Flutter",
        "Dart",
        "Method Channels",
        "Kotlin",
        "Swift",
        "CoreLocation",
        "CLCircularRegion",
        "Google Play Services Geofencing",
        "SharedPreferences",
        "UserDefaults",
        "CSV Export",
      ],
      githubUrl: "https://github.com/Nary-Vip",
    ),
    ProjectItem(
      title: "NaryBtChats",
      subtitle: "Native Android Bluetooth Communication Platform",
      description:
          "A peer-to-peer messaging application that enables real-time communication between Android devices using Bluetooth technology, designed for seamless connectivity in environments without cellular or internet access.",
      bulletPoints: [
        "Implements robust discovery and pairing workflows using Android's Bluetooth Classic and BLE APIs with comprehensive runtime permission handling.",
        "Built with a modern Jetpack Compose UI, leveraging StateFlow and Coroutines for reactive state management and real-time UI updates during device scanning.",
        "Utilizes Dagger-Hilt for dependency injection, ensuring a scalable and testable architecture by decoupling Bluetooth hardware controllers from the presentation layer.",
        "Employs Clean Architecture patterns with distinct domain and data layers to maintain a strict separation of concerns and testable business logic.",
        "Architected with MVVM, synchronizing scanned and paired device states through complex Flow transformations and state-holding ViewModels.",
        "Features a streamlined interface for managing device visibility, handling connection requests, and initiating direct peer-to-peer chat sessions.",
      ],
      technologies: [
        "Kotlin",
        "Jetpack Compose",
        "MVVM",
        "Hilt",
        "Bluetooth API",
        "Coroutines",
        "StateFlow",
        "Clean Architecture",
        "Android SDK",
        "Dagger",
      ],
      githubUrl: "https://github.com/Nary-Vip",
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
          "Naresh specializes in cross-platform mobile development using Flutter and Dart, with over 2 years of experience. He is also highly skilled in integrating native capabilities (Kotlin/Compose, Swift) via Method Channels, setting up optimized CI/CD pipelines, and writing backend systems using Node.js and TypeScript.",
    ),
    ChatbotFAQ(
      question: "Can he integrate native Android and iOS features in Flutter?",
      answer:
          "Yes, absolutely! He has extensive experience building custom Method Channels for native features, including security SDKs, geofencing (foreground & background states), and custom payment integrations on both Android and iOS.",
    ),
    ChatbotFAQ(
      question:
          "What optimizations has he delivered for build and network times?",
      answer:
          "He configured Hive-backed networking caches that reduced API load times by 30-40%. Additionally, he engineered reusable CI/CD pipeline caching structures, cutting Gradle, CocoaPods, and Flutter compile durations by ~30%.",
    ),
    ChatbotFAQ(
      question: "What is his academic background?",
      answer:
          "Naresh graduated from the Coimbatore Institute of Technology (CIT) in 2024 with an Integrated M.Sc. in Artificial Intelligence and Machine Learning, achieving a strong CGPA of 8.44.",
    ),
    ChatbotFAQ(
      question: "Is he familiar with Agentic AI and LLM integrations?",
      answer:
          "Yes, he conducted on-device LLM proof-of-concepts using MediaPipe and LiteRT. He holds certifications from Anthropic in Model Context Protocol (MCP), Agent Skills, and Claude Code, demonstrating a strong foundation in modern AI agent development.",
    ),
  ],
  impactMetrics: [
    ImpactMetric(
      value: "2+",
      label: "Years Experience",
      description: "Developing robust mobile applications for Android and iOS using Flutter and native integrations.",
      iconName: "work_outline",
    ),
    ImpactMetric(
      value: "Modular",
      label: "Clean Architecture",
      description: "Designing modular and testable codebases using Clean Architecture and MVVM patterns.",
      iconName: "layers_outlined",
    ),
    ImpactMetric(
      value: "Optimized",
      label: "Performance Profiling",
      description: "Profiling mobile rendering cycles with DevTools to eliminate layout and memory bottlenecks.",
      iconName: "speed_outlined",
    ),
    ImpactMetric(
      value: "80-90%",
      label: "Test Coverage",
      description: "Maintaining codebase reliability and stability by securing robust unit and widget test coverage.",
      iconName: "checklist_outlined",
    ),
    ImpactMetric(
      value: "Real-time",
      label: "WebSocket & SSE",
      description: "Engineered low-latency WebSockets and Server-Sent Events for real-time data streaming.",
      iconName: "sync_outlined",
    ),
  ],
);

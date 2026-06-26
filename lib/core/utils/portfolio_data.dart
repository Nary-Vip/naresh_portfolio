class SandboxSnippet {
  final String fileName;
  final String language;
  final String code;
  final String problemSolved;
  final String implementation;
  final String result;
  final String iconName; // 'kotlin', 'dart', 'typescript'

  const SandboxSnippet({
    required this.fileName,
    required this.language,
    required this.code,
    required this.problemSolved,
    required this.implementation,
    required this.result,
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
  final List<SandboxSnippet> sandboxSnippets; // Sandbox Snippets

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
    required this.sandboxSnippets,
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
        "Automated Testing",
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
        "Mentored junior developers, conducted PR reviews, and collaborated with cross-functional teams to deliver production-ready features.",
        "Conducted on-device LLM PoCs using MediaPipe and LiteRT LM, benchmarking latency and feasibility vs. cloud-hosted models.",
        "Bridged native platform capabilities into Flutter via Method Channels, including payment gateways and third-party SDK embedding (Android/iOS).",
        "Optimized network layers with Hive-backed interceptor caching, reducing average load times by 30–40%.",
        "Engineered real-time live dashboard streaming via WebSockets across multiple concurrent data sources.",
        "Built cross-platform background/foreground/terminated geofencing PoCs for Android & iOS.",
        "Authored reusable CI/CD pipelines with Gradle/CocoaPods/Flutter caching, cutting build times by ~30%.",
        "Maintained 80–90% unit and widget test coverage; analyzed and resolved ANRs/crashes to secure production stability.",
        "Extended application delivery to Flutter Web with dynamic, responsive UX design matched to mobile interfaces.",
        "Managed Play Store and App Store deployment pipelines, integrated deep linking, and automated workflows to accelerate delivery.",
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
      subtitle: "Native Android Workout Management Application",
      description:
          "An offline-first workout planning and reminder app with secure authentication and rate-limited backend API.",
      bulletPoints: [
        "Built an offline-first exercise scheduler with secure tokens using EncryptedDataStore.",
        "Configured robust AlarmManager-based notifications supporting custom snooze logic.",
        "Developed Node.js/Express.js backend with JWT validation, custom session interceptors, and a sliding-window rate limiter.",
      ],
      technologies: [
        "Kotlin",
        "Jetpack Compose",
        "MVVM",
        "Hilt",
        "Room",
        "OkHttp",
        "EncryptedDataStore",
        "Node.js",
        "Express.js",
        "TypeScript",
        "JWT",
        "AlarmManager",
      ],
      githubUrl: "https://github.com/Nary-Vip",
    ),
    ProjectItem(
      title: "Fintech Mobile Wallet",
      subtitle: "Secure Payment App with VAPT Compliance",
      description:
          "A production-grade fintech app featuring robust native security and real-time dashboard analytics.",
      bulletPoints: [
        "Remediated critical VAPT vulnerabilities, implementing anti-rooting, SSL pinning, and encrypted local storage.",
        "Integrated direct native Method Channels for secure payment SDK components.",
        "Engineered real-time dashboard updates via persistent WebSockets.",
      ],
      technologies: [
        "Flutter",
        "Dart",
        "Method Channels",
        "WebSockets",
        "VAPT",
        "Hive",
        "Dio",
      ],
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
  sandboxSnippets: [
    SandboxSnippet(
      fileName: "SecureBridge.kt",
      language: "Kotlin",
      iconName: "kotlin",
      problemSolved:
          "Remediation of critical VAPT (Vulnerability Assessment and Penetration Testing) vulnerabilities in a production fintech wallet.",
      implementation:
          "Written in native Kotlin. It generates hardware-backed cryptographic keys via Android KeyStore and detects rooted devices to prevent session hijacking.",
      result:
          "Exposed to Flutter via custom Method Channels, securing user wallets against local environment attacks.",
      code: """package com.rootquotient.portfolio.security

import io.flutter.plugin.common.MethodChannel
import android.content.Context

class SecureBridge(private val context: Context) {
    companion object {
        const val CHANNEL = "com.rootquotient.app/security"
    }

    fun handleMethod(method: String, args: Map<String, Any>?, result: MethodChannel.Result) {
        when (method) {
            "isDeviceRooted" -> {
                val isRooted = CheckRoot.isRooted(context)
                result.success(isRooted)
            }
            "initSecureStorage" -> {
                val alias = args?.get("alias") as? String ?: "default_key"
                val success = KeystoreHelper.generateKey(alias)
                result.success(success)
            }
            else -> result.notImplemented()
        }
    }
}""",
    ),
    SandboxSnippet(
      fileName: "cache_interceptor.dart",
      language: "Dart",
      iconName: "dart",
      problemSolved:
          "High network latency and repetitive API calls causing poor user experience and redundant server loads.",
      implementation:
          "Built a custom middleware interceptor for the Dio network client, using a local Hive box to store and serve cached JSON responses key-value style.",
      result:
          "Reduced average mobile app screen load times by 30-40% and improved offline usability.",
      code: """import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class CacheInterceptor extends Interceptor {
  final Box _cacheBox;
  CacheInterceptor(this._cacheBox);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method == 'GET') {
      final cachedData = _cacheBox.get(options.uri.toString());
      if (cachedData != null) {
        return handler.resolve(Response(
          requestOptions: options,
          data: cachedData,
          statusCode: 200,
        ));
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.method == 'GET' && response.statusCode == 200) {
      _cacheBox.put(response.requestOptions.uri.toString(), response.data);
    }
    super.onResponse(response, handler);
  }
}""",
    ),
    SandboxSnippet(
      fileName: "rate_limiter.ts",
      language: "TypeScript",
      iconName: "typescript",
      problemSolved:
          "Protecting server-side authorization routes and APIs from Denial of Service (DoS) and brute-force attacks.",
      implementation:
          "Express middleware using Redis sorted sets (ZSET) to implement a highly precise sliding-window rate limiting algorithm.",
      result:
          "Prevents backend server load spikes while maintaining a smooth experience for legitimate client requests.",
      code: """import { Request, Response, NextFunction } from 'express';
import redisClient from '../config/redis';

export const rateLimiter = async (req: Request, res: Response, next: NextFunction) => {
    const ip = req.ip;
    const limit = 100; // max requests
    const windowMs = 60000; // 1 minute window

    const currentTimestamp = Date.now();
    const key = `ratelimit:\${ip}`;

    const transaction = redisClient.multi();
    transaction.zremrangebyscore(key, 0, currentTimestamp - windowMs);
    transaction.zadd(key, currentTimestamp, currentTimestamp.toString());
    transaction.zcard(key);
    transaction.expire(key, Math.ceil(windowMs / 1000));

    const results = await transaction.exec();
    const requestCount = results ? (results[2] as number) : 0;

    if (requestCount > limit) {
        return res.status(429).json({ error: 'Too many requests' });
    }
    next();
};""",
    ),
  ],
);

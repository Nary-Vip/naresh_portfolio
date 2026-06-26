import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/portfolio_data.dart';
import '../../../../core/utils/responsive.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1500));

    setState(() {
      _isSubmitting = false;
    });

    if (!mounted) return;

    // Show a success message dialog
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: theme.primaryColor, size: 28),
              const SizedBox(width: 12),
              const Text("Message Sent!"),
            ],
          ),
          content: const Text(
            "Thank you for reaching out. Naresh's AI Assistant has processed your message and will notify him immediately.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Great",
                style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
              ),
            )
          ],
        );
      },
    );

    // Clear form inputs
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $urlString");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 24,
        vertical: 40,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            // Section header
            _buildSectionTitle(theme),
            const SizedBox(height: 40),

            // Form + Details Columns
            Responsive(
              desktop: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildContactDetails(theme, isDark),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    flex: 7,
                    child: _buildContactForm(theme, isDark),
                  ),
                ],
              ),
              mobile: Column(
                children: [
                  _buildContactDetails(theme, isDark),
                  const SizedBox(height: 40),
                  _buildContactForm(theme, isDark),
                ],
              ),
            ),

            const SizedBox(height: 80),
            // Footer Copyright
            const Divider(),
            const SizedBox(height: 24),
            Text(
              "© ${DateTime.now().year} R M Naresh Kumar. Built with Flutter Web.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme) {
    return Column(
      children: [
        Text(
          "GET IN TOUCH",
          style: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 50,
          height: 3,
          color: theme.primaryColor,
        ),
      ],
    );
  }

  Widget _buildContactDetails(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let's Create Something Great Together",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "I'm open to full-time roles, strategic consulting, and mobile engineering partnerships. Drop me an email or click any handle to chat directly.",
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),

        // Direct Handles
        _buildContactItem(
          theme,
          isDark,
          Icons.email_outlined,
          "Email",
          nareshPortfolioData.email,
          "mailto:${nareshPortfolioData.email}",
        ),
        const SizedBox(height: 20),
        _buildContactItem(
          theme,
          isDark,
          Icons.phone_outlined,
          "Phone",
          nareshPortfolioData.phone,
          "tel:${nareshPortfolioData.phone}",
        ),
        const SizedBox(height: 20),
        _buildContactItem(
          theme,
          isDark,
          Icons.code_outlined,
          "GitHub",
          "Nary-Vip",
          nareshPortfolioData.githubUrl,
        ),
        const SizedBox(height: 20),
        _buildContactItem(
          theme,
          isDark,
          Icons.link_outlined,
          "LinkedIn",
          "naresh25",
          nareshPortfolioData.linkedinUrl,
        ),
      ],
    );
  }

  Widget _buildContactItem(
    ThemeData theme,
    bool isDark,
    IconData icon,
    String label,
    String val,
    String url,
  ) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: theme.primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  val,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactForm(ThemeData theme, bool isDark) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Drop A Message",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 24),

              // Name Field
              TextFormField(
                controller: _nameController,
                validator: (val) => val == null || val.isEmpty ? "Please enter your name" : null,
                decoration: _buildInputDecoration(theme, "Your Name", Icons.person_outline),
              ),
              const SizedBox(height: 20),

              // Email Field
              TextFormField(
                controller: _emailController,
                validator: (val) {
                  if (val == null || val.isEmpty) return "Please enter your email";
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                    return "Please enter a valid email address";
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: _buildInputDecoration(theme, "Your Email Address", Icons.mail_outline),
              ),
              const SizedBox(height: 20),

              // Message Field
              TextFormField(
                controller: _messageController,
                validator: (val) => val == null || val.isEmpty ? "Please enter a message" : null,
                maxLines: 5,
                decoration: _buildInputDecoration(theme, "Your Message Details...", Icons.chat_bubble_outline),
              ),
              const SizedBox(height: 24),

              // Send Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          "Send Message",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(ThemeData theme, String hint, IconData prefixIcon) {
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF222222) : Colors.grey.shade300;
    
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(prefixIcon, color: theme.primaryColor.withOpacity(0.7)),
      filled: true,
      fillColor: isDark ? const Color(0xFF0C0C0C) : Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }
}

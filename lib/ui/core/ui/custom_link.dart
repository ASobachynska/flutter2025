import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:digital_department_app/ui/core/themes/colors.dart';

class CustomLink extends StatefulWidget {
  final String text;
  final String url;

  const CustomLink({super.key, required this.text, required this.url});

  @override
  State<CustomLink> createState() => _CustomLinkState();
}

class _CustomLinkState extends State<CustomLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => _launchUrl(widget.url),
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              _isHovered = true;
            });
          },
          onExit: (_) {
            setState(() {
              _isHovered = false;
            });
          },
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 16,
              color: _isHovered ? AppColors.primary : AppColors.linkColor,
              decoration:
                  _isHovered ? TextDecoration.none : TextDecoration.underline,
              decorationColor: AppColors.linkColor,
              decorationThickness: 1.5, // Товщина підкреслення
            ),
          ),
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Не вдалося відкрити $url');
    }
  }
}

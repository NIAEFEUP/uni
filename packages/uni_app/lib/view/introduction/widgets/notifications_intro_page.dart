import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/generated/l10n.dart';

class NotificationsIntroPage extends StatefulWidget {
  const NotificationsIntroPage({
    super.key,
    required this.pageController,
    required this.onPermissionChanged,
    required this.notificationPermission,
  });

  final PageController pageController;
  final void Function(bool) onPermissionChanged;
  final bool notificationPermission;

  @override
  State<NotificationsIntroPage> createState() => _NotificationsIntroPageState();
}

class _NotificationsIntroPageState extends State<NotificationsIntroPage> {
  final NotificationManager _notificationManager = NotificationManager();

  @override
  void initState() {
    super.initState();
    _loadNotificationPermission();
  }

  Future<void> _loadNotificationPermission() async {
    final granted = await _notificationManager.hasNotificationPermission();
    if (!mounted) {
      return;
    }
    widget.onPermissionChanged(granted);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(0, -0.85),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              const Icon(
                Icons.notifications_rounded,
                size: 48,
                color: Color(0xFFFFF5F3),
              ),
              Text(
                S.of(context).notifications.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xFFFFF5F3),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  S.of(context).notifications_intro_message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFFFFF5F3),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: const Alignment(0, 0.3),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFFF5F3).withValues(alpha: 0.1),
                    shape: RoundedSuperellipseBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 12,
                      children: [
                        Icon(
                          widget.notificationPermission
                              ? Icons.check_circle_rounded
                              : Icons.error_rounded,
                          size: 32,
                          color: const Color(0xFFFFF5F3),
                        ),
                        Text(
                          widget.notificationPermission
                              ? 'uni has permission to send you notifications.'
                              : 'uni does not have permission to send you notifications yet.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFFFFF5F3),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

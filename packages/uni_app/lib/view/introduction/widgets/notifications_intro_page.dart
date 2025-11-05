import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/generated/l10n.dart';

class NotificationsIntroPage extends StatefulWidget {
  const NotificationsIntroPage({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<NotificationsIntroPage> createState() => _NotificationsIntroPageState();
}

class _NotificationsIntroPageState extends State<NotificationsIntroPage> {
  final NotificationManager _notificationManager = NotificationManager();

  bool notificationPermission = false;

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
    setState(() {
      notificationPermission = granted;
    });
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
                          notificationPermission
                              ? Icons.check_circle_rounded
                              : Icons.error_rounded,
                          size: 32,
                          color: const Color(0xFFFFF5F3),
                        ),
                        Text(
                          notificationPermission
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
        Align(
          alignment: const Alignment(0, 0.95),
          child:
              notificationPermission
                  ? GestureDetector(
                    onTap: () {
                      widget.pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: ShapeDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment(-0.24, -0.31),
                          colors: [Color(0xFF280709), Color(0xFF461014)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0xBF996B6E),
                            blurRadius: 22,
                            offset: Offset(0, 7),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xFFFFF5F3),
                          size: 24,
                        ),
                      ),
                    ),
                  )
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 32,
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          child: const Center(
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFFFFF5F3),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            await NotificationManager()
                                .initializeNotifications();
                            final granted =
                                await _notificationManager
                                    .hasNotificationPermission();
                            if (!mounted) {
                              return;
                            }
                            setState(() {
                              notificationPermission = granted;
                            });
                          } catch (_) {}
                        },
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          decoration: ShapeDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.bottomRight,
                              end: Alignment(-0.24, -0.31),
                              colors: [Color(0xFF280709), Color(0xFF461014)],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0xBF996B6E),
                                blurRadius: 22,
                                offset: Offset(0, 7),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Allow',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFFFFF5F3),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      ],
    );
  }
}

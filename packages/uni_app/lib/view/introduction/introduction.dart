import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni/controller/background_workers/notifications.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/introduction/widgets/exams_intro_page.dart';
import 'package:uni/view/introduction/widgets/first_page.dart';
import 'package:uni/view/introduction/widgets/map_intro_page.dart';
import 'package:uni/view/introduction/widgets/notifications_intro_page.dart';
import 'package:uni/view/introduction/widgets/restaurants_intro_page.dart';
import 'package:uni/view/introduction/widgets/schedule_intro_page.dart';
import 'package:uni/view/introduction/widgets/services_intro_page.dart';

class IntroductionScreenView extends StatefulWidget {
  const IntroductionScreenView({super.key});

  @override
  State<IntroductionScreenView> createState() => _IntroductionScreenViewState();
}

class _IntroductionScreenViewState extends State<IntroductionScreenView>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  bool _notificationPermission = false;
  final NotificationManager _notificationManager = NotificationManager();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _pageController = PageController();
    _pageController.addListener(() {
      if (_pageController.page?.round() != _currentPage) {
        setState(() {
          _currentPage = _pageController.page?.round() ?? 0;
        });
      }
    });
    _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    final granted = await _notificationManager.hasNotificationPermission();
    if (mounted) {
      setState(() {
        _notificationPermission = granted;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 6) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishIntro();
    }
  }

  void _finishIntro() {
    Navigator.of(
      context,
    ).pushReplacementNamed('/${NavigationItem.navPersonalArea.route}');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF280709),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.95, -1),
                colors: [Color(0x705F171D), Color(0x02511515)],
                stops: [0, 1],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.1, 0.95),
                radius: 0.3,
                colors: [Color(0x705F171D), Color(0x02511515)],
                stops: [0, 1],
              ),
            ),
          ),
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              FirstPage(pageController: _pageController),
              ScheduleIntroPage(pageController: _pageController),
              ExamsIntroPage(pageController: _pageController),
              RestaurantsIntroPage(pageController: _pageController),
              ServicesIntroPage(pageController: _pageController),
              MapIntroPage(pageController: _pageController),
              NotificationsIntroPage(
                pageController: _pageController,
                notificationPermission: _notificationPermission,
                onPermissionChanged: (granted) {
                  setState(() {
                    _notificationPermission = granted;
                  });
                },
              ),
            ],
          ),
          Align(alignment: const Alignment(0, 0.95), child: _buildBottomArea()),
        ],
      ),
    );
  }

  Widget _buildBottomArea() {
    if (_currentPage == 6 && !_notificationPermission) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 32,
        children: [
          GestureDetector(
            onTap: _finishIntro,
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: Center(
                child: Text(
                  S.of(context).skip,
                  style: const TextStyle(
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
                await _notificationManager.initializeNotifications();
                final granted = await _notificationManager
                    .hasNotificationPermission();
                if (mounted) {
                  setState(() {
                    _notificationPermission = granted;
                  });
                }
              } catch (_) {}
            },
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
              child: Center(
                child: Text(
                  S.of(context).allow,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFFFFF5F3),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: _nextPage,
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
    );
  }
}

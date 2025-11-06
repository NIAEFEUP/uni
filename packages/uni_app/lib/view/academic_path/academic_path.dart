import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/providers/riverpod/exam_provider.dart';
import 'package:uni/model/providers/riverpod/lecture_provider.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/academic_path/courses_page.dart';
import 'package:uni/view/academic_path/exam_page.dart';
import 'package:uni/view/academic_path/schedule_page.dart';
import 'package:uni/view/widgets/pages_layouts/general/general.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/tabs/tab_icon.dart';

class AcademicPathPageView extends ConsumerStatefulWidget {
  const AcademicPathPageView({super.key, this.initialTabIndex = 0});
  final int initialTabIndex;

  @override
  ConsumerState<AcademicPathPageView> createState() =>
      AcademicPathPageViewState();
}

class AcademicPathPageViewState
    extends GeneralPageViewState<AcademicPathPageView>
    with SingleTickerProviderStateMixin {
  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navAcademicPath.route);

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget? getHeader(BuildContext context) {
    return TabBar(
      controller: tabController,
      dividerHeight: 1,
      tabs: [
        TabIcon(icon: UniIcons.courses, text: S.of(context).courses),
        TabIcon(icon: UniIcons.lecture, text: S.of(context).lectures),
        TabIcon(icon: UniIcons.exam, text: S.of(context).exams),
      ],
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return IndexedStack(
      index: tabController.index,
      children: [const CoursesPage(), SchedulePage(), const ExamsPage()],
    );
  }

  @override
  Future<void> onRefresh() async {
    switch (tabController.index) {
      case 0:
        await ref.read(profileProvider.notifier).refreshRemote();
      case 1:
        await ref.read(lectureProvider.notifier).refreshRemote();
      case 2:
        await ref.read(examProvider.notifier).refreshRemote();
    }
  }
}

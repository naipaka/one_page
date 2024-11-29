import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:diary/diary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:scroll_calendar/scroll_calendar.dart';
import 'package:widgets/widgets.dart';

import 'stub_diaries_state_provider.dart';

/// Home page when the app is opened.
class HomePage extends HookConsumerWidget {
  /// [HomePage] constructor.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    // Get the list of dates for the previous month for calendar display.
    final now = useMemoized(() => clock.now());
    final datesState = useState(now.datesInMonths(-1, 0));

    // Create a controller to manage the scroll position of the calendar.
    final scrollCalendarController = useMemoized(ScrollCalendarController.new);

    final asyncDiaries = ref.watch(stubDiariesStateProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: scrollCalendarController.scrollToToday,
            child: Text(t.home.today),
          ),
        ],
      ),
      drawer: const Drawer(),
      body: SafeArea(
        child: VerticalScrollCalendar(
          controller: scrollCalendarController,
          dates: datesState.value,
          loadMoreOlder: () {
            datesState.value = [
              // Add the previous month's dates to the beginning of the list.
              ...datesState.value.first.previousMonthDates,
              ...datesState.value,
            ];
          },
          separatorBuilder: (_, __) => const Gap(32),
          dateItemBuilder: (_, date) {
            return asyncDiaries.when(
              error: (_, __) => centerLoadingIndicator,
              loading: () => centerLoadingIndicator,
              data: (diaries) {
                final diary = diaries.firstWhereOrNull(
                  (e) => DateUtils.isSameDay(e.date, date),
                );
                return DiaryListTile(
                  content: diary?.content ?? '',
                );
              },
            );
          },
        ),
      ),
    );
  }
}

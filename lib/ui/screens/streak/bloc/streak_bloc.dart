import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/repositories/streak_repository.dart';

part 'streak_event.dart';

part 'streak_state.dart';

part 'generated/streak_bloc.freezed.dart';

class StreakBloc extends Bloc<StreakEvent, StreakState> {
  final StreakRepository _streakRepository;
  static const int timePerDayNeeded = 60 * 5; // 5 minutes

  Timer? _streakTimer;
  bool _disposed = false;

  StreakBloc({
    required StreakRepository streakRepository,
  })  : _streakRepository = streakRepository,
        super(const StreakState()) {
    on<StreakEvent>((event, emit) async {
      if (_disposed) return; // Không xử lý sự kiện nếu đã disposed
      await event.map(
        watchStreak: (event) => _onWatchStreak(event, emit),
        emitState: (event) => _onEmitState(event, emit),
      );
    });
  }

  _onWatchStreak(WatchStreak event, Emitter<StreakState> emit) {
    if (_disposed) return; // Kiểm tra trước khi xử lý
    debugPrint('StreakBloc: watchStreak');
    final timeStreak = _streakRepository.getTimeStreak();
    final longestStreak = _streakRepository.longestStreak;
    final streak = _streakRepository.streak;
    debugPrint('StreakBloc: timeStreak: $timeStreak');
    debugPrint('StreakBloc: longestStreak: $longestStreak');
    debugPrint('StreakBloc: streak: $streak');

    if (_disposed) return; // Kiểm tra lại trước khi emit
    emit(StreakState(
      spentTimeToday: timeStreak,
      longestStreak: longestStreak,
      streak: streak,
    ));

    _streakTimer?.cancel();
    _streakTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_disposed || isClosed) {
        timer.cancel();
        return;
      }

      try {
        final newSpentTimeToday = _streakRepository.getTimeStreak() + 1;

        if (_disposed || isClosed) {
          timer.cancel();
          return;
        }

        // Cập nhật thời gian trong repository trước
        if (!_streakRepository.streakedToday) {
          _streakRepository.setTimeStreak(newSpentTimeToday);
        }

        // Sau đó mới emit state nếu bloc vẫn còn hoạt động
        if (!_disposed && !isClosed) {
          add(StreakEvent.emitState(state.copyWith(
            spentTimeToday: newSpentTimeToday,
          )));

          debugPrint('StreakBloc: newSpentTimeToday: $newSpentTimeToday');

          if (newSpentTimeToday >= timePerDayNeeded &&
              !_streakRepository.streakedToday) {
            final newStreak = _streakRepository.streak + 1;
            final newLongestStreak =
                newStreak > longestStreak ? newStreak : longestStreak;

            _streakRepository.setStreak(newStreak);

            if (!_disposed && !isClosed) {
              add(StreakEvent.emitState(state.copyWith(
                streak: newStreak,
                longestStreak: newLongestStreak,
              )));
            }
          }
        }
      } catch (e) {
        debugPrint('StreakBloc: Error in timer: $e');
        timer.cancel();
      }
    });
  }

  _onEmitState(EmitState event, Emitter<StreakState> emit) {
    if (_disposed) return; // Kiểm tra trước khi emit
    emit(event.state);
  }

  @override
  Future<void> close() {
    debugPrint('StreakBloc: close called');
    _disposed = true;
    _streakTimer?.cancel();
    _streakTimer = null;
    return super.close();
  }
}

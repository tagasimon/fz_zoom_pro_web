import 'package:field_zoom_pro_web/core/models/session_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final sessionNotifierProvider =
    StateNotifierProvider<SessionNotifier, SessionModel>((ref) {
  return SessionNotifier();
});

class SessionNotifier extends StateNotifier<SessionModel> {
  SessionNotifier()
      : super(
          SessionModel(
              startDate: DateHelpers.startOfTheWeekDate(),
              endDate: DateHelpers.endOfTodayDate()),
        );

  void updateSession({
    UserModel? loggedInUser,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    state = state.copyWith(
      loggedInUser: loggedInUser,
      startDate: startDate,
      endDate: endDate,
    );
  }

  // reset filter
  void resetSession() {
    state = SessionModel(
      loggedInUser: state.loggedInUser,
      startDate: DateHelpers.startOfTheWeekDate(),
      endDate: DateHelpers.endOfTodayDate(),
    );
  }
}

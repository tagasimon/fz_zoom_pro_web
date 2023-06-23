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
              startDate: DateHelpers.startDateOfMonth(),
              endDate: DateHelpers.endOfTodayDate()),
        );

  void updateRegion({required String region}) {
    state = SessionModel(
      loggedInuser: state.loggedInuser,
      region: region,
      route: null,
      selectedUserId: null,
      startDate: state.startDate,
      endDate: state.endDate,
    );
  }

  void updateRoute({required String route}) {
    state = SessionModel(
      loggedInuser: state.loggedInuser,
      region: state.region,
      route: route,
      selectedUserId: null,
      startDate: state.startDate,
      endDate: state.endDate,
    );
  }

  void updateSelectedUser({required String selectedUserId}) {
    state = SessionModel(
      loggedInuser: state.loggedInuser,
      region: state.region,
      route: state.route,
      selectedUserId: selectedUserId,
      startDate: state.startDate,
      endDate: state.endDate,
    );
  }

  void updateSession({
    UserModel? loggedInUser,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    state = state.copyWith(
      loggedInuser: loggedInUser,
      startDate: startDate,
      endDate: endDate,
    );
  }

  // reset filter
  void resetSession() {
    state = SessionModel(
      loggedInuser: state.loggedInuser,
      startDate: DateHelpers.startDateOfMonth(),
      endDate: DateHelpers.endOfTodayDate(),
    );
  }
}

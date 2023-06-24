import 'package:field_zoom_pro_web/core/models/quick_filter_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quickfilterNotifierProvider =
    StateNotifierProvider<QuickFilterNotifier, QuickFilterModel>((ref) {
  return QuickFilterNotifier();
});

class QuickFilterNotifier extends StateNotifier<QuickFilterModel> {
  QuickFilterNotifier() : super(QuickFilterModel());
  void updateRegion({required String region}) {
    state = QuickFilterModel(
      region: region,
      route: null,
      selectedUserId: null,
    );
  }

  // void updateRoute({required String route}) {
  //   state = QuickFilterModel(
  //     region: state.region,
  //     route: route,
  //     selectedUserId: null,
  //   );
  // }

  void updateSelectedUser({required String selectedUserId}) {
    state = QuickFilterModel(
      region: state.region,
      route: state.route,
      selectedUserId: selectedUserId,
    );
  }
}

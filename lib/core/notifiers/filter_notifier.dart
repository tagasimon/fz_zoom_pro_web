import 'dart:developer';

import 'package:field_zoom_pro_web/core/models/filter_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

class FilterNotifier extends StateNotifier<FilterModel> {
  FilterNotifier() : super(FilterModel());

  void updateFilter({
    UserModel? user,
    String? region,
    String? route,
    String? associate,
    DateTime? startDate,
    DateTime? endDate,
    String? stockType,
  }) {
    state = state.copyWith(
      user: user,
      region: region,
      route: route,
      associate: associate,
      startDate: startDate,
      endDate: endDate,
    );
    log(state.toString());
  }
}

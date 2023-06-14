import 'dart:convert';

import 'package:fz_hooks/fz_hooks.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class FilterModel {
  final UserModel? loggedInuser;
  final String? selectedUserId;

  final String? region;
  final String? route;
  final DateTime? startDate;
  final DateTime? endDate;
  FilterModel({
    this.loggedInuser,
    this.selectedUserId,
    this.region,
    this.route,
    this.startDate,
    this.endDate,
  });

  FilterModel copyWith({
    UserModel? loggedInuser,
    String? selectedUserId,
    String? region,
    String? route,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return FilterModel(
      loggedInuser: loggedInuser ?? this.loggedInuser,
      selectedUserId: selectedUserId ?? this.selectedUserId,
      region: region ?? this.region,
      route: route ?? this.route,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'loggedInuser': loggedInuser?.toMap(),
      'selectedUserId': selectedUserId,
      'region': region,
      'route': route,
      'startDate': startDate?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
    };
  }

  factory FilterModel.fromMap(Map<String, dynamic> map) {
    return FilterModel(
      loggedInuser: map['loggedInUser'] != null
          ? UserModel.fromMap(map['loggedInUser'] as Map<String, dynamic>)
          : null,
      selectedUserId: map['selectedUserId'] != null
          ? map['selectedUserId'] as String
          : null,
      region: map['region'] != null ? map['region'] as String : null,
      route: map['route'] != null ? map['route'] as String : null,
      startDate: map['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int)
          : null,
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FilterModel.fromJson(String source) =>
      FilterModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FilterModel(loggedInUser: $loggedInuser,selectedUserId: $selectedUserId, region: $region, route: $route, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(covariant FilterModel other) {
    if (identical(this, other)) return true;

    return other.loggedInuser == loggedInuser &&
        other.selectedUserId == selectedUserId &&
        other.region == region &&
        other.route == route &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    return loggedInuser.hashCode ^
        region.hashCode ^
        route.hashCode ^
        startDate.hashCode ^
        endDate.hashCode;
  }
}

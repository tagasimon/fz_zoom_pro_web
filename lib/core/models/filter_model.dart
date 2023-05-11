import 'dart:convert';

import 'package:fz_hooks/fz_hooks.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class FilterModel {
  final UserModel? user;
  final String? region;
  final String? route;
  final String? associate;
  final DateTime? startDate;
  final DateTime? endDate;
  FilterModel({
    this.user,
    this.region,
    this.route,
    this.associate,
    this.startDate,
    this.endDate,
  });

  FilterModel copyWith({
    UserModel? user,
    String? region,
    String? route,
    String? associate,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return FilterModel(
      user: user ?? this.user,
      region: region ?? this.region,
      route: route ?? this.route,
      associate: associate ?? this.associate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user?.toMap(),
      'region': region,
      'route': route,
      'associate': associate,
      'startDate': startDate?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
    };
  }

  factory FilterModel.fromMap(Map<String, dynamic> map) {
    return FilterModel(
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      region: map['region'] != null ? map['region'] as String : null,
      route: map['route'] != null ? map['route'] as String : null,
      associate: map['associate'] != null ? map['associate'] as String : null,
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
    return 'FilterModel(user: $user, region: $region, route: $route, associate: $associate, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(covariant FilterModel other) {
    if (identical(this, other)) return true;

    return other.user == user &&
        other.region == region &&
        other.route == route &&
        other.associate == associate &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    return user.hashCode ^
        region.hashCode ^
        route.hashCode ^
        associate.hashCode ^
        startDate.hashCode ^
        endDate.hashCode;
  }
}

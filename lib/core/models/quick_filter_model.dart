// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class QuickFilterModel {
  final String? region;
  final String? route;
  final String? selectedUserId;
  QuickFilterModel({
    this.region,
    this.route,
    this.selectedUserId,
  });

  QuickFilterModel copyWith({
    String? region,
    String? route,
    String? selectedUserId,
  }) {
    return QuickFilterModel(
      region: region ?? this.region,
      route: route ?? this.route,
      selectedUserId: selectedUserId ?? this.selectedUserId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'region': region,
      'route': route,
      'selectedUserId': selectedUserId,
    };
  }

  factory QuickFilterModel.fromMap(DocumentSnapshot snapshot) {
    final map = snapshot.data() as Map<String, dynamic>;
    return QuickFilterModel(
      region: map['region'] != null ? map['region'] as String : null,
      route: map['route'] != null ? map['route'] as String : null,
      selectedUserId: map['selectedUserId'] != null
          ? map['selectedUserId'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuickFilterModel.fromJson(String source) =>
      QuickFilterModel.fromMap(json.decode(source) as DocumentSnapshot);

  @override
  String toString() =>
      'QuickFilterModel(region: $region, route: $route, selectedUserId: $selectedUserId)';

  @override
  bool operator ==(covariant QuickFilterModel other) {
    if (identical(this, other)) return true;

    return other.region == region &&
        other.route == route &&
        other.selectedUserId == selectedUserId;
  }

  @override
  int get hashCode =>
      region.hashCode ^ route.hashCode ^ selectedUserId.hashCode;
}

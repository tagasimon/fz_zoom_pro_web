import 'dart:convert';

import 'package:fz_hooks/fz_hooks.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class SessionModel {
  final UserModel? loggedInUser;
  final DateTime startDate;
  final DateTime endDate;
  SessionModel({
    this.loggedInUser,
    required this.startDate,
    required this.endDate,
  });

  SessionModel copyWith({
    UserModel? loggedInUser,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return SessionModel(
      loggedInUser: loggedInUser ?? this.loggedInUser,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'loggedInUser': loggedInUser?.toMap(),
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      loggedInUser: map['loggedInUser'] != null
          ? UserModel.fromMap(map['loggedInUser'])
          : null,
      startDate: map['startDate'],
      endDate: map['endDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionModel.fromJson(String source) =>
      SessionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SessionModel(loggedInUser: $loggedInUser, startDate: $startDate, endDate: $endDate)';

  @override
  bool operator ==(covariant SessionModel other) {
    if (identical(this, other)) return true;

    return other.loggedInUser == loggedInUser &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode =>
      loggedInUser.hashCode ^ startDate.hashCode ^ endDate.hashCode;
}

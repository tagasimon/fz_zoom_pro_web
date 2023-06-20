// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductFilterModel {
  final String? cartegory;
  final String? subCartegory;
  final int itemCount;
  ProductFilterModel({
    this.cartegory,
    this.subCartegory,
    required this.itemCount,
  });

  ProductFilterModel copyWith({
    String? cartegory,
    String? subCartegory,
    int? itemCount,
  }) {
    return ProductFilterModel(
      cartegory: cartegory ?? this.cartegory,
      subCartegory: subCartegory ?? this.subCartegory,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cartegory': cartegory,
      'subCartegory': subCartegory,
      'itemCount': itemCount,
    };
  }

  factory ProductFilterModel.fromMap(Map<String, dynamic> map) {
    return ProductFilterModel(
      cartegory: map['cartegory'] != null ? map['cartegory'] as String : null,
      subCartegory:
          map['subCartegory'] != null ? map['subCartegory'] as String : null,
      itemCount: map['itemCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductFilterModel.fromJson(String source) =>
      ProductFilterModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ProductFilterModel(cartegory: $cartegory, subCartegory: $subCartegory, itemCount: $itemCount)';

  @override
  bool operator ==(covariant ProductFilterModel other) {
    if (identical(this, other)) return true;

    return other.cartegory == cartegory &&
        other.subCartegory == subCartegory &&
        other.itemCount == itemCount;
  }

  @override
  int get hashCode =>
      cartegory.hashCode ^ subCartegory.hashCode ^ itemCount.hashCode;
}

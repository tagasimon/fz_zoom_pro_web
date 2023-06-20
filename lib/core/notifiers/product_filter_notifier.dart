import 'package:field_zoom_pro_web/core/models/product_filter_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productFilterNotifierProvider =
    StateNotifierProvider<ProductFilterNotifier, ProductFilterModel>((ref) {
  return ProductFilterNotifier();
});

class ProductFilterNotifier extends StateNotifier<ProductFilterModel> {
  ProductFilterNotifier() : super(ProductFilterModel(itemCount: 8));

  void updateCartegory({required String cartegoryId}) {
    state = ProductFilterModel(
      cartegory: cartegoryId,
      subCartegory: null,
      itemCount: state.itemCount,
    );
  }

  void updateSubCartegory({required String subCartegoryId}) {
    state = ProductFilterModel(
      cartegory: state.cartegory,
      subCartegory: subCartegoryId,
      itemCount: state.itemCount,
    );
  }

  void updateItemCount({required int itemCount}) {
    state = ProductFilterModel(
      cartegory: state.cartegory,
      subCartegory: state.subCartegory,
      itemCount: itemCount,
    );
  }

  void resetFilter() {
    state = ProductFilterModel(itemCount: state.itemCount);
  }
}

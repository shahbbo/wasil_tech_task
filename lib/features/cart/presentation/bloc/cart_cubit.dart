import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/clear_cart.dart';
import '../../domain/usecases/get_cart_items.dart';
import '../../domain/usecases/remove_from_cart.dart';
import '../../domain/usecases/update_cart_quantity.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final AddToCart addToCartUC;
  final RemoveFromCart removeFromCartUC;
  final UpdateCartQuantity updateQuantity;
  final GetCartItems getCartItems;

  final ClearCart clearCartUC;

  CartCubit(
      {required this.addToCartUC,
      required this.removeFromCartUC,
      required this.updateQuantity,
      required this.getCartItems,
      required this.clearCartUC})
      : super(CartInitial());

  Future<void> loadCartItems() async {
    emit(CartLoading());

    final result = await getCartItems();
    result.fold(
      (failure) => emit(CartError(failure.toString())),
      (items) => emit(CartLoaded(items)),
    );
  }

  Future<void> addToCart(Product product, int quantity) async {
    final result = await addToCartUC(product, quantity);
    result.fold(
      (failure) => emit(CartError(failure.toString())),
      (_) => loadCartItems(),
    );
  }

  Future<void> removeFromCart(int productId) async {
    final result = await removeFromCartUC(productId);
    result.fold(
      (failure) => emit(CartError(failure.toString())),
      (_) => loadCartItems(),
    );
  }

  Future<void> updateItemQuantity(int productId, int quantity) async {
    final result = await updateQuantity(productId, quantity);
    result.fold(
      (failure) => emit(CartError(failure.toString())),
      (_) => loadCartItems(),
    );
  }

  Future<void> clearCart() async {
    final result = await clearCartUC();
    result.fold(
      (failure) => emit(CartError(failure.toString())),
      (_) => loadCartItems(),
    );
  }
}

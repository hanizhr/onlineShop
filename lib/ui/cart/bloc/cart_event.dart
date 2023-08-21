part of 'cart_bloc.dart';

abstract class CartEvent {
  const CartEvent();
}

class CartStarted extends CartEvent {
  final AuthInfo? authInfo;
  final bool isRefreshing;

  const CartStarted(this.authInfo,
      {this.isRefreshing = false, required bool isRefrshing});
}

class CartDeleteButtonClicked extends CartEvent {
  final int cartItemId;

  const CartDeleteButtonClicked(this.cartItemId);
}

class CartAuthInfoChanged extends CartEvent {
  final AuthInfo? authInfo;

  const CartAuthInfoChanged(this.authInfo);
}

class IncreasButtomClicked extends CartEvent {
  final int cartItemId;

  const IncreasButtomClicked(this.cartItemId);
}

class DecreasButtomClicked extends CartEvent {
  final int cartItemId;

  const DecreasButtomClicked(this.cartItemId);
}

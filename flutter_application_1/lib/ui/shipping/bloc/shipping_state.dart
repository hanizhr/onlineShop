part of 'shipping_bloc.dart';

sealed class ShippingState extends Equatable {
  const ShippingState();

  @override
  List<Object> get props => [];
}

final class ShippingInitial extends ShippingState {}

final class ShippingLoading extends ShippingState {}

final class ShippingError extends ShippingState {
  final AppException exception;

  const ShippingError(this.exception);
  @override
  // TODO: implement props
  List<Object> get props => [exception];
}

final class ShippingSuccess extends ShippingState {
  final CreatOrderResult result;

  const ShippingSuccess(this.result);
  @override
  // TODO: implement props
  List<Object> get props => [result];
}

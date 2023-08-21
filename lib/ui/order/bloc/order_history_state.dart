part of 'order_history_bloc.dart';

sealed class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object> get props => [];
}

final class OrderHistoryLoading extends OrderHistoryState {}

final class OrderHistorySuccess extends OrderHistoryState {
  final List<OrderEntity> orders;

  const OrderHistorySuccess(this.orders);
  @override
  // TODO: implement props
  List<Object> get props => [orders];
}

final class OrderHistoryError extends OrderHistoryState {
  final AppException e;

  const OrderHistoryError(this.e);
  @override
  // TODO: implement props
  List<Object> get props => [e];
}

part of 'payment_recipt_bloc.dart';

abstract class PaymentReciptEvent extends Equatable {
  const PaymentReciptEvent();

  @override
  List<Object> get props => [];
}

class PaymentReciptStarted extends PaymentReciptEvent {
  const PaymentReciptStarted(this.orderId);

  final int orderId;

  @override
  // TODO: implement props
  List<Object> get props => [orderId];
}

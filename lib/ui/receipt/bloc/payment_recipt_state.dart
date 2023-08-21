part of 'payment_recipt_bloc.dart';

abstract class PaymentReciptState extends Equatable {
  const PaymentReciptState();

  @override
  List<Object> get props => [];
}

class PaymentReciptLoading extends PaymentReciptState {}

class PaymentReciptSuccess extends PaymentReciptState {
  final PaymentReceiptData paymentReceiptData;

  const PaymentReciptSuccess(this.paymentReceiptData);
  @override
  // TODO: implement props
  List<Object> get props => [paymentReceiptData];
}

class PaymentReciptError extends PaymentReciptState {
  final AppException exception;

  const PaymentReciptError(this.exception);
  @override
  // TODO: implement props
  List<Object> get props => [exception];
}

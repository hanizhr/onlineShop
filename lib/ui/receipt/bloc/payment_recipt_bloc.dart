import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/common/exceptions.dart';
import 'package:flutter_application_1/data/payment_recipt.dart';
import 'package:flutter_application_1/data/repo/order_repository.dart';

part 'payment_recipt_event.dart';
part 'payment_recipt_state.dart';

class PaymentReciptBloc extends Bloc<PaymentReciptEvent, PaymentReciptState> {
  final IOrderRepository repository;
  PaymentReciptBloc(this.repository) : super(PaymentReciptLoading()) {
    on<PaymentReciptEvent>((event, emit) async {
      if (event is PaymentReciptStarted) {
        try {
          emit(PaymentReciptLoading());
          final result = await repository.getPaymentRecepit(event.orderId);
          emit(PaymentReciptSuccess(result));
        } catch (e) {
          emit(PaymentReciptError(AppException()));
        }
      }
    });
  }
}

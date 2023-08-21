part of 'shipping_bloc.dart';

sealed class ShippingEvent extends Equatable {
  const ShippingEvent();

  @override
  List<Object> get props => [];
}

class ShippingCreatOrder extends ShippingEvent {
  final CreatOrderParams params;

  const ShippingCreatOrder(this.params);
}

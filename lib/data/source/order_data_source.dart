import 'package:dio/dio.dart';
import 'package:flutter_application_1/data/order.dart';

import '../payment_recipt.dart';

abstract class IOrderDataSourc {
  Future<CreatOrderResult> creat(CreatOrderParams params);
  Future<PaymentReceiptData> getPaymentRecepit(int orderId);
  Future<List<OrderEntity>> getOrders();
}

class OrderRemoteDataSource implements IOrderDataSourc {
  OrderRemoteDataSource(this.httpClient);

  final Dio httpClient;

  @override
  Future<CreatOrderResult> creat(CreatOrderParams params) async {
    final respose = await httpClient.post('order/submit', data: {
      'first_name': params.firstName,
      'last_name': params.lastName,
      'mobile': params.phoneNumber,
      'postal_code': params.postalCode,
      'address': params.address,
      'payment_method': params.paymentMetod == PaymentMetod.online
          ? 'online'
          : 'cash_on_delivery'
    });
    return CreatOrderResult.fromJson(respose.data);
  }

  @override
  Future<PaymentReceiptData> getPaymentRecepit(int orderId) async {
    final response = await httpClient.get('order/checkout?order_id=$orderId');
    return PaymentReceiptData.fromJson(response.data);
  }

  @override
  Future<List<OrderEntity>> getOrders() async {
    final result = await httpClient.get('order/list');
    return (result.data as List).map((e) => OrderEntity.fromJson(e)).toList();
  }
}

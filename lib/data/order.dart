import 'package:flutter_application_1/data/product.dart';

class CreatOrderResult {
  final int orderId;
  final String bankGetewayUrl;

  CreatOrderResult(this.orderId, this.bankGetewayUrl);
  CreatOrderResult.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'],
        bankGetewayUrl = json['bank_gateway_url'];
}

class CreatOrderParams {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String postalCode;
  final String address;
  final PaymentMetod paymentMetod;

  CreatOrderParams(this.firstName, this.lastName, this.phoneNumber,
      this.postalCode, this.address, this.paymentMetod);
}

enum PaymentMetod { online, cashOnDelivery }

class OrderEntity {
  final int id;
  final int payablePrice;
  final List<ProductEntity> items;

  OrderEntity(this.id, this.payablePrice, this.items);
  OrderEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        payablePrice = json['payable'],
        items = (json['order_items'] as List)
            .map((e) => ProductEntity.fromJson(e['product']))
            .toList();
}

import 'package:flutter_application_1/common/http_client.dart';
import 'package:flutter_application_1/data/order.dart';
import 'package:flutter_application_1/data/payment_recipt.dart';
import 'package:flutter_application_1/data/source/order_data_source.dart';

final orderRepository = OrderRepository(OrderRemoteDataSource(httpClient));

abstract class IOrderRepository extends IOrderDataSourc {}

class OrderRepository implements IOrderRepository {
  final IOrderDataSourc dataSourc;

  OrderRepository(this.dataSourc);
  @override
  Future<CreatOrderResult> creat(CreatOrderParams params) {
    return dataSourc.creat(params);
  }

  @override
  Future<PaymentReceiptData> getPaymentRecepit(int orderId) {
    return dataSourc.getPaymentRecepit(orderId);
  }

  @override
  Future<List<OrderEntity>> getOrders() {
    return dataSourc.getOrders();
  }
}

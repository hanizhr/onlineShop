import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/order.dart';
import 'package:flutter_application_1/data/repo/order_repository.dart';
import 'package:flutter_application_1/ui/shipping/bloc/shipping_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cart/price_info.dart';
import '../payment_webviwe.dart';
import '../receipt/payment_receipt.dart';

class ShippingScreen extends StatefulWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  const ShippingScreen(
      {Key? key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice})
      : super(key: key);

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final TextEditingController firstNameController =
      TextEditingController(text: 'سعید');

  final TextEditingController laseNameController =
      TextEditingController(text: 'شاهینی');

  final TextEditingController phoneNumberController =
      TextEditingController(text: '09121234567');

  final TextEditingController postalCodeController =
      TextEditingController(text: '1234567890');

  final TextEditingController addressController =
      TextEditingController(text: 'خیابان شهید بهشتی خق هجخهجتل جخهشتلخشهت ج');

  StreamSubscription? subscription;
  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحویل گیرنده'),
        centerTitle: false,
      ),
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final bloc = ShippingBloc(orderRepository);
          subscription = bloc.stream.listen((event) {
            if (event is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(event.exception.message)));
            } else if (event is ShippingSuccess) {
              if (event.result.bankGetewayUrl.isNotEmpty) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PaymentWebView(
                          bankGetWayUrl: event.result.bankGetewayUrl,
                        )));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PaymentReceiptScreen(
                          orderId: event.result.orderId,
                        )));
              }
            }
          });
          return bloc;
        },
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(label: Text('نام')),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: laseNameController,
                  decoration:
                      const InputDecoration(label: Text(' نام خانوادگی')),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(label: Text('شماره تماس')),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: postalCodeController,
                  decoration: const InputDecoration(label: Text('کد پستی')),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(label: Text('آدرس')),
                ),
                const SizedBox(
                  height: 12,
                ),
                PriceInfo(
                    payablePrice: widget.payablePrice,
                    shippingCost: widget.shippingCost,
                    totalPrice: widget.totalPrice),
                BlocBuilder<ShippingBloc, ShippingState>(
                  builder: (context, state) {
                    return state is ShippingLoading
                        ? Center(
                            child: CupertinoActivityIndicator(),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                  onPressed: () {
                                    BlocProvider.of<ShippingBloc>(context).add(
                                        ShippingCreatOrder(CreatOrderParams(
                                            firstNameController.text,
                                            laseNameController.text,
                                            phoneNumberController.text,
                                            postalCodeController.text,
                                            addressController.text,
                                            PaymentMetod.cashOnDelivery)));
                                  },
                                  child: const Text('پرداخت در محل')),
                              const SizedBox(
                                width: 16,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<ShippingBloc>(context).add(
                                      ShippingCreatOrder(CreatOrderParams(
                                          firstNameController.text,
                                          laseNameController.text,
                                          phoneNumberController.text,
                                          postalCodeController.text,
                                          addressController.text,
                                          PaymentMetod.online)));
                                },
                                child: const Text('پرداخت اینترنتی'),
                              ),
                            ],
                          );
                  },
                ),
              ],
            )),
      ),
    );
  }
}

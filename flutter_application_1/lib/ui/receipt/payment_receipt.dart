import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/utils.dart';
import 'package:flutter_application_1/data/repo/order_repository.dart';
import 'package:flutter_application_1/ui/receipt/bloc/payment_recipt_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme.dart';

class PaymentReceiptScreen extends StatelessWidget {
  final int orderId;
  const PaymentReceiptScreen({Key? key, required this.orderId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('رسید پرداخت'),
      ),
      body: BlocProvider<PaymentReciptBloc>(
        create: (context) => PaymentReciptBloc(orderRepository)
          ..add(PaymentReciptStarted(orderId)),
        child: BlocBuilder<PaymentReciptBloc, PaymentReciptState>(
          builder: (context, state) {
            if (state is PaymentReciptSuccess) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: themeData.dividerColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          state.paymentReceiptData.purchaseSuccess
                              ? 'پرداخت با موفقیت انجام شد'
                              : 'پرداخت ناموفق',
                          style: themeData.textTheme.headline6!
                              .apply(color: themeData.colorScheme.primary),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'وضعیت سفارش',
                              style: TextStyle(
                                  color: LightThemeColors.secondaryTextColor),
                            ),
                            Text(
                              state.paymentReceiptData.paymentStatus,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          ],
                        ),
                        const Divider(
                          height: 32,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'مبلغ',
                              style: TextStyle(
                                  color: LightThemeColors.secondaryTextColor),
                            ),
                            Text(
                              state.paymentReceiptData.payablePrice
                                  .withPriceLabel,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: const Text('بازگشت به صفحه اصلی'))
                ],
              );
            } else if (state is PaymentReciptError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else if (state is PaymentReciptLoading) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            } else {
              throw Exception("errore");
            }
          },
        ),
      ),
    );
  }
}

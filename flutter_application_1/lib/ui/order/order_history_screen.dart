import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/utils.dart';
import 'package:flutter_application_1/data/repo/order_repository.dart';
import 'package:flutter_application_1/ui/widgets/image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/order_history_bloc.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderHistoryBloc(orderRepository)..add(OrderHistoryStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سوابق خرید'),
          centerTitle: true,
        ),
        body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistorySuccess) {
              final orders = state.orders;
              return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Theme.of(context).dividerColor, width: 1),
                        ),
                        child: Column(children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            height: 56,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('سوایق سفارش'),
                                Text(order.id.toString()),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            height: 56,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(' مبلغ'),
                                Text(order.payablePrice.withPriceLabel),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                          ),
                          SizedBox(
                            height: 132,
                            child: ListView.builder(
                                itemCount: order.items.length,
                                scrollDirection: Axis.horizontal,
                                physics: defaultScrollPhysics,
                                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(left: 8, right: 8),
                                    width: 100,
                                    height: 100,
                                    child: ImageLoadingService(
                                      imageUrl: order.items[index].imageUrl,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  );
                                }),
                          )
                        ]),
                      ),
                    );
                  });
            } else if (state is OrderHistoryError) {
              return Center(
                child: Text(state.e.message),
              );
            } else {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/cart/price_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../data/repo/auth_repository.dart';
import '../../data/repo/cart_repository.dart';
import '../auth/auth.dart';
import '../shipping/shipping.dart';
import '../widgets/empty_view.dart';
import 'bloc/cart_bloc.dart';
import 'cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? cartBloc;
  final RefreshController _refreshController = RefreshController();
  bool stateIsSuccess = false;
  StreamSubscription? stateSubestreation;
  @override
  void initState() {
    super.initState();
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
    cartBloc?.close();
  }

  void authChangeNotifierListener() {
    cartBloc?.add(CartAuthInfoChanged(AuthRepository.authChangeNotifier.value));
  }

  @override
  void dispose() {
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    cartBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("سبد خرید"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
          visible: stateIsSuccess,
          child: Container(
            margin: const EdgeInsets.only(left: 48, right: 48),
            width: MediaQuery.of(context).size.width,
            child: FloatingActionButton.extended(
                onPressed: () {
                  final state = cartBloc!.state;
                  if (state is CartSuccess) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => ShippingScreen(
                              payablePrice: state.cartResponse.payablePrice,
                              shippingCost: state.cartResponse.shippingCost,
                              totalPrice: state.cartResponse.totalPrice,
                            ))));
                  }
                },
                label: const Text('پرداخت')),
          ),
        ),
        body: BlocProvider<CartBloc>(
          create: (context) {
            final bloc = CartBloc(cartRepository);
            cartBloc = bloc;
            stateSubestreation = bloc.stream.listen((state) {
              setState(() {
                stateIsSuccess = state is CartSuccess;
              });
              if (_refreshController.isRefresh) {
                if (state is CartSuccess) {
                  _refreshController.refreshCompleted();
                } else if (state is CartError) {
                  _refreshController.refreshFailed();
                }
              }
            });
            bloc.add(CartStarted(AuthRepository.authChangeNotifier.value,
                isRefrshing: false));
            return bloc;
          },
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is CartError) {
                return Center(
                  child: Text(state.exception.message),
                );
              } else if (state is CartSuccess) {
                return SmartRefresher(
                  controller: _refreshController,
                  header: const ClassicHeader(
                    completeText: "با موفقیت انجام شد",
                    refreshingText: 'در حال  به روز رسانی',
                    idleText: 'برای به روز رسانی پایین بکشید',
                    releaseText: 'رها کنید',
                    failedText: 'خطای نامشخص',
                    spacing: 4,
                  ),
                  onRefresh: () {
                    cartBloc?.add(CartStarted(
                        AuthRepository.authChangeNotifier.value,
                        isRefrshing: true));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemBuilder: (context, index) {
                      if (index < state.cartResponse.cartItems.length) {
                        final data = state.cartResponse.cartItems[index];
                        return CartItem(
                          data: data,
                          onDeleteButtonClick: () {
                            cartBloc?.add(CartDeleteButtonClicked(data.id));
                          },
                          onDecreasButtomClick: () {
                            if (data.count > 1) {
                              cartBloc?.add(DecreasButtomClicked(data.id));
                            }
                          },
                          onIncreasButtomClick: () {
                            cartBloc?.add(IncreasButtomClicked(data.id));
                          },
                        );
                      } else {
                        return PriceInfo(
                          payablePrice: state.cartResponse.payablePrice,
                          shippingCost: state.cartResponse.shippingCost,
                          totalPrice: state.cartResponse.totalPrice,
                        );
                      }
                    },
                    itemCount: state.cartResponse.cartItems.length + 1,
                  ),
                );
              } else if (state is CartAuthRequired) {
                return EmptyView(
                    message:
                        'برای مشاهده ی سبد خرید ابتدا وارد حساب کاربری خود شوید',
                    callToAction: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AuthScreen()));
                        },
                        child: const Text('ورود به حساب کاربری')),
                    image: SvgPicture.asset(
                      'assets/img/auth_required.svg',
                      width: 140,
                    ));
              } else if (state is CartEmpty) {
                return EmptyView(
                    message:
                        'تاکنون هیچ محصولی به سبد خرید خود اضافه نکرده اید',
                    image: SvgPicture.asset(
                      'assets/img/empty_cart.svg',
                      width: 200,
                    ));
              } else {
                throw Exception('current cart state is not valid');
              }
            },
          ),
        )

        // ValueListenableBuilder<AuthInfo?>(
        //   valueListenable: AuthRepository.authChangeNotifier,
        //   builder: (context, authState, child) {
        //     bool isAuthenticated =
        //         authState != null && authState.accessToken.isNotEmpty;
        //     return SizedBox(
        //       width: MediaQuery.of(context).size.width,
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           Text(isAuthenticated
        //               ? 'خوش آمدید'
        //               : 'لطفا وارد حساب کاربری خود شوید'),
        //           isAuthenticated
        //               ? ElevatedButton(
        //                   onPressed: () {
        //                     authRepository.signOut();
        //                   },
        //                   child: const Text('خروج از حساب'))
        //               : ElevatedButton(
        //                   onPressed: () {
        //                     Navigator.of(context, rootNavigator: true).push(
        //                         MaterialPageRoute(
        //                             builder: (context) => const AuthScreen()));
        //                   },
        //                   child: const Text('ورود')),
        //           ElevatedButton(
        //               onPressed: () async {
        //                 await authRepository.refreshToken();
        //               },
        //               child: const Text('Refresh Token')),
        //         ],
        //       ),
        //     );
        //   },
        // ),
        );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/auth_info.dart';
import 'package:flutter_application_1/ui/auth/auth.dart';
import 'package:flutter_application_1/ui/order/order_history_screen.dart';

import '../../data/repo/auth_repository.dart';
import '../../data/repo/cart_repository.dart';
import '../favorite/favorite_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('پروفایل'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<AuthInfo?>(
          valueListenable: AuthRepository.authChangeNotifier,
          builder: (context, authInfo, child) {
            final isLogin = authInfo != null && authInfo.accessToken.isNotEmpty;
            return Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(top: 32, bottom: 8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Theme.of(context).dividerColor, width: 1)),
                      child: Image.asset('assets/img/nike_logo.png'),
                    ),
                    Text(isLogin ? 'hanieyzahraee@gmail.com' : "کاربر مهمان"),
                    const SizedBox(
                      height: 32,
                    ),
                    const Divider(
                      height: 1,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) =>
                                const FavoriteListScreen())));
                      },
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: const Row(
                          children: [
                            Icon(CupertinoIcons.heart),
                            SizedBox(
                              width: 16,
                            ),
                            Text('لیست علاقه مندی ها'),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) =>
                                const OrderHistoryScreen())));
                      },
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: const Row(
                          children: [
                            Icon(CupertinoIcons.cart),
                            SizedBox(
                              width: 16,
                            ),
                            Text('سوابق سفارش'),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    InkWell(
                      onTap: () {
                        if (isLogin) {
                          showDialog(
                              context: context,
                              useRootNavigator: false,
                              builder: (context) {
                                return Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: AlertDialog(
                                    title: const Text('خروج از حساب کاربربی'),
                                    content: const Text(
                                        'ابا میخواهید از حساب کاربری خود خارج شوید؟'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('خیر')),
                                      TextButton(
                                          onPressed: () {
                                            CartRepository.cartItemCountNotifier
                                                .value = 0;
                                            authRepository.signOut();
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('بله')),
                                    ],
                                  ),
                                );
                              });
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AuthScreen()));
                        }
                      },
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Row(
                          children: [
                            Icon(isLogin
                                ? CupertinoIcons.arrow_right_square
                                : CupertinoIcons.arrow_left_square),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(isLogin
                                ? ' خروج از حساب کاربری'
                                : "ورود به حساب کاربری"),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                    ),
                  ]),
            );
          }),
    );
  }
}

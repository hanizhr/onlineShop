import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/utils.dart';
import 'package:flutter_application_1/data/favorite_manager.dart';
import 'package:flutter_application_1/data/product.dart';
import 'package:flutter_application_1/theme.dart';
import 'package:flutter_application_1/ui/product/details.dart';
import 'package:flutter_application_1/ui/widgets/image.dart';
import 'package:hive/hive.dart';

class FavoriteListScreen extends StatelessWidget {
  const FavoriteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('لیست علاقه مندی ها'),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<ProductEntity>>(
            valueListenable: favoriteManager.listenable,
            builder: (context, box, child) {
              final products = box.values.toList();
              return ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 100),
                itemCount: products.length,
                itemBuilder: ((context, index) {
                  final product = products[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(product: product)));
                    },
                    onLongPress: () {
                      favoriteManager.delete(product);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 110,
                            height: 110,
                            child: ImageLoadingService(
                              imageUrl: product.imageUrl,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          color:
                                              LightThemeColors.primaryTextColor,
                                        ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    product.previousPrice.withPriceLabel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                            decoration:
                                                TextDecoration.lineThrough),
                                  ),
                                  Text(product.price.withPriceLabel)
                                ]),
                          ))
                        ],
                      ),
                    ),
                  );
                }),
              );
            }));
  }
}

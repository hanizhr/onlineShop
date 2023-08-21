import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/utils.dart';
import 'package:flutter_application_1/data/product.dart';
import 'package:flutter_application_1/data/repo/product_repository.dart';
import 'package:flutter_application_1/ui/list/bloc/product_list_bloc.dart';
import 'package:flutter_application_1/ui/product/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListScreen extends StatefulWidget {
  final int sort;

  const ProductListScreen({super.key, required this.sort});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

enum ViewTypw { grid, list }

class _ProductListScreenState extends State<ProductListScreen> {
  ProductListBloc? bloc;
  ViewTypw viewTypw = ViewTypw.grid;
  @override
  void dispose() {
    bloc!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('کفش های ورزشی'),
        centerTitle: true,
      ),
      body: BlocProvider<ProductListBloc>(
        create: (context) {
          bloc = ProductListBloc(productRepository)
            ..add(ProductListStarted(widget.sort));
          return bloc!;
        },
        child: BlocBuilder<ProductListBloc, ProductListState>(
          builder: (context, state) {
            if (state is ProductListSuccess) {
              final products = state.products;
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              color: Theme.of(context).dividerColor, width: 1),
                        ),
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20)
                        ]),
                    height: 56,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(32))),
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 300,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 24, bottom: 24),
                                  child: Column(children: [
                                    Text(
                                      'انتخاب مرتب سازی',
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                          itemCount: state.sortName.length,
                                          itemBuilder: ((context, index) {
                                            final selectedSortIndex =
                                                state.sort;
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      16, 8, 16, 8),
                                              child: SizedBox(
                                                height: 32,
                                                child: InkWell(
                                                  onTap: () {
                                                    bloc!.add(
                                                        ProductListStarted(
                                                            index));
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(state
                                                          .sortName[index]),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      if (selectedSortIndex ==
                                                          index)
                                                        Icon(
                                                          CupertinoIcons
                                                              .check_mark,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          })),
                                    )
                                  ]),
                                ),
                              );
                            });
                      },
                      child: Row(children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(CupertinoIcons.sort_down),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('مرتب سازی'),
                                    Text(
                                      ProductSort.names[state.sort],
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                viewTypw = viewTypw == ViewTypw.grid
                                    ? ViewTypw.list
                                    : ViewTypw.grid;
                              });
                            },
                            icon: const Icon(CupertinoIcons.square_grid_2x2),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                        itemCount: products.length,
                        physics: defaultScrollPhysics,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: viewTypw == ViewTypw.grid ? 2 : 1,
                            childAspectRatio: 0.65),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductItem(
                              product: product,
                              borderRadius: BorderRadius.zero);
                        }),
                  ),
                ],
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

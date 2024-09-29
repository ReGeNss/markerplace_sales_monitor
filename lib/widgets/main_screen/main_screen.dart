import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markerplace_sales_monitor/repositores/data_handler.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/bloc/bloc_events.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/bloc/bloc_state.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/bloc/main_screen_view_bloc.dart';

final Decoration selectedElement = BoxDecoration(
  borderRadius: BorderRadius.circular(20),
  color: const Color.fromRGBO(106, 96, 96, 0.9),
);
const TextStyle defaultTextStyleOfMarkets =
    TextStyle(color: Colors.black, fontSize: 12);
const TextStyle defaultTextStyleOfSaleFilters =
    TextStyle(color: Colors.black, fontSize: 15);
const TextStyle productCardTextStyle =
    TextStyle(color: Colors.white, fontSize: 15);
const Color defaultColor = Color.fromRGBO(217, 217, 217, 1);
BoxDecoration defaultDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(20),
  color: defaultColor,
);
ButtonStyle buttonStyle = ButtonStyle(
  overlayColor: const WidgetStatePropertyAll<Color>(
    Color.fromRGBO(106, 96, 96, 0.5),
  ),
  fixedSize: const WidgetStatePropertyAll<Size>(
    Size.fromHeight(55),
  ),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
);

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => MainScreenBloc(),
      child: Scaffold(
        body: CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: defaultDecoration,
              margin: const EdgeInsets.only(top: 25, left: 20, right: 20),
              height: 200,
              child: const Center(
                child: Text(
                  'Найбільш губні знижки саме тут!',
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SliverAppBar(
            surfaceTintColor: Colors.transparent,
            toolbarHeight: 0,
            snap: true,
            primary: false,
            pinned: true,
            floating: true,
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(250),
                child: Padding(
                    padding: EdgeInsets.only(bottom: 0, left: 20, right: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        FiltersWidget(),
                        SizedBox(
                          height: 10,
                        ),
                        MarketplaceSelectorWidget(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ))),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverListOfProductsWidget(),
          )
        ]),
      ),
    );
  }
}

class SliverListOfProductsWidget extends StatelessWidget {
  const SliverListOfProductsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MainScreenBloc>(context);
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        print('rebuilding list of products');
        if (state is LoadingData) {
          return const SliverToBoxAdapter(
            // child: SizedBox(height: 100, width: 100,child: CircularProgressIndicator()),
            child: Center(child: Text('Накачування ваших губ ботоксом...')),
          );
        }
        return SliverList.builder(
          itemCount: bloc.countOfProducts,
          itemBuilder: (context, index) {
            return Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromRGBO(106, 96, 96, 1),
              ),
              margin: const EdgeInsets.only(bottom: 10),
              child: ProductCardWidget(productCard: bloc.productList[index]),
            );
          },
        );
      },
    );
  }
}

class ProductCardWidget extends StatelessWidget {
  final ProductCard productCard;
  const ProductCardWidget({
    super.key,
    required this.productCard,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MainScreenBloc>(context);
    return Row(
      children: [
        Column(
          children: [
            bloc.getCurrentMarketplace(productCard.title) != null
                ? Padding(
                  padding: const EdgeInsets.only(top:5.0),
                  child: Text(
                      bloc.getCurrentMarketplace(productCard.title)!,
                      style: productCardTextStyle,
                    ),
                )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.network(
                productCard.imgSrc,
                width: 120,
                height: 120,
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 135,
              child: Text(
                productCard.title,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: productCardTextStyle,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text('Ціна: ${productCard.currentPrice}',
                style: productCardTextStyle),
            const SizedBox(
              height: 10,
            ),
            productCard.percentOfSale != null
                ? Text('% знижки: ${productCard.percentOfSale}',
                    style: productCardTextStyle)
                : const SizedBox(),
            const SizedBox(
              height: 10,
            ),
            productCard.oldPrice != null
                ? Text('Минула ціна: ${productCard.oldPrice}',
                    style: productCardTextStyle)
                : const SizedBox(),
          ],
        ),
      ],
    );
  }
}

class MarketplaceSelectorWidget extends StatelessWidget {
  const MarketplaceSelectorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MainScreenBloc>(context);
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        if (state is LoadingData) {
          return const SizedBox(height: 55, child: CircularProgressIndicator());
        }
        return Row(
          children: [
            BlocBuilder<MainScreenBloc, MainScreenState>(
              builder: (context, state) {
                return Container(
                  decoration: bloc.selectedMarketplace == null
                      ? selectedElement
                      : defaultDecoration,
                  margin: const EdgeInsets.only(right: 10),
                  child: TextButton(
                      onPressed: () {
                        bloc.add(const AllCategoryButtonTapEvent());
                      },
                      style: buttonStyle,
                      child: const Text(
                        'Всі',
                        style: defaultTextStyleOfMarkets,
                      )),
                );
              },
            ),
            Expanded(
              child: SizedBox(
                height: 55,
                child: BlocBuilder<MainScreenBloc, MainScreenState>(
                  builder: (context, state) {
                    print('rebuilding');
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: bloc.countOfCategories,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: bloc.selectedMarketplace == index
                              ? selectedElement
                              : defaultDecoration,
                          margin: const EdgeInsets.only(right: 10),
                          child: TextButton(
                              onPressed: () {
                                bloc.add(
                                    MarketplaceSelectButtonTapEvent(index));
                              },
                              style: buttonStyle,
                              child: Text(
                                bloc.categoryList[index],
                                style: defaultTextStyleOfMarkets,
                              )),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class FiltersWidget extends StatelessWidget {
  const FiltersWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MainScreenBloc>(context);
    return Container(
      height: 115,
      decoration: defaultDecoration,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: BlocBuilder<MainScreenBloc, MainScreenState>(
                  // buildWhen: (previous, current) =>
                  //     current is BiggestSaleCategorySelected &&
                  //     previous is! BiggestSaleCategorySelected,
                  builder: (context, state) {
                    return Container(
                      decoration: state is BiggestSaleCategorySelected
                          ? selectedElement
                          : null,
                      child: TextButton(
                          onPressed: () {
                            bloc.add(const BiggestSaleCategoryButtonTapEvent());
                          },
                          style: buttonStyle,
                          child: const Text(
                            'Найбільша вигода',
                            style: defaultTextStyleOfSaleFilters,
                            textAlign: TextAlign.center,
                          )),
                    );
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<MainScreenBloc, MainScreenState>(
                  builder: (context, state) {
                    return Container(
                      decoration: state is SmallestPriceCategorySelected
                          ? selectedElement
                          : null,
                      child: TextButton(
                          onPressed: () {
                            bloc.add(
                                const SmallestPriceCategoryButtonTapEvent());
                          },
                          style: buttonStyle,
                          child: const Text('Найдешевші',
                              style: defaultTextStyleOfSaleFilters)),
                    );
                  },
                ),
              ),
              // Expanded(
              //     child: Container(
              //   child: TextButton(
              //       onPressed: () {
              //         bloc.add(const LipsPriceCategoryButtonTapEvent());
              //       },
              //       style: buttonStyle,
              //       child: const Text('Губи',
              //           style: defaultTextStyleOfSaleFilters)),
              // )),
            ],
          ),
          const Divider(
            height: 1,
            color: Colors.black,
          ),
          TextButton(
              onPressed: () {
                bloc.add(const FilterButtonTapEvent());
              },
              style: buttonStyle,
              child: const Text(
                'Фільтр',
                style: TextStyle(
                    color: Colors.black, letterSpacing: 25, fontSize: 22),
              ))
        ],
      ),
    );
  }
}

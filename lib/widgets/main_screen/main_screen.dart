import 'dart:async';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
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
    TextStyle(color: Colors.black, fontSize: 15);
const TextStyle defaultTextStyleOfSaleFilters =
    TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500);
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



ButtonStyle bigFilterButtonStyle = const ButtonStyle(
  overlayColor:  WidgetStatePropertyAll<Color>(
    Color.fromRGBO(106, 96, 96, 0.5),
  ),
  fixedSize:  WidgetStatePropertyAll<Size>(
    Size(2000,60),
  ),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
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
          SliverAppBar(
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
            toolbarHeight: 0,
            snap: true,
            primary: false,
            pinned: true,
            floating: true,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(290),
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 0, left: 20, right: 20),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        const SearchTextFieldWidget(),
                        const SizedBox(height: 10,),
                        _FiltersWidget(),
                        const SizedBox(
                          height: 10,
                        ),
                        const MarketplaceSelectorWidget(),
                        const SizedBox(
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

class SearchTextFieldWidget extends StatelessWidget {
  const SearchTextFieldWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MainScreenBloc>(context); 
    Timer? timer;
    final textFieldFocus = FocusNode(); 
    return TextField(
      focusNode: textFieldFocus,
      decoration: InputDecoration(
        filled: true,
        fillColor: defaultColor,
        hintText: 'Пошук',
        prefixIcon: const Icon(Icons.search),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            width: 2,
            color: Color.fromRGBO(106, 96, 96, 1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            width: 2,
            color: defaultColor,
          ),
        ),
      ),
      onChanged: (value) {
        if(timer !=null){
          if(timer!.isActive) {timer!.cancel();}
        }
        timer = Timer(const Duration(milliseconds: 400), () => bloc.add(SearchTextFieldChangedEvent(value))); 
      },
      onEditingComplete: () {
        textFieldFocus.unfocus();
      },
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
        // print('rebuilding list of products');
        if (state is LoadingData) {
          return const SliverToBoxAdapter(
            // child: SizedBox(height: 100, width: 100,child: CircularProgressIndicator()),
            child: Center(child: Text('Накачування ваших губ ботоксом...', style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,)),
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
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:5.0),
                child: bloc.getCurrentMarketplace(productCard.title) != null
                    ? Text(
                        bloc.getCurrentMarketplace(productCard.title)!,
                        style: const TextStyle(color: Colors.white, fontSize: 17),
                      )
                    : const SizedBox(height: 21),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.network(
                  productCard.imgSrc,
                  width: 120,
                  height: 120,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const SizedBox(
                        width: 120,
                        height: 120,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    width: 120,
                    height: 120,
                    child: Center(
                      child: Text('Зображення відсутнє',style: productCardTextStyle,textAlign: TextAlign.center,),
                    ),
                ),
              ),
              )
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  child: Text(
                    productCard.title,
                    maxLines: 3,
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
                    ? SizedBox(
                      width: 135,
                      child: Text('Минула ціна: ${productCard.oldPrice}',maxLines: 2,overflow: TextOverflow.ellipsis,
                          style: productCardTextStyle),
                    )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
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
          return const SizedBox(
            width: 55,
            height: 55,
            child: Center(child: CircularProgressIndicator()));
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
                    // print('rebuilding');
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
                                bloc.marketsList[index],
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


class _FiltersWidget extends StatefulWidget {
  _FiltersWidget({super.key});

  @override
  State<_FiltersWidget> createState() => _FiltersWidgetState();
}

class _FiltersWidgetState extends State<_FiltersWidget> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MainScreenBloc>(context);
    return Container(
      height: 121,
      decoration: defaultDecoration,
      child: Column(
        children: [
          Expanded(
            child: AnimatedToggleSwitch<int>.size(
              fittingMode: FittingMode.none,
              textDirection: TextDirection.ltr,
              // height: 121,
              values: const [0,1],
              indicatorSize: const Size(double.infinity,double.infinity),
              current: value,
              iconOpacity: 1,
              borderWidth: 0,
              selectedIconScale: 1,
              style: const ToggleStyle(
                borderColor:  Colors.transparent,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                backgroundColor: Color.fromRGBO(217, 217, 217, 1),
                indicatorColor: Color.fromRGBO(106, 96, 96, 1), 
              ),
              styleBuilder: (i) {
                if(i == 0){
                  return const ToggleStyle(
                indicatorBorderRadius: BorderRadius.only(topLeft: Radius.circular(20)));
                }
                return const ToggleStyle(
                indicatorBorderRadius: BorderRadius.only(topRight: Radius.circular(20)));
              },
              onChanged: (i) {
                value = i;
                if (i == 0) {
                  bloc.add(const BiggestSaleCategoryButtonTapEvent());
                } else {
                  bloc.add(const SmallestPriceCategoryButtonTapEvent());
                }
                setState(() {});
              },
              iconBuilder: (i) {
                if( i == 0){
                  return const Text('Найбільша вигода',style: defaultTextStyleOfSaleFilters,textAlign: TextAlign.center);
                }
                return const Text('Найдешевші',style: defaultTextStyleOfSaleFilters,textAlign: TextAlign.center,);
              },
            
            ),
          ),
          const Divider(
              height: 1,
              color: Colors.black,
            ),
          TextButton(
                onPressed: () {
                  bloc.add(const FilterButtonTapEvent());
                },
                style: bigFilterButtonStyle,
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

// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markerplace_sales_monitor/entities.dart';
import 'package:markerplace_sales_monitor/main_app.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/category_bloc/category_events.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/category_bloc/category_state.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/category_bloc/category_view_bloc.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/page_switcher_bloc/page_switcher_bloc.dart';
import 'package:markerplace_sales_monitor/widgets/main_screen/theme_bloc/theme_bloc.dart';

const TextStyle defaultTextStyleOfMarkets =
    TextStyle(color: Colors.black, fontSize: 16);

const TextStyle defaultTextStyleOfSaleFilters =
    TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500);

const TextStyle productCardTextStyle =
    TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500);

Decoration defaultDecoration(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: context.color.cardTextColor,
  );
}

Decoration selectedElementDecoration(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: context.color.selectedWidgetsColor, 
  );
}

ButtonStyle marketplacesButtonStyle(BuildContext context) {

  return ButtonStyle(
    overlayColor: WidgetStateProperty.all(
      context.color.unSelectedWidgetsColor,
    ),
    fixedSize: WidgetStateProperty.all(
      const Size.fromHeight(55),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}

ButtonStyle filterButtonDisableStyle(BuildContext context) {

  return ButtonStyle(
    overlayColor: WidgetStateProperty.all(
      context.color.cardTextColor, 
    ),
    fixedSize: WidgetStateProperty.all(
      const Size(2000, 60),
    ),
    shape: WidgetStateProperty.all(
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    ),
  );
}

ButtonStyle filterButtonActiveStyle(BuildContext context) {
  return ButtonStyle(
    overlayColor: WidgetStateProperty.all(
      context.color.selectedWidgetsColor, 
    ),
    backgroundColor: WidgetStateProperty.all(
      context.color.selectedWidgetsColor,
    ),
    fixedSize: WidgetStateProperty.all(
      const Size(2000, 60),
    ),
    shape: WidgetStateProperty.all(
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    ),
  );
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PageSwitcherBloc(),
      child: Scaffold(
        backgroundColor: context.color.backgroundClolor,
        body: MainScreenBody(),
      ),
    );
  }
}

class MainScreenBody extends StatelessWidget {
  const MainScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<PageSwitcherBloc>();
    if (bloc.state is CatigoriesLoading) {
      return Center(child: CircularProgressIndicatorWidget());
    }
    if (bloc.state is Error) {
      return Center(
        child: Text(
          (bloc.state as Error).error,
          style: defaultTextStyleOfSaleFilters.copyWith(
            color: context.color.textColor,
          ),
        ),
      );
    }
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: bloc.controller,
            children: bloc.catigories
                .map(
                  (category) => CategoryScreenWidget(category: category),
                )
                .toList(),
          ),
        ),
        Divider(
          height: 2,
          thickness: 2,
          color: context.color.unSelectedWidgetsColor,
        ),
        NavigationBarWidget(),
      ],
    );
  }
}

class NavigationBarWidget extends StatelessWidget {
  const NavigationBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<PageSwitcherBloc>();
    return BottomNavigationBar(
      selectedLabelStyle: defaultTextStyleOfSaleFilters.copyWith(
        color: context.color.textColor,
      ),
      unselectedLabelStyle: defaultTextStyleOfMarkets.copyWith(
        color: context.color.textColor,
      ),
      showUnselectedLabels: true,
      iconSize: 28,
      selectedFontSize: 16,
      unselectedFontSize: 14,
      currentIndex: bloc.currentCatigoryIndex,
      useLegacyColorScheme: false,
      unselectedItemColor: context.color.textColor,
      selectedItemColor: context.color.textColor,
      items: List.generate(
        bloc.catigories.length,
        (index) => BottomNavigationBarItem(
          icon: Icon(
            IconData(
              int.parse(bloc.catigories[index].iconName),
              fontFamily: 'MaterialIcons',
            ),
          ),
          backgroundColor: context.color.selectedWidgetsColor,
          label: bloc.catigories.elementAt(index).name,
        ),
      ),
      onTap: (index) {
        bloc.controller.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      },
    );
  }
}

class CategoryScreenWidget extends StatelessWidget {
  const CategoryScreenWidget({
    super.key,
    required this.category,
  });
  final Category category;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PageSwitcherBloc>(context);
    return BlocProvider.value(
      value: bloc.mainScreenBlocs
          .firstWhere((bloc) => bloc.category == category.apiRoute),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: defaultDecoration(context),
              margin: const EdgeInsets.only(top: 25, left: 20, right: 20),
              height: 200,
              child: Center(
                child: Text(
                  category.name,
                  style: TextStyle(
                      fontSize: 35,
                      color: context.color.textColor,
                      letterSpacing: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SliverAppBar(
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
            backgroundColor: context.color.backgroundClolor,
            toolbarHeight: 0,
            snap: true,
            primary: false,
            pinned: true,
            floating: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(290),
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    SearchTextFieldWidget(),
                    SizedBox(
                      height: 10,
                    ),
                    _FiltersWidget(),
                    SizedBox(
                      height: 10,
                    ),
                    MarketplaceSelectorWidget(),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverListOfProductsWidget(),
          ),
        ],
      ),
    );
  }
}

class SearchTextFieldWidget extends StatelessWidget {
  SearchTextFieldWidget({
    super.key,
  });
  final textFieldFocus = FocusNode(); 

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MainScreenBloc>(context);
    Timer? timer;
    final themeBloc = context.read<ThemeBloc>();
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: TextEditingController(text: bloc.searchQuery),
            focusNode: textFieldFocus,
            decoration: InputDecoration(
              filled: true,
              fillColor: context.color.cardTextColor,
              hintText: 'Пошук',
              hintStyle: TextStyle(
                color: context.color.textColor,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: context.color.textColor,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  width: 2,
                  color: context.color.selectedWidgetsColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
              ),
            ),
            onChanged: (value) {
              if (timer != null) {
                if (timer!.isActive) {
                  timer!.cancel();
                }
              }
              timer = Timer(
                const Duration(milliseconds: 400),
                () => bloc.add(SearchTextFieldChangedEvent(value)),
              );
            },
            onEditingComplete: () {
              // textFieldFocus.unfocus();
            },
          ),
        ),
        IconButton(
          onPressed: () {
            themeBloc.changeTheme();
          },
          icon: themeBloc.state is LightTheme
              ? const Icon(Icons.nightlight_outlined)
              : const Icon(Icons.wb_sunny_outlined),
          color: context.color.textColor,
        ),
      ],
    );
  }
}

class SliverListOfProductsWidget extends StatelessWidget {
  const SliverListOfProductsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<MainScreenBloc>();
    if (bloc.state is LoadingDataExeption) {
      return SliverToBoxAdapter(
        child: Center(
          child: Text(
            (bloc.state as LoadingDataExeption).message,
            style: TextStyle(
              fontSize: 27,
              color: context.color.textColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        if (state is InDataLoad) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(
                'Завантаження...',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: context.color.textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return SliverList.builder(
          itemCount: bloc.countOfProducts,
          itemBuilder: (context, index) {
            return Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: context.color.selectedWidgetsColor,
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
  const ProductCardWidget({
    super.key,
    required this.productCard,
  });

  final ProductCard productCard;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MainScreenBloc>(context);
    // print(productCard.title.toString());
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: bloc.selectedMarketplace == null
                    ? Text(
                        productCard.marketplace,
                        style: productCardTextStyle,
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
                      child: Text(
                        'Зображення відсутнє',
                        style: productCardTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Text(
                    productCard.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: productCardTextStyle,
                  ),
                ),
                Text(
                  'Ціна: ${productCard.currentPrice} грн',
                  style: productCardTextStyle,
                ),
                productCard.percentOfSale != null
                    ? Text(
                      'Відсоток знижки: ${productCard.percentOfSale}',
                      style: productCardTextStyle,
                    )
                    : const SizedBox(),
                productCard.oldPrice != null
                    ? SizedBox(
                        width: 135,
                        child: Text(
                          'Минула ціна: ${productCard.oldPrice}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: productCardTextStyle,
                        ),
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

const screenPaddingsSize = 20;
const allButtonSize = 64;
const buttonsSpacing = 10;

double calcButtonsWidth(int countOfCategories, double screenWidth) {
  final result = (screenWidth -
          allButtonSize -
          buttonsSpacing -
          screenPaddingsSize * 2 -
          (countOfCategories - 1) * buttonsSpacing) /
      countOfCategories;
  if (result < 80) {
    return 80;
  }
  return result;
}

class MarketplaceSelectorWidget extends StatelessWidget {
  const MarketplaceSelectorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<MainScreenBloc>();
    if (bloc.state is LoadingDataExeption) {
      return const SizedBox(height: 50,width: 50,);
    }
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        if (state is InDataLoad) {
          return CircularProgressIndicatorWidget();
        }
        final screenWidth = MediaQuery.of(context).size.width;
        final itemWidth = calcButtonsWidth(bloc.countOfCategories, screenWidth);
        return Row(
          children: [
            Container(
              width: 64,
              decoration: bloc.selectedMarketplace == null
                  ? selectedElementDecoration(context)
                  : defaultDecoration(context),
              margin: EdgeInsets.only(right: buttonsSpacing.toDouble()),
              child: TextButton(
                onPressed: () {
                  // context.read<ThemeBloc>().add(ThemeChanged());
                  bloc.add(const AllCategoryButtonTapEvent());
                },
                style: marketplacesButtonStyle(context),
                child: Text(
                  'Всі',
                  style: defaultTextStyleOfMarkets.copyWith(
                    color: context.color.textColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 55,
                child: BlocBuilder<MainScreenBloc, MainScreenState>(
                  builder: (context, state) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: bloc.countOfCategories,
                      itemBuilder: (context, index) {
   
                        return Container(
                          width: itemWidth,
                          decoration: bloc.selectedMarketplace == index
                              ? selectedElementDecoration(context)
                              : defaultDecoration(context),
                          margin: const EdgeInsets.only(right: 10),
                          child: TextButton(
                            onPressed: () {
                              bloc.add(
                                MarketplaceSelectButtonTapEvent(index),
                              );
                            },
                            style: marketplacesButtonStyle(context),
                            child: Text(
                              bloc.marketsList[index],
                              style: defaultTextStyleOfMarkets.copyWith(
                                color: context.color.textColor,
                              ),
                            ),
                          ),
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

class CircularProgressIndicatorWidget extends StatelessWidget {
  const CircularProgressIndicatorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 55,
      height: 55,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _FiltersWidget extends StatelessWidget {
  const _FiltersWidget();

  @override
  Widget build(BuildContext context) {
    int value;
    // final bloc = BlocProvider.of<MainScreenBloc>(context);
    final bloc = context.watch<MainScreenBloc>();
    if (bloc.state is SmallestPriceCategorySelected) {
      value = 1;
    } else {
      value = 0;
    }
    return Container(
      height: 121,
      decoration: defaultDecoration(context),
      child: Column(
        children: [
          Expanded(
            child: AnimatedToggleSwitch<int>.size(
              fittingMode: FittingMode.none,
              textDirection: TextDirection.ltr,
              values: const [0, 1],
              indicatorSize: Size.infinite,
              current: value,
              iconOpacity: 1,
              borderWidth: 0,
              selectedIconScale: 1,
              style: ToggleStyle(
                borderColor: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                backgroundColor: context.color.cardTextColor,
                indicatorColor: context.color.selectedWidgetsColor,
              ),
              styleBuilder: (i) {
                if (i == 0) {
                  return const ToggleStyle(
                    indicatorBorderRadius:
                        BorderRadius.only(topLeft: Radius.circular(20)),
                  );
                }
                return const ToggleStyle(
                  indicatorBorderRadius:
                      BorderRadius.only(topRight: Radius.circular(20)),
                );
              },
              onChanged: (i) {
                if (i == 0) {
                  bloc.add(const BiggestSaleCategoryButtonTapEvent());
                } else {
                  bloc.add(const SmallestPriceCategoryButtonTapEvent());
                }
              },
              iconBuilder: (i) {
                if (i == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Найбільша вигода',
                      style: defaultTextStyleOfSaleFilters.copyWith(
                        color: context.color.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return Text(
                  'Найдешевші',
                  style: defaultTextStyleOfSaleFilters.copyWith(
                      color: context.color.textColor,
                    ),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ),
          const Divider(
            height: 1,
            color: Colors.black,
          ),
          TextButton(
            onPressed: () {
              final mainScreenContext = context;
              showDialog(
                useRootNavigator: false,
                context: context,
                builder: (context) {
                  return FiltersDialogWidget(
                    mainScreenContext: mainScreenContext,
                  );
                },
              );
            },
            style: filterButtonStyleSelector(bloc.isBrandFilersActive, context),
            child: Text(
              'Фільтр брендів',
              style: TextStyle(
                color: context.color.textColor,
                letterSpacing: 10,
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

ButtonStyle filterButtonStyleSelector(bool isActive, BuildContext context) {
  if (isActive) {
    return filterButtonActiveStyle(context);
  }
  return filterButtonDisableStyle(context);
}

class FiltersDialogWidget extends StatelessWidget {
  const FiltersDialogWidget({
    required this.mainScreenContext,
    super.key,
  });

  final BuildContext mainScreenContext;

  @override
  Widget build(BuildContext context) {
    final brands =
        BlocProvider.of<MainScreenBloc>(mainScreenContext).getBrands();
    return Dialog(
      backgroundColor: context.color.backgroundClolor,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: 400,
            width: 200,
            child: Center(
              child: ListView.separated(
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  return DialogBrandListTitleWidget(
                    brands: brands,
                    index: index,
                    mainScreenContext: mainScreenContext,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DialogBrandListTitleWidget extends StatelessWidget {
  const DialogBrandListTitleWidget({
    super.key,
    required this.brands,
    required this.mainScreenContext,
    required this.index,
  });

  final int index;
  final BuildContext mainScreenContext;
  final List<Brand> brands;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, state) {
        return ListTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          tileColor: context.color.unSelectedWidgetsColor,
          selectedTileColor: context.color.selectedWidgetsColor,
          selected: brands[index].isSelected,
          title: Text(
            brands[index].name,
            style: defaultTextStyleOfSaleFilters.copyWith(
              color: context.color.textColor,
            ),
          ),
          trailing: Checkbox(
            value: brands[index].isSelected,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            checkColor: context.color.backgroundClolor,
            activeColor: context.color.textColor,
            onChanged: (value) {
              brands[index].isSelected = value!;
              mainScreenContext
                  .read<MainScreenBloc>()
                  .add(const FilterButtonTapEvent());
              state(
                () {},
              );
            },
          ),
          onTap: () => () {
            brands[index].isSelected = !brands[index].isSelected;
            mainScreenContext
                .read<MainScreenBloc>()
                .add(const FilterButtonTapEvent());
            state(
              () {},
            );
          },
        );
      },
    );
  }
}

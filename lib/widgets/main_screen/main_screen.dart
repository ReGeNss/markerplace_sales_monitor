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
const Color brown = Color.fromRGBO(106, 96, 96, 1); 
const Color lightBrown = Color.fromRGBO(106, 96, 96, 0.5);
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



ButtonStyle bigFilterButtonDisableStyle = const ButtonStyle(
  overlayColor: WidgetStatePropertyAll<Color>(
    Color.fromRGBO(217, 217, 217, 1),
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

ButtonStyle bigFilterButtonActiveStyle = const ButtonStyle(
  overlayColor: WidgetStatePropertyAll<Color>(
    brown,
  ),
  backgroundColor: WidgetStatePropertyAll<Color>(
    brown,
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
                  'Всі знижки саме тут!',
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SliverAppBar(
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
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
                        SizedBox(height: 10,),
                        _FiltersWidget(),
                        SizedBox(
                          height: 10,
                        ),
                        MarketplaceSelectorWidget(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),),),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverListOfProductsWidget(),
          ),
        ],),
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
          if(timer!.isActive) {
            timer!.cancel();
          }
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
        if (state is LoadingData) {
          return const SliverToBoxAdapter(
            child: Center(child: Text('Завантаження...', style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,)),
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
  const ProductCardWidget({
    super.key,
    required this.productCard,
  });

  final ProductCard productCard;

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
                child: bloc.selectedMarketplace == null
                    ? Text(
                        productCard.marketplace,
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
              ),
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
                    style: productCardTextStyle,),
                const SizedBox(
                  height: 10,
                ),
                productCard.percentOfSale != null
                    ? Text('% знижки: ${productCard.percentOfSale}',
                        style: productCardTextStyle,)
                    : const SizedBox(),
                const SizedBox(
                  height: 10,
                ),
                productCard.oldPrice != null
                    ? SizedBox(
                      width: 135,
                      child: Text('Минула ціна: ${productCard.oldPrice}',maxLines: 2,overflow: TextOverflow.ellipsis,
                          style: productCardTextStyle,),
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
            child: Center(child: CircularProgressIndicator()),);
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
                      ),),
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
                                    MarketplaceSelectButtonTapEvent(index),);
                              },
                              style: buttonStyle,
                              child: Text(
                                bloc.marketsList[index],
                                style: defaultTextStyleOfMarkets,
                              ),),
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
  const _FiltersWidget();

  @override
  State<_FiltersWidget> createState() => _FiltersWidgetState();
}

class _FiltersWidgetState extends State<_FiltersWidget> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    // final bloc = BlocProvider.of<MainScreenBloc>(context);
    final bloc = context.watch<MainScreenBloc>();
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
                indicatorBorderRadius: BorderRadius.only(topLeft: Radius.circular(20)),);
                }
                return const ToggleStyle(
                indicatorBorderRadius: BorderRadius.only(topRight: Radius.circular(20)),);
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
                    final mainScreenContext = context;
                    // bloc.add(const FilterButtonTapEvent());
                    showDialog(useRootNavigator: false,context: context, builder: (context){
                      return FiltersDialogWidget(mainScreenContext: mainScreenContext);
                    },);
                  },
                  style: filterButtonStyleSelector(bloc.isBrandFilersActive),
                  child: const Text(
                    'Фільтр брендів',
                    style: TextStyle(
                        color: Colors.black, letterSpacing: 10, fontSize: 22,),
                  ),),
          
        ],
      ),
    );
  }
}

ButtonStyle filterButtonStyleSelector(bool isActive){
  if(isActive){
    return bigFilterButtonActiveStyle;
  }
  return bigFilterButtonDisableStyle;
}

class FiltersDialogWidget extends StatelessWidget { 
  const FiltersDialogWidget({
    required this.mainScreenContext,
    super.key,
  });

  final BuildContext mainScreenContext;

  @override
  Widget build(BuildContext context) {
    final brands = BlocProvider.of<MainScreenBloc>(mainScreenContext).getBrands();
    return Dialog(
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 400,
        width: 200,
        child: Center(child: 
          ListView.separated(
            itemCount: brands.length,
            itemBuilder: (context, index) {
              return DialogBrandListTitleWidget(brands: brands,index:index,mainScreenContext: mainScreenContext,);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10);
            },  
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
      builder: (context,state) {
        return ListTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          tileColor: lightBrown,
          selectedTileColor: brown,
          selected: brands[index].isSelected,
          title: Text(brands[index].name, style: defaultTextStyleOfSaleFilters,),
          trailing: Checkbox(
            value: brands[index].isSelected, 
            onChanged:(value){
              brands[index].isSelected = value!;
              mainScreenContext.read<MainScreenBloc>().add(const FilterButtonTapEvent());
              state(() {
                
              },);
            },
            ),
          onTap: () => (){
            brands[index].isSelected = !brands[index].isSelected;
            mainScreenContext.read<MainScreenBloc>().add(const FilterButtonTapEvent());
            state(() {},);},
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

const TextStyle defaultTextStyleOfMarkets =  TextStyle(color: Colors.black, fontSize: 12);
const TextStyle defaultTextStyleOfSaleFilters =  TextStyle(color: Colors.black, fontSize: 15);
const TextStyle productCardTextStyle =  TextStyle(color: Colors.white, fontSize: 15);
const Color defaultColor = Color.fromRGBO(217, 217, 217, 1); 
BoxDecoration defaultDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(20),
  color: defaultColor,
);
ButtonStyle buttonStyle = ButtonStyle(
  overlayColor: WidgetStatePropertyAll<Color>(Color.fromRGBO(106, 96, 96, 0.5),),
  fixedSize: WidgetStatePropertyAll<Size>(Size.fromHeight(55),),
  shape: WidgetStatePropertyAll( RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),),
);


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Container(
              decoration: defaultDecoration,
              margin: const EdgeInsets.only(top: 25, left: 20, right: 20),
              height: 200,
              child: const Center(
                child: Text('Найбільш губні знижки саме тут!',style: TextStyle(fontSize: 30),textAlign: TextAlign.center, ),
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
                    ],
                  ))),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverListOfProductsWidget(),
        )
      ]),
    );
  }
}

class SliverListOfProductsWidget extends StatelessWidget {
  const SliverListOfProductsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(itemCount: 10, itemBuilder: (context, index) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromRGBO(106, 96, 96, 1),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: ProductCardWidget(),
      );
    },);
  }
}

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Placeholder(fallbackWidth: 120,),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15,),
            Text('Енергетик нонстоп',style: productCardTextStyle,),
            SizedBox(height: 10,),
            Text('Ціна:',style: productCardTextStyle),
            SizedBox(height: 10,),
            Text('% знижки:',style: productCardTextStyle),
            SizedBox(height: 10,),
            Text('Минула ціна:',style: productCardTextStyle),
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 70,
        child: Row(
          
          children: [
            Container(
              decoration: defaultDecoration,
                margin: const EdgeInsets.only(right: 10),
                child:
                    TextButton(onPressed: () {},style: buttonStyle, child:  Text('Вcі', style: defaultTextStyleOfMarkets))),
            Container(
              decoration: defaultDecoration,
              margin: const EdgeInsets.only(right: 5),
              child: TextButton(onPressed: () {},style: buttonStyle, child: Text('Фора', style: defaultTextStyleOfMarkets)),
            ),
            Container(
              decoration: defaultDecoration,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: TextButton(onPressed: () {},style: buttonStyle, child:  Text('Траш', style: defaultTextStyleOfMarkets)),
            ),
            Container(
              decoration: defaultDecoration,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: TextButton(
                  onPressed: () {},
                  child: Text('АТБ', style: defaultTextStyleOfMarkets),
                  style: buttonStyle)
            ),
            
            Container(
              decoration: defaultDecoration,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: TextButton(onPressed: () {},style: buttonStyle, child:  Text('Сільпо', style: defaultTextStyleOfMarkets)),
            ),
          ],
        ),
      ),
    );
  }
}

class FiltersWidget extends StatelessWidget {
  const FiltersWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: defaultDecoration,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                    onPressed: () {},style: buttonStyle, child:  Text('Найбільша вигода', style: defaultTextStyleOfSaleFilters,textAlign: TextAlign.center,)),
              ),
              Expanded(
                child: TextButton(
                    onPressed: () {},style: buttonStyle, child:  Text('Найдешевші', style: defaultTextStyleOfSaleFilters)),
              ),
              Expanded(
                  child:
                      TextButton(onPressed: () {},style: buttonStyle, child: Text('Губи', style: defaultTextStyleOfSaleFilters))),
            ],
          ),
          const Divider(
            color: Colors.black,
          ),
          TextButton(onPressed: () {},style: buttonStyle, child: const Text('Фільтр', style: TextStyle(color: Colors.black, letterSpacing: 25,fontSize: 22),))
        ],
      ),
    );
  }
}

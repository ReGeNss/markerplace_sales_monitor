import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50,bottom: 20, left: 20, right: 20),
          child: Column(
            children: [
              Container(
                height: 200,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 10,
              ),
              const FiltersWidget(),
              const SizedBox(
                height: 10,
              ),
              const MarkerplaceSelectorWidget(),
              const SizedBox(
                height: 10,
              ),
              ProductsListViewWidget(),
              
            ],
          ),
        ),
      ),
    );
  }
}

class ProductsListViewWidget extends StatelessWidget {
  const ProductsListViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          height: 100,
          color: Colors.grey,
          margin: const EdgeInsets.only(bottom: 10),
        );
      },
    );
  }
}

class MarkerplaceSelectorWidget extends StatelessWidget {
  const MarkerplaceSelectorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey,
              margin:  const EdgeInsets.only(right: 5),
              child: TextButton(
                  onPressed: () {}, child: const Text('Фора')),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              margin:  const EdgeInsets.symmetric(horizontal: 5),
              child: TextButton(
                  onPressed: () {}, child: const Text('Траш')),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              margin:  const EdgeInsets.symmetric(horizontal: 5),
              child: TextButton(
                  onPressed: () {}, child: const Text('АТБ')),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              margin:  const EdgeInsets.symmetric(horizontal: 5),
              child: TextButton(
                  onPressed: () {}, child: const Text('Сільпо')),
            ),
          ),
          Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  color: Colors.grey,
                  child:
                      TextButton(onPressed: () {}, child: const Text('Вcі')))),
        ],
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
      height: 120,
      color: Colors.grey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                    onPressed: () {},
                    child: const Text('Найбільша вигода')),
              ),
              Expanded(
                child: TextButton(
                    onPressed: () {}, child: const Text('Найдешевші')),
              ),
              Expanded(child: TextButton(onPressed: () {}, child: const Text('Губи'))),
            ],
          ),
          const Divider(color: Colors.black,), 
          FilledButton(onPressed: () {}, child: const Text('Фільтр'))
        ],
      ),
    );
  }
}
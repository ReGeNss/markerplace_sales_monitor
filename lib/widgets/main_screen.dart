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
              SizedBox(
                height: 10,
              ),
              FiltersWidget(),
              SizedBox(
                height: 10,
              ),
              MarkerplaceSelectorWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class MarkerplaceSelectorWidget extends StatelessWidget {
  const MarkerplaceSelectorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Colors.grey,
      child: Row(
        children: [
          Expanded(
            child: TextButton(
                onPressed: () {}, child: const Text('Фора')),
          ),
          Expanded(
            child: TextButton(
                onPressed: () {}, child: const Text('Траш')),
          ),
          Expanded(
            child: TextButton(
                onPressed: () {}, child: const Text('АТБ')),
          ),
          Expanded(
            child: TextButton(
                onPressed: () {}, child: const Text('Сільпо')),
          ),
          Expanded(child: TextButton(onPressed: () {}, child: const Text('Вcі'))),
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
          FilledButton(onPressed: () {}, child: const Text('Фільтр'))
        ],
      ),
    );
  }
}
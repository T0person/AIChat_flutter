import 'package:flutter/material.dart';

class PlotScreen extends StatelessWidget {
  const PlotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вывод потраченных средств'),
      ),
      body: const Center(
        child: Text('Графики и аналитика расходов будут здесь'),
      ),
    );
  }
}

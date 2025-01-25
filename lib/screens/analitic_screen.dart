import 'package:flutter/material.dart';

class AnaliticSceen extends StatelessWidget {
  const AnaliticSceen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Аналитика'),
      ),
      body: const Center(
        child: Text('Экран аналитики'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AboutView();
  }
}

class _AboutView extends StatelessWidget {
  const _AboutView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      drawer: const MainDrawer(),
      body: const Center(child: Text('About Screen')),
    );
  }
}

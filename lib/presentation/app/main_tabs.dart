import 'package:flutter/material.dart';

import '../breeds/breeds_controller.dart';
import '../breeds/breeds_screen.dart';
import '../home/home_controller.dart';
import '../home/home_screen.dart';

class MainTabs extends StatefulWidget {
  const MainTabs({
    super.key,
    required this.homeController,
    required this.breedsController,
    required this.onSignOut,
  });

  final HomeController homeController;
  final BreedsController breedsController;
  final Future<void> Function() onSignOut;

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _BackgroundPattern(),
          SafeArea(
            child: IndexedStack(
              index: _index,
              children: [
                HomeScreen(
                  controller: widget.homeController,
                  onSignOut: widget.onSignOut,
                ),
                BreedsScreen(
                  controller: widget.breedsController,
                  onSignOut: widget.onSignOut,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.pets_outlined), label: 'Cats'),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Breeds',
          ),
        ],
      ),
    );
  }
}

class _BackgroundPattern extends StatelessWidget {
  const _BackgroundPattern();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFEFD8), Color(0xFFFFFBF5)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -40,
              left: -20,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE8673C).withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              right: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0E7C7B).withValues(alpha: 0.11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

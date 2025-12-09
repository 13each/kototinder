import 'package:flutter/material.dart';
import 'package:kototinder/screens/home_screen.dart';
import 'package:kototinder/screens/breeds_screen.dart';

void main() {
  runApp(const KototinderApp());
}

class KototinderApp extends StatelessWidget {
  const KototinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kototinder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink, useMaterial3: true),
      home: const MainTabs(),
    );
  }
}

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int index = 0;

  final screens = [const HomeScreen(), const BreedsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Котики'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Породы'),
        ],
      ),
    );
  }
}

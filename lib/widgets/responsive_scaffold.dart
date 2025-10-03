import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final Function(int) onTap;
  const ResponsiveScaffold({super.key, required this.body, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.egg), label: 'Produksi'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Keuangan'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Stok'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Invoice'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

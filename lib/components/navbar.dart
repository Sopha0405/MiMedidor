import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Navbar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Estadísticas"),
        BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: "Cupones"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Configuración"),
      ],
    );
  }
}


import 'package:flutter/material.dart';

import 'package:flutter_demo/views/profil.dart';
import 'package:provider/provider.dart';

import '../servisler/yetkilendirmeservisi.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifKullaniciId;

    return Scaffold(

      body: Center(child: _selectedIndex == 1 ?  Profil(
        profilSahibiId: aktifKullaniciId,
      ) :
      Text('Ezgi')
        //_widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Akış',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

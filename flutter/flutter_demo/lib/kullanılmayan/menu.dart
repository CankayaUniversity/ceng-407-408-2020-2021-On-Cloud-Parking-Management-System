/*
import 'package:flutter/material.dart';

import 'package:flutter_demo/servisler/yetkilendirmeservisi.dart';
import 'package:flutter_demo/views/profil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../modeller/place.dart';
import '../servisler/geolocator_service.dart';
import '../servisler/places_service.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _aktifSayfaNo = 0;
  PageController sayfaKumandasi;

  final locatorService = GeoLocatorService();
  final placesService = PlacesService();

  @override
  void initState() {
    super.initState();
    sayfaKumandasi = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    sayfaKumandasi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String aktifKullaniciId =
        Provider.of<YetkilendirmeServisi>(context, listen: false)
            .aktifKullaniciId;

    return Scaffold(
      body: PageView(
        onPageChanged: (acilanSayfaNo) {
          setState(() {
            _aktifSayfaNo = acilanSayfaNo;
          });
        },
        controller: sayfaKumandasi,
        children: <Widget>[
          //Anasayfa(),
          Profil(
            profilSahibiId: aktifKullaniciId,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _aktifSayfaNo,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Akış"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
        onTap: (secilenSayfaNo) {
          setState(() {
            _aktifSayfaNo = secilenSayfaNo;
            sayfaKumandasi.jumpToPage(secilenSayfaNo);
          });
        },
      ),
    );
  }
}


 */


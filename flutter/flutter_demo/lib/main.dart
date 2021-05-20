import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/maps/models/place.dart';
import 'package:flutter_demo/maps/screens/bottom.dart';
import 'package:flutter_demo/maps/screens/home.dart';
import 'package:flutter_demo/views/girissayfasi.dart';
import 'package:flutter_demo/yonlendirme.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'kullanılmayan/menu.dart';

import 'maps/services/geolocator_service.dart';
import 'maps/services/places_service.dart';
import 'servisler/yetkilendirmeservisi.dart';

import 'views/menu_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final locatorService = GeoLocatorService();
  final placesService = PlacesService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<YetkilendirmeServisi>(create: (_)=> YetkilendirmeServisi()),
        FutureProvider(create: (context) => locatorService.getLocation()),
        FutureProvider(create: (context) {
          ImageConfiguration configuration =
          createLocalImageConfiguration(context);
          return BitmapDescriptor.fromAssetImage(
              configuration, 'assets/images/parking-icon.png');
        }),
        ProxyProvider2<Position, BitmapDescriptor, Future<List<Place>>>(
          update: (context, position, icon, places) {
            return (position != null)
                ? placesService.getPlaces(
                position.latitude, position.longitude, icon)
                : null;
          },
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Parking App',
        theme: ThemeData(



          
          primarySwatch: Colors.blue,
        ),
        home: Yonlendirme(),
      ),
    );
  }
  }

/*void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<YetkilendirmeServisi>(
      create: (_)=> YetkilendirmeServisi(),
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Projem',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Yonlendirme(),
      ),
    );
  }
}*/

/*
Provider<YetkilendirmeServisi>(
      create: (_)=> YetkilendirmeServisi(),
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Projem',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Yonlendirme(),
      ),
    );
 */

/*
 MultiProvider(
            providers: [
              FutureProvider(create: (context) => locatorService.getLocation()),
              FutureProvider(create: (context) {
                ImageConfiguration configuration =
                    createLocalImageConfiguration(context);
                return BitmapDescriptor.fromAssetImage(
                    configuration, 'assets/images/hayalet.png');
              }),
              ProxyProvider2<Position, BitmapDescriptor, Future<List<Place>>>(
                update: (context, position, icon, places) {
                  return (position != null)
                      ? placesService.getPlaces(
                          position.latitude, position.longitude, icon)
                      : null;
                },
              )
            ],
            child: Anasayfa(),
          ),
 */
import 'package:get/get.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  final Completer<GoogleMapController> controller = Completer();

  bool isLoading = true;
  //GoogleMapController _mapController;
  LatLng firstCity = LatLng(39.9334, 32.8597);
  LatLng centerOfTurkey = LatLng(39.1702, 35.1430);
  LatLng secondCity = LatLng(31.954, 35.9354);
  LatLng thirdCity = LatLng(30.0675, -89.9272);
  List idList = ['point', 'point2', 'point3'];
  List titleList = [
    'Ankara',
    'Amman',
    'New Orleans',
  ];

  Set<Marker> createMarkers() {
    var positionList = <LatLng>[
      firstCity,
      secondCity,
      thirdCity,
      centerOfTurkey,
    ];

    var markers = <Marker>{};
    for (var i = 0; i < 3; i++) {
      markers.add(Marker(
        markerId: MarkerId(idList[i]),
        position: positionList[i],
        infoWindow: InfoWindow(title: titleList[i]),
        zIndex: 2,
        //icon: Icon(Icons.ac_unit),
      ));
    }

    return markers;
  }
}
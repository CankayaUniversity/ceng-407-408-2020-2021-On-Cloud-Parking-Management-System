import 'package:flutter/material.dart';
import 'package:flutter_demo/controller/map_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Harita extends StatefulWidget {
  @override
  _HaritaState createState() => _HaritaState();
}

class _HaritaState extends State<Harita> {
  final mapController = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              Container(
                height: size.height * .35,
                child: GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition:
                  CameraPosition(target: mapController.centerOfTurkey, zoom: 4.7),
                  onMapCreated: (GoogleMapController controller) {
                    mapController.controller.complete(controller);
                  },
                  markers: mapController.createMarkers(),
                ),
              ),



            ],
          ),
        )
    );
  }
}

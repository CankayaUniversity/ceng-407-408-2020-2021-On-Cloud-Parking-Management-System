import 'package:flutter/material.dart';
import 'package:flutter_demo/maps/services/marker_service.dart';
import 'package:flutter_demo/maps/services/geolocator_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/place.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final placesProvider = Provider.of<Future<List<Place>>>(context);
    final geoService = GeoLocatorService();
    final markerService = MarkerService();

    return FutureProvider(
      create: (context) => placesProvider,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Anasayfa",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.grey[100],
        ),
        body: (currentPosition != null)
            ? Consumer<List<Place>>(
                builder: (_, places, __) {
                  var markers = (places != null)
                      ? markerService.getMarkers(places)
                      : List<Marker>();
                  return (places != null)
                      ? Column(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height / 3,
                              width: MediaQuery.of(context).size.width,
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(currentPosition.latitude,
                                        currentPosition.longitude),
                                    zoom: 16.0),
                                zoomGesturesEnabled: true,
                                markers: Set<Marker>.of(markers),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Expanded(
                              child: (places.length > 0)
                                  ? ListView.builder(
                                      itemCount: places.length,
                                      itemBuilder: (context, index) {
                                        return FutureProvider(
                                          create: (context) =>
                                              geoService.getDistance(
                                                  currentPosition.latitude,
                                                  currentPosition.longitude,
                                                  places[index]
                                                      .geometry
                                                      .location
                                                      .lat,
                                                  places[index]
                                                      .geometry
                                                      .location
                                                      .lng),
                                          child: Card(
                                            child: ListTile(
                                              title: Text(places[index].name),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 3.0,
                                                  ),
                                                  (places[index].rating != null)
                                                      ? Row(
                                                          children: <Widget>[
                                                            RatingBarIndicator(
                                                              rating:
                                                                  places[index]
                                                                      .rating,
                                                              itemBuilder: (context,
                                                                      index) =>
                                                                  Icon(
                                                                      Icons
                                                                          .star,
                                                                      color: Colors
                                                                          .amber),
                                                              itemCount: 5,
                                                              itemSize: 10.0,
                                                              direction: Axis
                                                                  .horizontal,
                                                            )
                                                          ],
                                                        )
                                                      : Row(),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Consumer<double>(
                                                    builder: (context, meters,
                                                        wiget) {
                                                      return (meters != null)
                                                          ? Text(
                                                              '${places[index].vicinity} \u00b7 ${(meters / 1609).round()} mi')
                                                          : Container();
                                                    },
                                                  )
                                                ],
                                              ),
                                              trailing: IconButton(
                                                icon: Icon(Icons.directions),
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                onPressed: () {
                                                  _bottomSheet(
                                                      places[index].name,
                                                      context,
                                                      places[index].vicinity,
                                                      places[index]
                                                          .geometry
                                                          .location
                                                          .lat,
                                                      places[index]
                                                          .geometry
                                                          .location
                                                          .lng,
                                                      places[index].rating);
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                  : Center(
                                      child: Text('No Parking Found Nearby'),
                                    ),
                            )
                          ],
                        )
                      : Center(child: CircularProgressIndicator());
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _bottomSheet(String name, context, String vicinity, double lat,
      double lng, double ratingg) async {
    showModalBottomSheet(
        context: context,
        // isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Stack(
            children: [
              Container(
                height: 350.0,
                margin: EdgeInsets.only(top: 32),
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      height: 125.0,
                      color: Colors.blueAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$name",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Row(
                              children: <Widget>[
                                RatingBarIndicator(
                                  rating: ratingg,
                                  itemBuilder: (context, index) =>
                                      Icon(Icons.star, color: Colors.amber),
                                  itemCount: 5,
                                  
                                  itemSize: 20.0,
                                  direction: Axis.horizontal,
                                )
                                
                              ],
                              
                            ),
                            //: Row(),
                            SizedBox(
                              height: 5,
                            ),
                            Text("$lat, $lng",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.map,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("$vicinity")
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.call,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("040-123456")
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.clean_hands,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Araç yıkama hizmeti sunmaktadır.")
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: FloatingActionButton(
                      child: Icon(Icons.navigation), onPressed: () {_launchMapsUrl(lat,lng);}),
                ),
              )
            ],
          );
        });
  }
}
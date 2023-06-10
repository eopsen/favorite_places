import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key,
      this.location = const PlaceLocation(
        latitude: 37.422,
        longitude: -122.084,
        address: '',
      ),
      this.isSelecting = true});
  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  double currentLat = 0;
  double currentLng = 0;

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition().then((Position pos) {
      setState(() {
        currentLat = pos.latitude;
        currentLng = pos.longitude;
      });
    });
  }

  Future<void> _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAAqWexKpwdLLIlU3cyL8hUcrIZw_LWDTk", // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.transit,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 5,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
  }

  Future<bool> _showRoute() async {
    if (!widget.isSelecting) {
      await _createPolylines(currentLat, currentLng, widget.location.latitude,
          widget.location.longitude);
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _showRoute(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.isSelecting
                  ? 'Wybierz lokalizacje'
                  : 'Twoja lokalizacja'),
              actions: [
                if (widget.isSelecting)
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
                    icon: const Icon(Icons.save),
                  ),
              ],
            ),
            body: GoogleMap(
              polylines: Set<Polyline>.of(polylines.values),
              onTap: !widget.isSelecting
                  ? null
                  : (position) {
                      setState(() {
                        _pickedLocation = position;
                      });
                    },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.location.latitude,
                  widget.location.longitude,
                ),
                zoom: 16,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: (_pickedLocation == null && widget.isSelecting)
                  ? {}
                  : {
                      Marker(
                        markerId: const MarkerId('m1'),
                        position: _pickedLocation ??
                            LatLng(
                              currentLat,
                              currentLng,
                            ),
                      ),
                      Marker(
                        markerId: const MarkerId('m2'),
                        position: _pickedLocation ??
                            LatLng(
                              widget.location.latitude,
                              widget.location.longitude,
                            ),
                      ),
                    },
            ),
          );
        }
      },
    );
  }
}

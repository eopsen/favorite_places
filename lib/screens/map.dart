import 'package:flutter/material.dart';
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

Future<Position> _getCurrentLocation() async {
  return await Geolocator.getCurrentPosition();
}

late double lat = 0;
late double lng = 0;

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  @override
  Widget build(BuildContext context) {
    final Polyline _polyline = Polyline(polylineId:PolylineId('_polyline'),
        points :[
          LatLng(lat,lng),
          LatLng(widget.location.latitude, widget.location.longitude)
        ],
      width:5,
    );
    _getCurrentLocation().then((value){
      lat =  value.latitude;
      lng =  value.longitude;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isSelecting ? 'Wybierz lokalizacje' : 'Twoja lokalizacja'),
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
        polylines:{
          _polyline
        },
        markers: (_pickedLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pickedLocation ??
                      LatLng(
                        lat,
                        lng,
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
}

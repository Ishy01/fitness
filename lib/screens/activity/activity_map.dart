import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../tracker/location.dart';

class ActivityMapScreen extends StatefulWidget {
  @override
  _ActivityMapScreenState createState() => _ActivityMapScreenState();
}

class _ActivityMapScreenState extends State<ActivityMapScreen> {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  List<LatLng> _routeCoords = [];
  bool _isMapLoading = true;
  String? _mapLoadError;

  @override
  void initState() {
    super.initState();
    Provider.of<LocationTracker>(context, listen: false).addListener(_updateRoute);
  }

  @override
  void dispose() {
    Provider.of<LocationTracker>(context, listen: false).removeListener(_updateRoute);
    super.dispose();
  }

  void _updateRoute() {
    final locationTracker = Provider.of<LocationTracker>(context, listen: false);
    setState(() {
      _routeCoords = locationTracker.routeCoords;
      _polylines = {
        Polyline(
          polylineId: PolylineId('route'),
          visible: true,
          points: _routeCoords,
          width: 5,
          color: Colors.blue,
        ),
      };

      // Add or update marker for the current position
      if (_routeCoords.isNotEmpty) {
        LatLng currentPosition = _routeCoords.last;
        _markers = {
          Marker(
            markerId: MarkerId('current_position'),
            position: currentPosition,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        };

        // Move the camera to the current position
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(currentPosition),
        );
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _isMapLoading = false;  // Map has loaded successfully
    });
  }

  void _onMapError(String error) {
    setState(() {
      _mapLoadError = error;  // Capture the error message
      _isMapLoading = false;  // Stop showing the loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationTracker = Provider.of<LocationTracker>(context);
    final initialPosition = locationTracker.routeCoords.isNotEmpty
        ? locationTracker.routeCoords.first
        : LatLng(6.6928, -1.5713); // Default to Kumasi

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: 14.0,
          ),
          polylines: _polylines,
          markers: _markers,
          onMapCreated: _onMapCreated,
          onCameraIdle: () {
            if (_mapLoadError != null) {
              _onMapError("Map failed to load. Please try again.");
            }
          },
        ),
        if (_isMapLoading)
          Center(
            child: CircularProgressIndicator(),
          ),
        if (_mapLoadError != null)
          Center(
            child: Text(
              _mapLoadError!,
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fitness/models/activity_session.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActivityDetailScreen extends StatelessWidget {
  final ActivitySession activity;

  ActivityDetailScreen({required this.activity});

  @override
  Widget build(BuildContext context) {
    final duration = activity.endTime.difference(activity.startTime).inMinutes;
    final distance = activity.distance / 1000; // Convert to km
    final steps = activity.steps;
    final calories = activity.calories;

    // Convert the route to LatLng for Google Maps
    final List<LatLng> route = activity.route.map((point) {
      final lat = point['lat'] as double?;
      final lng = point['lng'] as double?;
      if (lat == null || lng == null) {
        print('Warning: Null value found in route data');
        return LatLng(0.0, 0.0); // Default value
      }
      return LatLng(lat, lng);
    }).toList();

    // Create a polyline to display the route
    final Polyline routePolyline = Polyline(
      polylineId: PolylineId('route'),
      points: route,
      color: Colors.blue,
      width: 4,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity: ${activity.activityType}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Date: ${activity.startTime.toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Time: ${activity.startTime.toLocal().toString().split(' ')[1].split('.')[0]}',
              style: TextStyle(fontSize: 18),
            ),
            Divider(height: 32, thickness: 2),
            Text(
              'Duration: $duration minutes',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Distance: ${distance.toStringAsFixed(2)} km',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Steps: $steps',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Calories Burned: ${calories.toStringAsFixed(2)} kcal',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 32),

            // Display the map
            Container(
              height: 300,
              child: route.isNotEmpty
                  ? GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: route[0], // Set to the first point in the route
                        zoom: 15,
                      ),
                      polylines: {routePolyline},
                      markers: {
                        if (route.isNotEmpty)
                          Marker(
                            markerId: MarkerId('start'),
                            position: route.first,
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                            infoWindow: InfoWindow(title: 'Start'),
                          ),
                        if (route.isNotEmpty)
                          Marker(
                            markerId: MarkerId('end'),
                            position: route.last,
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                            infoWindow: InfoWindow(title: 'End'),
                          ),
                      },
                    )
                  : Center(
                      child: Text(
                        'No route data available',
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

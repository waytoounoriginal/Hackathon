import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import 'dart:math' as math;

import '../others/color_scheme.dart';
import '../others/navbar.dart';
import '../others/frontend_icons_icons.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  void _animatedMapMove(LatLng dest, double newZoom) {
    final latTween = Tween<double>(
        begin: _mapController.center.latitude, end: dest.latitude);
    final longTween = Tween<double>(
        begin: _mapController.center.longitude, end: dest.longitude);

    final zoomTween = Tween<double>(begin: _mapController.zoom, end: newZoom);

    final controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.easeOut);

    controller.addListener(() {
      _mapController.move(
          LatLng(latTween.evaluate(animation), longTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void generateRandCoords({required int pairs}) {
    for (int i = 0; i < pairs; i++) {
      double x = math.Random().nextDouble() * 180 - 90;
      double y = math.Random().nextDouble() * 180 - 90;

      coords.add(LatLng(x, y));
    }

    print('Coords: $coords');
  }

  void generateMarkers() {
    for (int i = 0; i < coords.length; i++) {
      final markerKey = GlobalKey();

      markers.add(Marker(
          point: coords[i],
          width: 80,
          height: 80,
          builder: (context) => GestureDetector(
                onTap: () {
                  _animatedMapMove(coords[i], 5);
                  //  currentSelected.value = i;
                },
                key: markerKey,
                child: const Icon(
                  Icons.food_bank,
                  color: Colors.white,
                ),
              )));
    }
  }

  late MapController _mapController;
  List<LatLng> coords = [];
  List<Marker> markers = [];

  @override
  void initState() {
    _mapController = MapController();

    generateRandCoords(pairs: 5);
    generateMarkers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Test Map"),
        ),
        body: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(0.0, 0.0),
                zoom: 2.0,
                maxZoom: 19.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.seon_challenge_dreamit',
                ),
                PolylineLayer(
                  polylineCulling: true,
                  polylines: [
                    Polyline(
                        points: coords,
                        color: Colors.white54,
                        isDotted: true,
                        strokeWidth: 3,
                        strokeCap: StrokeCap.round)
                  ],
                ),
                MarkerLayer(
                  markers: markers,
                ),
              ],
            ),
          ],
        ));
  }
}

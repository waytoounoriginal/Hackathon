import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:latlong2/latlong.dart' as lat;
import 'package:flutter_map/flutter_map.dart';

import 'dart:math' as math;

import '../others/color_scheme.dart';
import '../others/navbar.dart';
import '../others/frontend_icons_icons.dart';
import '../others/marker.dart';

class MapPage extends StatefulWidget {
  final AnimationController controller;
  const MapPage({super.key, required this.controller});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  void _animatedMapMove(lat.LatLng dest, double newZoom) {
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
          lat.LatLng(
              latTween.evaluate(animation), longTween.evaluate(animation)),
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

      coords.add(lat.LatLng(x, y));
    }

    print('Coords: $coords');
  }

  void generateMarkers() {
    List<lat.LatLng> currentLine = [];
    List<Color> currentColors = [];

    for (int i = 0; i < coords.length; i++) {
      //  final markerKey = GlobalKey();

      NavMarker nMarker = NavMarker(
          coords: coords[i],
          ip: '127.0.0.1',
          country: "RU",
          state: NavState.inactive,
          color: i % 2 == 0 ? NavScore.green : NavScore.red,
          size: 80.0);

      markers.add(ComplexMarker(
          nMarker: nMarker,
          context: context,
          func: () {
            moveToNode(i);
          }));

      Color lineColor;

      switch (nMarker.color) {
        case NavScore.green:
          lineColor = Colors.greenAccent.withOpacity(.5);
          break;
        case NavScore.yellow:
          lineColor = Colors.yellow.withOpacity(.5);
          break;
        case NavScore.red:
          lineColor = Colors.redAccent.withOpacity(.5);
          break;
        default:
          lineColor = Colors.white.withOpacity(.5);
          break;
      }

      currentLine.add(coords[i]);
      currentColors.add(lineColor);

      if (i > 0) {
        //print(currentLine);

        connectionLines.add(Polyline(
            points: currentLine.toList(),
            gradientColors: currentColors.toList(),
            isDotted: true,
            strokeWidth: 3,
            strokeCap: StrokeCap.round));

        print(connectionLines.map((e) => e.points));
        print('\n');

        currentLine.removeAt(0);
        currentColors.removeAt(0);
      }
    }
  }

  void moveToNode(int node) {
    currentIndex.value = node;

    setState(() {
      markers[node].nMarker.state = NavState.active;
    });

    _animatedMapMove(markers[node].nMarker.coords, 5);
  }

  late MapController _mapController;
  List<lat.LatLng> coords = [];
  List<Polyline> connectionLines = [];
  List<ComplexMarker> markers = [];

  ValueNotifier currentIndex = ValueNotifier(-1);

  @override
  void initState() {
    _mapController = MapController();

    generateRandCoords(pairs: 5);
    generateMarkers();

    super.initState();
  }

  void _showDetailsAboutNode(int node) {
    Color _color;

    switch (markers[node].nMarker.color) {
      case NavScore.green:
        _color = AppColorScheme.lighterGreen;
        break;
      case NavScore.yellow:
        _color = Color.fromARGB(255, 233, 228, 184);
        break;
      case NavScore.red:
        _color = AppColorScheme.bkgSusRed;
        break;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black12,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * .5,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            color: _color),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Current Node's IP:",
                    style: TextSchemes.titleStyle
                        .copyWith(color: AppColorScheme.mediumGreen),
                  ),
                  Row(
                    children: [
                      SmallFlag(country: markers[node].nMarker.country),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        markers[node].nMarker.ip,
                        style: TextSchemes.titleStyle
                            .copyWith(color: AppColorScheme.mediumGreen),
                      )
                    ],
                  ),
                ],
              )),
              Divider(
                height: 25,
                indent: MediaQuery.of(context).size.width / 4,
                endIndent: MediaQuery.of(context).size.width / 4,
                color: Colors.grey.withOpacity(.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   title: const Text("Test Map"),
        // ),
        body: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: lat.LatLng(0.0, 0.0),
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
                  polylines: connectionLines,
                ),
                MarkerLayer(
                  markers: markers.map((e) => e.buildMarker()).toList(),
                ),
              ],
            ),
            Positioned(
              top: 0,
              child: ClipPath(
                clipper: SemiCipper(),
                child: Container(
                  color: AppColorScheme.greishWhite,
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Transform.translate(
                    offset: const Offset(0, -20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // setState(() {
                              //   markers[currentIndex.value].nMarker.state =
                              //       NavState.inactive;
                              // });

                              currentIndex.value = -1;
                              _animatedMapMove(lat.LatLng(0, 0), 2);
                              widget.controller.reverse();
                            },
                            child: Container(
                              height: 25,
                              width: 55,
                              decoration: ContainerDecorations
                                  .whiteContainerDeco
                                  .copyWith(
                                      color: AppColorScheme.normalGreen,
                                      boxShadow: []),
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_back,
                                        color: AppColorScheme.greishWhite,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text('Back',
                                          style: TextSchemes.titleStyle
                                              .copyWith(
                                                  color: AppColorScheme
                                                      .greishWhite))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline_outlined,
                                color: AppColorScheme.mediumGreen,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              //  DEBUG
                              Text(
                                'Mihai Tira',
                                style: TextSchemes.titleStyle.copyWith(
                                    color: AppColorScheme.mediumGreen),
                              )
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 6,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: currentIndex,
              builder: (context, value, child) {
                return AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    bottom: currentIndex.value == -1 ? -300 : 0,
                    right: 0,
                    left: 0,
                    curve: Curves.decelerate,
                    child: LimitedBox(
                      maxHeight: MediaQuery.of(context).size.height * .5,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: currentIndex.value > 0,
                                    child: NodeButton(
                                        marker: currentIndex.value != -1 &&
                                                currentIndex.value > 0
                                            ? markers[currentIndex.value - 1]
                                                .nMarker
                                            : null,
                                        index: currentIndex.value,
                                        maxIndex: markers.length,
                                        func: () {
                                          moveToNode(currentIndex.value - 1);
                                        },
                                        type: 0),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _animatedMapMove(lat.LatLng(0, 0), 2);
                                      currentIndex.value = -1;
                                    },
                                    child: Container(
                                      height: 25,
                                      width: 75,
                                      decoration: ContainerDecorations
                                          .whiteContainerDeco,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FittedBox(
                                          child: Text(
                                            'Zoom Out',
                                            style: TextSchemes.titleStyle
                                                .copyWith(
                                                    color: AppColorScheme
                                                        .mediumGreen),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        currentIndex.value < markers.length - 1,
                                    child: NodeButton(
                                        marker: currentIndex.value != -1 &&
                                                currentIndex.value <
                                                    markers.length - 1
                                            ? markers[currentIndex.value + 1]
                                                .nMarker
                                            : null,
                                        index: currentIndex.value,
                                        maxIndex: markers.length,
                                        func: () {
                                          moveToNode(currentIndex.value + 1);
                                        },
                                        type: 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 100,
                            child: Container(
                              height: 20,
                              width: 125,
                              decoration:
                                  ContainerDecorations.whiteContainerDeco,
                              child: Padding(
                                padding: const EdgeInsets.all(4.25),
                                child: FittedBox(
                                  child: Text(
                                    'Selected Node',
                                    style: TextSchemes.titleStyle.copyWith(
                                        color: AppColorScheme.mediumGreen,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 125,
                            child: Container(
                              height: 40,
                              width: 175,
                              decoration:
                                  ContainerDecorations.whiteContainerDeco,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: FittedBox(
                                  child: Row(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SmallFlag(
                                              country: currentIndex.value != -1
                                                  ? markers[currentIndex.value]
                                                      .nMarker
                                                      .country
                                                  : markers[0].nMarker.country),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              currentIndex.value != -1
                                                  ? markers[currentIndex.value]
                                                      .nMarker
                                                      .ip
                                                  : markers[0].nMarker.ip,
                                              style: TextStyle(
                                                  color: AppColorScheme
                                                      .mediumGreen)),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _showDetailsAboutNode(
                                              currentIndex.value);
                                        },
                                        child: Icon(
                                          Icons.more_vert_rounded,
                                          color: AppColorScheme.normalGreen,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ));
              },
            )
          ],
        ));
  }
}

class SemiCipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..lineTo(0, size.height * .6)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, size.height * .6)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

class NodeButton extends StatelessWidget {
  final NavMarker? marker;
  final int type;
  final int index;
  final int maxIndex;
  final Function func;
  const NodeButton(
      {super.key,
      required this.marker,
      required this.type,
      required this.maxIndex,
      required this.func,
      required this.index});

  @override
  Widget build(BuildContext context) {
    if (marker != null) {
      return GestureDetector(
        onTap: () {
          func();
        },
        child: Stack(
          children: [
            Positioned(
              left: type == 0 ? 0 : null,
              bottom: 0,
              right: type == 0 ? null : 0,
              child: Container(
                height: 20,
                width: 90,
                decoration: ContainerDecorations.whiteContainerDeco,
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(children: [
                      SmallFlag(country: marker!.country),
                      const SizedBox(
                        width: 7.5,
                      ),
                      Text(marker!.ip,
                          style: TextStyle(color: AppColorScheme.mediumGreen))
                    ]),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -22.5),
              child: Container(
                height: 35,
                width: 115,
                decoration: ContainerDecorations.whiteContainerDeco,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: type == 0
                              ? [
                                  Icon(
                                    Icons.arrow_back,
                                    color: AppColorScheme.normalGreen,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text('Previous Node',
                                      style: TextSchemes.titleStyle.copyWith(
                                          color: AppColorScheme.mediumGreen,
                                          fontWeight: FontWeight.w500))
                                ]
                              : [
                                  Text('Next Node',
                                      style: TextSchemes.titleStyle.copyWith(
                                          color: AppColorScheme.mediumGreen,
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: AppColorScheme.normalGreen,
                                  ),
                                ])),
                ),
              ),
            ),
          ],
        ),
      );
    } else
      return const SizedBox();
  }
}

class SmallFlag extends StatelessWidget {
  final String country;
  const SmallFlag({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 20,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: Image.asset(
                      'assets/images/flags/${country.toLowerCase()}.png')
                  .image)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:lottie/lottie.dart';

enum NavState { inactive, active }

enum NavScore { green, yellow, red }

class NavMarker {
  LatLng coords;
  NavState state;
  NavScore color;
  String country;
  String ip;
  double size;
  NavMarker({
    required this.coords,
    required this.size,
    required this.state,
    required this.ip,
    required this.color,
    required this.country
  });

  


  Widget widgetBuild() {
    String format = '';
    String _color = color.toString().split('.').last;

    if (state == NavState.active) {
      format = 'Lottie';
    }

    if (format == 'Lottie') {
      return Lottie.asset('assets/gifs/${_color}_active.json');
    }

    return Image.asset('assets/gifs/${_color}_inactive.png');
  }
}

class ComplexMarker {
  NavMarker nMarker;
  BuildContext context;
  Function func;
  ComplexMarker(
      {required this.nMarker, required this.context, required this.func});

  fmap.Marker buildMarker() {
    return fmap.Marker(
        point: nMarker.coords,
        width: nMarker.size,
        height: nMarker.size,
        builder: (context) => GestureDetector(
              onTap: () {
                func();
              },
              child: nMarker.widgetBuild(),
            ));
  }
}

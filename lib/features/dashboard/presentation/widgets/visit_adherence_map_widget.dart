// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'package:flutter/material.dart';
import 'package:fz_hooks/fz_hooks.dart';
import 'package:google_maps/google_maps.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

Widget visitAdherenceMapWidget({required List<VisitModel> visits}) {
  final dateFormat = DateFormat('dd-MM-yyyy hh:mm a');
  String htmlId = "${visits[0].id}-${visits.length}";

  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
    final mapOptions = MapOptions()
      ..zoom = 7
      ..center = LatLng(0.3133078, 32.6145772)
      ..mapTypeId = MapTypeId.ROADMAP;

    final elem = DivElement()
      ..id = htmlId
      ..style.width = "100%"
      ..style.height = "100%"
      ..style.border = 'none';

    final map = GMap(elem, mapOptions);
    List<MarkerOptions> markerOptionsList = [];

    // VISITS
    for (var r = 0; r < visits.length; r++) {
      final lat = visits[r].endLatitude;
      final lng = visits[r].endLongitude;
      markerOptionsList.add(
        MarkerOptions()
          ..position = LatLng(lat, lng)
          ..map = map
          ..title = visits[r].customerId
          // ..label = r.toString()
          ..icon =
              'https://firebasestorage.googleapis.com/v0/b/field-zoom.appspot.com/o/FIELD%20ZOOM%2Fred-flag.png?alt=media&token=bf7cdb22-2f0c-4f9d-b0f6-5ff9f526f5ca',
      );
    }
    for (var i = 0; i < markerOptionsList.length; i++) {
      var contentString = '''
        <div>
            <strong>
              <p style="color: black">${visits[i].customerId}</p>
            </strong>
            <p style="color: black">${dateFormat.format(visits[i].visitEndDate as DateTime)}</p>
        </div>
        ''';
      final infoWindow =
          InfoWindow(InfoWindowOptions()..content = contentString);
      final marker = Marker(markerOptionsList[i]);
      marker.onClick.listen((event) => infoWindow.open(map, marker));
    }
    return elem;
  });

  return HtmlElementView(viewType: htmlId);
}

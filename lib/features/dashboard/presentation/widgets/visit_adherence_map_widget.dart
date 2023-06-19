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

    for (var r = 0; r < visits.length; r++) {
      final lat = visits[r].latitude;
      final lng = visits[r].longitude;
      markerOptionsList.add(
        MarkerOptions()
          ..position = LatLng(lat, lng)
          ..map = map
          ..title = visits[r].customerId
          // ..label = r.toString()
          ..icon =
              'https://firebasestorage.googleapis.com/v0/b/nhop-mw-assessment.appspot.com/o/FCMImages%2FnPin32.png?alt=media&token=0fd997b1-79c7-40d8-b210-fccc0534c1fd',
      );
    }

    for (var i = 0; i < markerOptionsList.length; i++) {
      var contentString =
          ''''
          <div class="card">
            <div class="card-body">
                <h5 class="card-title">${visits[i].customerId}</h5>
                <h6 class="card-subtitle mb-2 text-muted">${visits[i].customerId}</h6>
                <h6 class="card-subtitle mb-2 text-muted">${dateFormat.format(visits[i].visitDate as DateTime)}</h6>
            </div>
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

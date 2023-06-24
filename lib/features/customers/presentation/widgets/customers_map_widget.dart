// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:fz_hooks/fz_hooks.dart';
import 'package:google_maps/google_maps.dart';
import 'dart:ui' as ui;

Widget customersMapWidget({required List<CustomerModel> customers}) {
  String htmlId = "${customers[0].id}-${customers.length}";

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

    for (var r = 0; r < customers.length; r++) {
      final lat = customers[r].latitude;
      final lng = customers[r].longitude;
      markerOptionsList.add(
        MarkerOptions()
          ..position = LatLng(lat, lng)
          ..map = map
          ..title = customers[r].businessName
          // ..label = r.toString()
          ..icon =
              'https://firebasestorage.googleapis.com/v0/b/field-zoom.appspot.com/o/FIELD%20ZOOM%2Flocation.png?alt=media&token=aef90470-dccd-455b-a454-d505c59884da',
      );
    }

    for (var i = 0; i < markerOptionsList.length; i++) {
      var contentString = ''''
          <div class="card">
            <div class="card-body">
                <h5 class="card-title">${customers[i].businessName}</h5>
                <h6 class="card-subtitle mb-2 text-muted">${customers[i].phoneNumber}</h6>
                <p class="card-text">${customers[i].locationDescription}</p>
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

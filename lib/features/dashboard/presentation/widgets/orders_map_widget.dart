// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'package:flutter/material.dart';
import 'package:fz_hooks/fz_hooks.dart';
import 'package:google_maps/google_maps.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

Widget ordersMapWidget({required List<OrderModel> orders}) {
  final dateFormat = DateFormat('dd-MM-yyyy hh:mm a');
  final mFormat = NumberFormat("UGX #,###");
  String htmlId = "${orders[0].id}-${orders.length}";

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

    for (var r = 0; r < orders.length; r++) {
      final lat = orders[r].latitude;
      final lng = orders[r].longitude;
      markerOptionsList.add(
        MarkerOptions()
          ..position = LatLng(lat, lng)
          ..map = map
          ..title = orders[r].customerId
          // ..label = r.toString()
          ..icon =
              'https://firebasestorage.googleapis.com/v0/b/nhop-mw-assessment.appspot.com/o/FCMImages%2FnPin32.png?alt=media&token=0fd997b1-79c7-40d8-b210-fccc0534c1fd',
      );
    }

    for (var i = 0; i < markerOptionsList.length; i++) {
      var contentString = '''
          <div>
            <!-- <strong> 
              <p style="color: black"> <h5 class="card-title">${orders[i].customerId}</h5></p>
            </strong> -->
            <p style="color: black">${mFormat.format(orders[i].amount)}</p>
            <p style="color: black">${dateFormat.format(orders[i].createdAt as DateTime)}</p>
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

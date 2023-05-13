// import 'dart:html';
// import 'package:flutter/material.dart';
// import 'package:google_maps/google_maps.dart';
// import 'dart:ui' as ui;

// import 'package:nhop_hooks/nhop_hooks.dart';

// Widget getMap({required List<VisitAdherenceModel> visits}) {
//   String htmlId = "${visits[0].id}-${visits.length}";

//   // ignore: undefined_prefixed_name
//   ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
//     final mapOptions = MapOptions()
//       ..zoom = 7
//       ..center = LatLng(0.3133078, 32.6145772)
//       ..mapTypeId = MapTypeId.ROADMAP;

//     final elem = DivElement()
//       ..id = htmlId
//       ..style.width = "100%"
//       ..style.height = "100%"
//       ..style.border = 'none';

//     final map = GMap(elem, mapOptions);

//     List<MarkerOptions> markerOptionsList = [];

//     for (var r = 0; r < visits.length; r++) {
//       final gps = visits[r].current_gps;
//       final lat = double.parse(gps.split(',')[0]);
//       final lng = double.parse(gps.split(',')[1]);
//       markerOptionsList.add(
//         MarkerOptions()
//           ..position = LatLng(lat, lng)
//           ..map = map
//           ..title = visits[r].business_name
//           // ..label = r.toString()
//           ..icon =
//               'https://firebasestorage.googleapis.com/v0/b/nhop-mw-assessment.appspot.com/o/FCMImages%2FnPin32.png?alt=media&token=0fd997b1-79c7-40d8-b210-fccc0534c1fd',
//       );
//     }

//     for (var i = 0; i < markerOptionsList.length; i++) {
//       var contentString = ''''
//           <div id="content">
//               <div id="siteNotice"></div>
//               <h1 id="firstHeading" class="firstHeading">${visits[i].business_name}</h1>
//               <div id="bodyContent">
//                   <p><b>Uluru</b>, also referred to as</p>
//               </div>
//           </div>
//         ''';
//       final infoWindow =
//           InfoWindow(InfoWindowOptions()..content = contentString);
//       final marker = Marker(markerOptionsList[i]);
//       marker.onClick.listen((event) => infoWindow.open(map, marker));
//     }

//     return elem;
//   });

//   return HtmlElementView(viewType: htmlId);
// }

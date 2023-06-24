import 'package:field_zoom_pro_web/core/presentation/widgets/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:field_zoom_pro_web/firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Using fast_cached_network_image package to cache images
  // String storageLocation = (await getApplicationDocumentsDirectory()).path;
  // await FastCachedImageConfig.init(
  //     subDir: storageLocation, clearCacheAfter: const Duration(days: 15));

  runApp(const ProviderScope(child: MyApp()));
}

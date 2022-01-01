import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:simple_state_provider/ads/ad_banner_helper.dart';
import 'package:simple_state_provider/number_model.dart';

import 'homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AdBannerHelper()),
        ChangeNotifierProvider(create: (context) => NumberModel()),
      ],
      child: const SimpleProviderApp(),
    ),
  );
}

class SimpleProviderApp extends StatelessWidget {
  const SimpleProviderApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage('Flutter Simple Provider'),
    );
  }
}

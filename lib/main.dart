import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:simple_state_provider/ad_state.dart';
import 'package:simple_state_provider/number_model.dart';
import 'package:simple_state_provider/second_page.dart';

import 'homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: adState),
        ChangeNotifierProvider(create: (context) => NumberModel()),
        // Provider(create: (context)=>)
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
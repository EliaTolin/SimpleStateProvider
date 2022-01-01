import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:simple_state_provider/ad_state.dart';
import 'package:simple_state_provider/number_model.dart';
import 'package:simple_state_provider/second_page.dart';

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
      home: const MyHomePage('Flutter Simple Provider'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(this.title, {Key? key}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BannerAd? banner;
  AdState? adStateBanner;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    adStateBanner = Provider.of<AdState>(context);
    adStateBanner!.initialization.then(
      (status) {
        setState(() {
          banner = BannerAd(
            adUnitId: adStateBanner!.bannerAdUnitId,
            size: AdSize.banner,
            request: const AdRequest(),
            listener: adStateBanner!.adListener,
          )..load();
        });
      },
    );
  }

  void _incrementCounter(BuildContext context) {
    Provider.of<NumberModel>(context, listen: false).add();
    if (Provider.of<NumberModel>(context, listen: false).num == 3) {
      showInterstial();
    }
    if (Provider.of<NumberModel>(context, listen: false).num == 9) {
      showInterstial();
    }
    if (Provider.of<NumberModel>(context, listen: false).num == 6) {
      showInterstial();
    }
  }

  void showInterstial() async {
    await adStateBanner!.createInterstialAd();
    adStateBanner!.showInterad();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<NumberModel>(context, listen: false).initizialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Consumer<NumberModel>(builder: (context, num, child) {
              return Text(
                Provider.of<NumberModel>(context, listen: false).num.toString(),
                style: Theme.of(context).textTheme.headline4,
              );
            }),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondPage()),
                );
              },
              child: const Text("Second Page"),
            ),
            if (banner == null)
              const SizedBox(height: 50)
            else
              Container(
                height: 50,
                child: AdWidget(ad: banner!),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incrementCounter(context),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

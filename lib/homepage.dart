import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:simple_state_provider/ads/ad_banner_helper.dart';
import 'package:simple_state_provider/ads/ad_interstitial_helper.dart';
import 'package:simple_state_provider/second_page.dart';
import 'number_model.dart';

const int maxFailedLoadAttemps = 3;

class HomePage extends StatefulWidget {
  const HomePage(this.title, {Key? key}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AdInterstitialHelper adInterstitialHelper = AdInterstitialHelper();

  void _incrementCounter(BuildContext context) {
    Provider.of<NumberModel>(context, listen: false).add();
    int num = Provider.of<NumberModel>(context, listen: false).num;
    if (num == 3 || num == 6 || num == 9) {
      adInterstitialHelper.showInterstialAds();
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AdBannerHelper>(context, listen: false).createBannerAd();
    adInterstitialHelper.createInterstialAd();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<NumberModel>(context, listen: false).initizialize();
    });
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<AdBannerHelper>(context, listen: false).adDispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: Consumer<AdBannerHelper>(
          builder: (context, AdBannerHelper bannerHelper, child) {
        if (bannerHelper.isBottomBannerAdLoaded) {
          AdSize adSize = bannerHelper.getSizeBanner();
          return Container(
              height: adSize.height.toDouble(),
              width: adSize.width.toDouble(),
              child: AdWidget(
                ad: bannerHelper.getBanner(),
              ));
        }
        return Container();
      }),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Consumer<NumberModel>(
              builder: (context, NumberModel num, child) {
                return Text(
                  Provider.of<NumberModel>(context, listen: false)
                      .num
                      .toString(),
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondPage()),
                );
              },
              child: const Text("Second Page"),
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

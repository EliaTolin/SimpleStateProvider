import 'package:flutter/material.dart';
import 'package:simple_state_provider/number_model.dart';
import 'package:provider/provider.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NumberModel>(
        builder: (context, num, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Number is ${num.num}",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<NumberModel>(context, listen: false).setNum(10);
                },
                child: const Text("Set number 10"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("First page"),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:fl_jverify/fl_jverify.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

void main() {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, title: '极光认证', home: HomePage()));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  void initialize() async {
    final result = await FlJVerify().setup();
    log(result?.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBar(title: const Text('极光认证 Flutter')),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedText('initialize', onPressed: initialize),
        ]);
  }
}

class ElevatedText extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  const ElevatedText(this.title, {Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ElevatedButton(onPressed: onPressed, child: Text(title));
}

import 'package:fl_jverify/fl_jverify.dart';
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
  String text = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBar(title: const Text('极光认证 Flutter')),
        padding: const EdgeInsets.all(20),
        children: [
          Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              child: Text(text),
              height: 100),
          Wrap(spacing: 10, alignment: WrapAlignment.center, children: [
            ElevatedText('setup', onPressed: () async {
              final result = await FlJVerify().setup();
              if (result == null) return;
              text = result.toMap().toString();
              setState(() {});
            }),
            ElevatedText('setDebugMode', onPressed: () async {
              final result = await FlJVerify().setDebugMode(true);
              text = result.toString();
              setState(() {});
            }),
            ElevatedText('isInitSuccess', onPressed: () async {
              final result = await FlJVerify().isInitSuccess();
              text = result.toString();
              setState(() {});
            }),
            ElevatedText('checkVerifyEnable', onPressed: () async {
              final result = await FlJVerify().checkVerifyEnable();
              text = result.toString();
              setState(() {});
            }),
            ElevatedText('getToken', onPressed: () async {
              final result = await FlJVerify().getToken();
              if (result == null) return;
              text = result.toMap().toString();
              setState(() {});
            }),
            ElevatedText('preLogin', onPressed: () async {
              final result = await FlJVerify().preLogin();
              if (result == null) return;
              text = result.toMap().toString();
              setState(() {});
            }),
            ElevatedText('loginAuth', onPressed: () async {
              final result = await FlJVerify().loginAuth();
              if (result == null) return;
              text = result.toMap().toString();
              setState(() {});
            }),
            ElevatedText('clearPreLoginCache', onPressed: () async {
              final result = await FlJVerify().clearPreLoginCache();
              text = result.toString();
              setState(() {});
            }),
            ElevatedText('getSMSCode', onPressed: () async {
              final result = await FlJVerify().getSMSCode(phone: '');
              if (result == null) return;
              text = result.toMap().toString();
              setState(() {});
            }),
            ElevatedText('setSmsIntervalTime', onPressed: () async {
              final result = await FlJVerify().setSmsIntervalTime(1000);
              text = result.toString();
              setState(() {});
            }),
            ElevatedText('dismissLoginAuthPage', onPressed: () async {
              final result = await FlJVerify().dismissLoginAuthPage();
              text = result.toString();
              setState(() {});
            }),
          ])
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

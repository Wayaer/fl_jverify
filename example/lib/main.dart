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
  void initState() {
    super.initState();
    addPostFrameCallback((_) {
      setup();
    });
  }

  void setup() async {
    final result = await FlJVerify().setup(iosKey: '03a5b93c0cf529c176768bd5');
    if (result == null) return;
    text = result.toMap().toString();
    await setCustomAuthorizationView();
    setState(() {});
    checkVerifyEnable();
  }

  void checkVerifyEnable() async {
    await FlJVerify().dismissLoginAuthPage();
    final result = await FlJVerify().checkVerifyEnable();
    text = result.toString();
    setState(() {});
  }

  Future<void> setCustomAuthorizationView() async {
    final config = JVUIConfig();
    config.navText = '授权登录';
    config.navTextColor = Colors.black.value;
    config.navColor = Colors.blue.value;
    config.navHidden = true;
    config.numberColor = Colors.blue.value;
    config.numberSize = 22;
    config.logBtnText = '一键登录';
    config.logBtnOffsetX = 100;
    config.logBtnOffsetY = 100;
    config.logBtnHeight = 40;
    config.logBtnWidth = 100;
    config.numberFieldHeight = 100;
    config.logBtnTextColor = Colors.black.value;
    config.logBtnTextSize = 14;
    config.logBtnVerticalLayoutItem = JVIOSLayoutItem.login;
    config.privacyVerticalLayoutItem = JVIOSLayoutItem.privacy;
    config.modelTransitionStyle = JVIOSUIModalTransitionStyle.flipHorizontal;
    final result = await FlJVerify().setCustomAuthorizationView(config);
    print(result);
  }

  void loginAuth() async {
    final result = await FlJVerify().loginAuth(autoDismiss: false);
    if (result == null) return;
    text = result.toMap().toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBar(title: const Text('极光认证 Flutter')),
        padding: const EdgeInsets.all(20),
        children: [
          Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              child: Text(text, style: const TextStyle(fontSize: 12)),
              height: 130),
          Wrap(
              spacing: 12,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: [
                ElevatedText('setup', onPressed: setup),
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
                ElevatedText('checkVerifyEnable', onPressed: checkVerifyEnable),
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
                ElevatedText('setCustomAuthorizationView',
                    onPressed: setCustomAuthorizationView),
                ElevatedText('loginAuth', onPressed: loginAuth),
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

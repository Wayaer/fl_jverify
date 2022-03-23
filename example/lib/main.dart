import 'dart:io';

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
    FlJVerify().addEventHandler(authPageEventListener: (JVerifyResult result) {
      print('authPageEventListener===  ${result.toMap()}');
    }, clickWidgetEventListener: (String id) {
      print('clickWidgetEventListener===  $id');
    });
  }

  void checkVerifyEnable() async {
    await FlJVerify().dismissLoginAuthPage();
    final result = await FlJVerify().checkVerifyEnable();
    text = result.toString();
    setState(() {});
  }

//   Future<void> setCustomAuthorizationView() async {
//     final uiConfig = JVUIConfig();
//     bool isiOS = Platform.isIOS;
//
//     /// 自定义授权的 UI 界面，以下设置的图片必须添加到资源文件里，
//     /// android项目将图片存放至drawable文件夹下，可使用图片选择器的文件名,例如：btn_login.xml,入参为"btn_login"。
//     /// ios项目存放在 Assets.xcassets。
//     ///
//     // uiConfig.authBGGifPath = "main_gif";
//     // uiConfig.authBGVideoPath="main_vi";
//     // uiConfig.authBGVideoPath =
//     //     "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
//     uiConfig.authBGVideoImgPath = "main_v_bg";
//
//     //uiConfig.navHidden = true;
//     uiConfig.navColor = Colors.blue.value;
//     uiConfig.navText = "一键登录";
//     uiConfig.navTextColor = Colors.blue.value;
//     uiConfig.navReturnImgPath = "return_bg"; //图片必须存在
//
//     uiConfig.logoWidth = 100;
//     uiConfig.logoHeight = 80;
//     //uiConfig.logoOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.logoWidth/2).toInt();
//     uiConfig.logoOffsetY = 10;
//     uiConfig.logoVerticalLayoutItem = JVIOSLayoutItem.superView;
//     uiConfig.logoHidden = false;
//     uiConfig.logoImgPath = "logo";
//
//     uiConfig.numberFieldWidth = 200;
//     uiConfig.numberFieldHeight = 40;
//     //uiConfig.numFieldOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.numberFieldWidth/2).toInt();
//     uiConfig.numFieldOffsetY = isiOS ? 20 : 120;
//     uiConfig.numberVerticalLayoutItem = JVIOSLayoutItem.logo;
//     uiConfig.numberColor = Colors.black.value;
//     uiConfig.numberSize = 18;
//
//     uiConfig.sloganOffsetY = isiOS ? 20 : 160;
//     uiConfig.sloganVerticalLayoutItem = JVIOSLayoutItem.number;
//     uiConfig.sloganTextColor = Colors.black.value;
//     uiConfig.sloganTextSize = 15;
// //        uiConfig.slogan
//     //uiConfig.sloganHidden = 0;
//
//     uiConfig.logBtnWidth = 220;
//     uiConfig.logBtnHeight = 50;
//     //uiConfig.logBtnOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.logBtnWidth/2).toInt();
//     uiConfig.logBtnOffsetY = isiOS ? 20 : 230;
//     uiConfig.logBtnVerticalLayoutItem = JVIOSLayoutItem.slogan;
//     uiConfig.logBtnText = "登录按钮";
//     uiConfig.logBtnTextColor = Colors.black.value;
//     uiConfig.logBtnTextSize = 16;
//     uiConfig.logBtnTextBold = true;
//     uiConfig.loginBtnNormalImage = "login_btn_normal"; //图片必须存在
//     uiConfig.loginBtnPressedImage = "login_btn_press"; //图片必须存在
//     uiConfig.loginBtnUnableImage = "login_btn_unable"; //图片必须存在
//
//     uiConfig.privacyHintToast = true; //only android 设置隐私条款不选中时点击登录按钮默认显示toast。
//
//     uiConfig.privacyState = true; //设置默认勾选
//     uiConfig.privacyCheckboxSize = 20;
//     uiConfig.checkedImgPath = "check_image"; //图片必须存在
//     uiConfig.uncheckedImgPath = "uncheck_image"; //图片必须存在
//     uiConfig.privacyCheckboxInCenter = true;
//     uiConfig.privacyCheckboxHidden = false;
//
//     //uiConfig.privacyOffsetX = isiOS ? (20 + uiConfig.privacyCheckboxSize) : null;
//     uiConfig.privacyOffsetY = 15; // 距离底部距离
//     uiConfig.privacyVerticalLayoutItem = JVIOSLayoutItem.superView;
//     uiConfig.clauseBaseColor = Colors.black.value;
//     uiConfig.clauseColor = Colors.red.value;
//     uiConfig.privacyText = ["前缀", "后缀"];
//     uiConfig.privacyTextSize = 13;
//     uiConfig.privacy = [
//       JVPrivacy("自定义协议1", "http://www.baidu.com",
//           beforeName: "==", afterName: "++", separator: "*"),
//       JVPrivacy("自定义协议2", "http://www.baidu.com", separator: "、"),
//       JVPrivacy("自定义协议3", "http://www.baidu.com", separator: "、"),
//     ];
//     uiConfig.textVerAlignment = 1;
//     uiConfig.privacyWithBookTitleMark = true;
//     uiConfig.privacyTextCenterGravity = true;
//     uiConfig.authStatusBarStyle = JVIOSStatusBarStyle.darkContent;
//     uiConfig.privacyStatusBarStyle = JVIOSStatusBarStyle.defaultStyle;
//     uiConfig.modelTransitionStyle = JVIOSUIModalTransitionStyle.crossDissolve;
//
//     uiConfig.statusBarColorWithNav = true;
//     uiConfig.virtualButtonTransparent = true;
//
//     uiConfig.privacyStatusBarColorWithNav = true;
//     uiConfig.privacyVirtualButtonTransparent = true;
//
//     uiConfig.needStartAnim = true;
//     uiConfig.needCloseAnim = true;
//     uiConfig.enterAnim = "activity_slide_enter_bottom";
//     uiConfig.exitAnim = "activity_slide_exit_bottom";
//
//     uiConfig.privacyNavColor = Colors.blue.value;
//     uiConfig.privacyNavTitleTextColor = Colors.black.value;
//     uiConfig.privacyNavTitleTextSize = 16;
//     uiConfig.privacyNavTitleTitle = "运营商协议政策"; //only ios
//     uiConfig.privacyNavReturnBtnImage = "return_bg"; //图片必须存在;
//     uiConfig.modelTransitionStyle = JVIOSUIModalTransitionStyle.coverVertical;
//
//     final result = await FlJVerify().setCustomAuthorizationView(uiConfig);
//     text = result.toString();
//     setState(() {});
//   }

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

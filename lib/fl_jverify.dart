import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef JVAuthPageEventListener = void Function(JVerifyResult result);

class FlJVerify {
  factory FlJVerify() => _singleton ??= FlJVerify._();

  FlJVerify._();

  static FlJVerify? _singleton;

  final MethodChannel _channel = const MethodChannel('fl_jverify');

  /// 初始化, timeout单位毫秒，合法范围是(0,30000]，推荐设置为5000-10000,默认值为10000
  Future<JVerifyResult?> setup(
      {

      /// ios 使用
      String? iosKey,
      String? channel,
      bool useIDFA = false,

      /// andorid 使用
      int timeout = 10000,
      bool setControlWifiSwitch = true}) async {
    if (!_supportPlatform) return null;
    if (_isIOS) assert(iosKey != null);
    final map = await _channel.invokeMethod<Map<dynamic, dynamic>?>('setup', {
      'iosKey': iosKey,
      'channel': channel,
      'useIDFA': useIDFA,
      'timeout': timeout,
      'setControlWifiSwitch': setControlWifiSwitch
    });
    return map == null ? null : JVerifyResult.fromJson(map);
  }

  /// 授权页回调监听
  void addEventHandler({JVAuthPageEventListener? authPageEventListener}) {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onReceiveAuthPageEvent':
          authPageEventListener?.call(JVerifyResult.fromJson(call.arguments));
          break;
      }
    });
  }

  /// 设置 debug 模式
  Future<bool> setDebugMode(bool debug) async {
    if (!_supportPlatform) return false;
    final state = await _channel.invokeMethod<bool?>('setDebugMode', debug);
    return state ?? false;
  }

  /// 获取 SDK 初始化是否成功标识
  Future<bool> isInitSuccess() async {
    if (!_supportPlatform) return false;
    final state = await _channel.invokeMethod<bool?>('isInitSuccess');
    return state ?? false;
  }

  /// SDK判断网络环境是否支持
  Future<bool> checkVerifyEnable() async {
    if (!_supportPlatform) return false;
    final state = await _channel.invokeMethod<bool?>('checkVerifyEnable');
    return state ?? false;
  }

  /*
   * SDK 获取号码认证token
   * return Map
   *        key = 'code', vlaue = 状态码，2000代表获取成功
   *        key = 'message', value = 成功即为 token，失败为提示
   * */
  Future<JVerifyResult?> getToken({int timeOut = 5000}) async {
    if (!_supportPlatform) return null;
    final map = await _channel.invokeMethod<Map<dynamic, dynamic>?>(
        'getToken', timeOut);
    return map == null ? null : JVerifyResult.fromJson(map);
  }

  /*
   * SDK 一键登录预取号,timeOut 有效取值范围[3000,10000]
   *
   * return Map
   *        key = 'code', vlaue = 状态码，7000代表获取成功
   *        key = 'message', value = 结果信息描述
   * */
  Future<JVerifyResult?> preLogin({int timeOut = 5000}) async {
    if (!_supportPlatform) return null;
    if (timeOut >= 3000 && timeOut <= 10000) {
      timeOut = timeOut;
    }
    final map = await _channel.invokeMethod<Map<dynamic, dynamic>?>(
        'preLogin', timeOut);
    return map == null ? null : JVerifyResult.fromJson(map);
  }

  /*
  * SDK请求授权一键登录
  *
  * @param autoDismiss  设置登录完成后是否自动关闭授权页
  * @param timeout      设置超时时间，单位毫秒。 合法范围（0，30000],范围以外默认设置为10000
  *
  * @return 通过接口异步返回的 map :
  *                           key = 'code', value = 6000 代表loginToken获取成功
  *                           key = message, value = 返回码的解释信息，若获取成功，内容信息代表loginToken
  *
  * @discussion since SDK v2.4.0，授权页面点击事件监听：通过添加 JVAuthPageEventListener 监听，来监听授权页点击事件
  *
  * */
  Future<JVerifyResult?> loginAuth(
      {bool autoDismiss = true, int timeout = 5000}) async {
    if (!_supportPlatform) return null;
    final map = await _channel.invokeMethod<Map<dynamic, dynamic>?>(
        'loginAuth', {'autoDismiss': autoDismiss, 'timeout': timeout});
    return map == null ? null : JVerifyResult.fromJson(map);
  }

  /*
   * SDK 获取短信验证码
   *        key = 'code', vlaue = 状态码，3000代表获取成功
   *        key = 'message', 提示信息
   *        key = 'result',uuid
   * */
  Future<JVerifyResult?> getSMSCode(
      {required String phone, String? signId, String? tempId}) async {
    if (!_supportPlatform) return null;
    final map = await _channel.invokeMethod<Map<dynamic, dynamic>?>(
        'getSMSCode', {'phone': phone, 'signId': signId, 'tempId': tempId});
    return map == null ? null : JVerifyResult.fromJson(map);
  }

  /// 设置前后两次获取验证码的时间间隔，默认 30000ms，有效范围(0,300000)
  Future<bool> setSmsIntervalTime(int intervalTime) async {
    if (!_supportPlatform) return false;
    final state =
        await _channel.invokeMethod<bool?>('setSmsIntervalTime', intervalTime);
    return state ?? false;
  }

  /// 清除预登录缓存
  Future<bool> clearPreLoginCache() async {
    if (!_supportPlatform) return false;
    final state = await _channel.invokeMethod<bool?>('clearPreLoginCache');
    return state ?? false;
  }

  /// 关闭授权页面
  Future<bool> dismissLoginAuthPage() async {
    if (!_supportPlatform) return false;
    final state = await _channel.invokeMethod<bool?>('dismissLoginAuthPage');
    return state ?? false;
  }

  bool get _supportPlatform {
    if (!kIsWeb && (_isAndroid || _isIOS)) return true;
    debugPrint('Not support platform for $defaultTargetPlatform');
    return false;
  }

  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

  bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;
}

class JVerifyResult {
  /// 返回码，具体事件返回码请查看（https://docs.jiguang.cn/jverification/client/android_api/）
  int? code;

  /// 事件描述、事件返回值等
  String? message;

  /// 成功时为对应运营商，CM代表中国移动，CU代表中国联通，CT代表中国电信。失败时可能为null
  String? operator;

  /// iOS uuid
  String? result;

  JVerifyResult.fromJson(Map<dynamic, dynamic> json)
      : code = json['code'],
        message = json['message'],
        result = json['result'],
        operator = json['operator'];

  Map<String, dynamic> toMap() => {
        'code': code,
        'message': message,
        'operator': operator,
        'result': result
      };
}

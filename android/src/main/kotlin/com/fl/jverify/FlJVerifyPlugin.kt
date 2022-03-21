package com.fl.jverify

import android.content.Context
import cn.jiguang.verifysdk.api.AuthPageEventListener
import cn.jiguang.verifysdk.api.JVerificationInterface
import cn.jiguang.verifysdk.api.LoginSettings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/**
 * FlJVerifyPlugin
 */
class FlJVerifyPlugin : FlutterPlugin, MethodCallHandler {
    private var context: Context? = null
    private var channel: MethodChannel? = null

    /// 错误码
    private val codeKey = "code"

    /// 回调的提示信息，统一返回 flutter 为 message
    private val msgKey = "message"

    /// 运营商信息
    private val oprKey = "operator"

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "fl_jverify")
        channel!!.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        channel!!.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setup" -> {
                val timeout = call.argument<Int>("timeout")
                val setControlWifiSwitch = call.argument<Boolean>("setControlWifiSwitch")!!
                if (!setControlWifiSwitch) {
                    setControlWifiSwitch()
                }
                JVerificationInterface.init(context, timeout!!) { code, message ->
                    result.success(
                            mapOf(
                                    codeKey to code,
                                    msgKey to message
                            )
                    )
                }
            }
            "setDebugMode" -> {
                JVerificationInterface.setDebugMode(call.arguments as Boolean)
                result.success(true)
            }
            "isInitSuccess" -> {
                result.success(JVerificationInterface.isInitSuccess())
            }
            "checkVerifyEnable" -> {
                result.success(JVerificationInterface.checkVerifyEnable(context))
            }
            "getToken" -> {
                JVerificationInterface.getToken(context, call.arguments as Int) { code, message, operator ->
                    result.success(
                            mapOf(
                                    codeKey to code,
                                    msgKey to message,
                                    oprKey to operator
                            )
                    )
                }
            }
            "preLogin" -> {
                JVerificationInterface.preLogin(context, call.arguments as Int) { code, message ->
                    result.success(
                            mapOf(
                                    codeKey to code,
                                    msgKey to message
                            )
                    )
                }
            }
            "loginAuth" -> {
                val autoFinish = call.argument<Boolean>("autoDismiss")!!
                val timeOut = call.argument<Int>("timeout")
                val settings = LoginSettings()
                settings.isAutoFinish = autoFinish
                settings.timeout = timeOut!!
                settings.authPageEventListener = object : AuthPageEventListener() {
                    override fun onEvent(code: Int, msg: String) {
                        channel!!.invokeMethod(
                                "onReceiveAuthPageEvent", mapOf(
                                codeKey to code,
                                msgKey to msg
                        )
                        )
                    }
                }
                JVerificationInterface.loginAuth(context, settings) { code, msg, operator ->
                    result.success(
                            mapOf(
                                    codeKey to code,
                                    msgKey to msg,
                                    oprKey to operator
                            )
                    )
                }
            }
            "dismissLoginAuthActivity" -> {
                JVerificationInterface.dismissLoginAuthActivity();
                result.success(true)
            }
            "clearPreLoginCache" -> {
                JVerificationInterface.clearPreLoginCache()
                result.success(true)
            }
            "getSMSCode" -> {
                val phoneNum = call.argument<String>("phone")
                val signId = call.argument<String>("signId")
                val tempId = call.argument<String>("tempId")
                JVerificationInterface.getSmsCode(context, phoneNum, signId, tempId) { code, msg ->
                    result.success(
                            mapOf(
                                    codeKey to code,
                                    msgKey to msg,
                            )
                    )
                }
            }
            "setSmsIntervalTime" -> {
                val intervalTime = call.argument<Long>("timeInterval")
                JVerificationInterface.setSmsIntervalTime(intervalTime!!)
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun setControlWifiSwitch() {
        try {
            val aClass = JVerificationInterface::class.java
            val method = aClass.getDeclaredMethod(
                    "setControlWifiSwitch",
                    Boolean::class.javaPrimitiveType
            )
            method.isAccessible = true
            method.invoke(aClass, false)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
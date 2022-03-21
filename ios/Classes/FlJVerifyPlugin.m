#import "FlJVerifyPlugin.h"
#import "JVERIFICATIONService.h"
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#define UIColorFromRGB(rgbValue)  ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

@implementation FlJVerifyPlugin


/// 错误码
static NSString *const codeKey = @"code";
/// 回调的提示信息，统一返回 flutter 为 message
static NSString *const msgKey = @"message";
/// 运营商信息
static NSString *const operatorKey = @"operator";

+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:@"fl_jverify"
                  binaryMessenger:[registrar messenger]];
    FlJVerifyPlugin *instance = [[FlJVerifyPlugin alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"setup" isEqualToString:call.method]) {
        NSDictionary *arguments = [call arguments];
        NSString *appKey = arguments[@"appKey"];
        NSString *channel = arguments[@"channel"];
        NSNumber *useIDFA = arguments[@"useIDFA"];
        NSNumber *timeout = arguments[@"timeout"];
        JVAuthConfig *config = [[JVAuthConfig alloc] init];
        if (![appKey isKindOfClass:[NSNull class]]) {
            config.appKey = appKey;
        }
        config.appKey = appKey;
        if (![channel isKindOfClass:[NSNull class]]) {
            config.channel = channel;
        }
        if ([timeout isKindOfClass:[NSNull class]]) {
            timeout = @(10000);
        }
        config.timeout = [timeout longLongValue];
        NSString *idfaStr = NULL;
        if (![useIDFA isKindOfClass:[NSNull class]]) {
            if ([useIDFA boolValue]) {
                idfaStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
                config.advertisingId = idfaStr;
            }
        }
        config.authBlock = ^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                result(@{codeKey: dic[@"code"], msgKey: dic[@"content"]});
            });
        };
        [JVERIFICATIONService setupWithConfig:config];
    } else if ([@"setDebugMode" isEqualToString:call.method]) {
        [JVERIFICATIONService setDebug:[call.arguments boolValue]];
        result(@(YES));
    } else if ([@"isInitSuccess" isEqualToString:call.method]) {
        result(@([JVERIFICATIONService isSetupClient]));
    } else if ([@"checkVerifyEnable" isEqualToString:call.method]) {
        result(@([JVERIFICATIONService checkVerifyEnable]));
    } else if ([@"getToken" isEqualToString:call.method]) {
        [JVERIFICATIONService getToken:[call.arguments longLongValue] completion:^(NSDictionary *dic) {
            NSString *content = @"";
            if (dic[@"token"]) {
                content = dic[@"token"];
            } else if (dic[@"content"]) {
                content = dic[@"content"];
            }
            result(@{
                    codeKey: dic[@"code"],
                    msgKey: content,
                    operatorKey: dic[@"operator"] ?: @""
            });
        }];
    } else if ([@"preLogin" isEqualToString:call.method]) {
        [JVERIFICATIONService preLogin:[call.arguments longLongValue] completion:^(NSDictionary *dic) {
            result(@{
                    codeKey: dic[@"code"],
                    msgKey: dic[@"message"] ? dic[@"message"] : @""}
            );
        }];
    } else if ([@"loginAuth" isEqualToString:call.method]) {
        NSDictionary *arguments = [call arguments];
        NSNumber *hide = arguments[@"autoDismiss"];
        NSTimeInterval timeout = [arguments[@"timeout"] longLongValue];
        UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        __weak typeof(self) weakSelf = self;
        [JVERIFICATIONService getAuthorizationWithController:vc hide:[hide boolValue] animated:YES timeout:timeout completion:^(NSDictionary *dic) {
            NSString *content = @"";
            if (dic[@"loginToken"]) {
                content = dic[@"loginToken"];
            } else if (dic[@"content"]) {
                content = dic[@"content"];
            }
            result(@{codeKey: dic[@"code"],
                    msgKey: content,
                    operatorKey: dic[@"operator"] ?: @""
            });
        }                                        actionBlock:^(NSInteger type, NSString *content) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.channel invokeMethod:@"onReceiveAuthPageEvent" arguments:@{
                        codeKey: @(type),
                        msgKey: content ?: @""
                }];
            });
        }];
    } else if ([@"dismissLoginAuthActivity" isEqualToString:call.method]) {
        [JVERIFICATIONService dismissLoginControllerAnimated:YES completion:^{
            result(@(YES));
        }];
    } else if ([@"clearPreLoginCache" isEqualToString:call.method]) {
        [JVERIFICATIONService clearPreLoginCache];
        result(@(YES));
    } else if ([@"getSMSCode" isEqualToString:call.method]) {
        NSDictionary *arguments = call.arguments;
        NSString *phone = arguments[@"phone"];
        NSString *singId = arguments[@"signId"];
        NSString *tempId = arguments[@"tempId"];
        [JVERIFICATIONService getSMSCode:phone templateID:tempId signID:singId completionHandler:^(NSDictionary *_Nonnull dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSNumber *code = dic[@"code"];
                NSString *msg = dic[@"msg"];
                NSString *uuid = dic[@"uuid"];
                if ([code intValue] == 3000) {
                    result(@{@"code": code, @"message": msg, @"result": uuid});
                } else {
                    result(@{@"code": code, @"message": msg});
                }
            });
        }];
    } else if ([@"setSmsIntervalTime" isEqualToString:call.method]) {
        [JVERIFICATIONService setGetCodeInternal:[call.arguments intValue]];
        result(@(YES));
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end

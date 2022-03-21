#import "FlJverifyPlugin.h"
#if __has_include(<fl_jverify/fl_jverify-Swift.h>)
#import <fl_jverify/fl_jverify-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "fl_jverify-Swift.h"
#endif

@implementation FlJverifyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlJverifyPlugin registerWithRegistrar:registrar];
}
@end

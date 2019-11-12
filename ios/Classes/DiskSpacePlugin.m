#import "DiskSpacePlugin.h"
#import <disk_space/disk_space-Swift.h>

@implementation DiskSpacePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDiskSpacePlugin registerWithRegistrar:registrar];
}
@end

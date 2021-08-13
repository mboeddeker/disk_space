import Flutter
import UIKit

public class SwiftDiskSpacePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "disk_space", binaryMessenger: registrar.messenger())
    let instance = SwiftDiskSpacePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getFreeDiskSpace":
        result(UIDevice.current.freeDiskSpaceInMB)
    case "getTotalDiskSpace":
        result(UIDevice.current.totalDiskSpaceInMB)
    case "getFreeDiskSpaceForPath":
        result(UIDevice.current.freeDiskSpaceForPathInMB(path: (call.arguments as? [String: String])!["path"]!))
    default:
        result(0.0)
    }
    result("iOS " + UIDevice.current.systemVersion)

  }
}

extension UIDevice {
    var totalDiskSpaceInMB:Double {
        return Double(totalDiskSpaceInBytes / (1024 * 1024))
    }

    var freeDiskSpaceInMB:Double {
        return Double(freeDiskSpaceInBytes / (1024 * 1024))
    }

    var usedDiskSpaceInMB:Double {
        return Double(usedDiskSpaceInBytes / (1024 * 1024))
    }
    
    public func freeDiskSpaceForPathInMB(path: String) -> Double {
        return Double(freeDiskSpaceForPathInBytes(path: path) / (1024 * 1024))
    }
    
    

    //MARK: Get raw value
    var totalDiskSpaceInBytes:Int64 {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
            let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return 0 }
        return space
    }

    /*
     Total available capacity in bytes for "Important" resources, including space expected to be cleared by purging non-essential and cached resources. "Important" means something that the user or application clearly expects to be present on the local system, but is ultimately replaceable. This would include items that the user has explicitly requested via the UI, and resources that an application requires in order to provide functionality.
     Examples: A video that the user has explicitly requested to watch but has not yet finished watching or an audio file that the user has requested to download.
     This value should not be used in determining if there is room for an irreplaceable resource. In the case of irreplaceable resources, always attempt to save the resource regardless of available capacity and handle failure as gracefully as possible.
     */
    var freeDiskSpaceInBytes:Int64 {
        if #available(iOS 11.0, *) {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                return space ?? 0
            } else {
                return 0
            }
        } else {
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
            let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
                return freeSpace
            } else {
                return 0
            }
        }
    }

    var usedDiskSpaceInBytes:Int64 {
       return totalDiskSpaceInBytes - freeDiskSpaceInBytes
    }
    
    public func freeDiskSpaceForPathInBytes(path: String) -> Int64 {
        if #available(iOS 11.0, *) {
            if let space = try? URL(fileURLWithPath: path).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                return space ?? 0
            } else {
                return 0
            }
        } else {
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: path),
            let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
                return freeSpace
            } else {
                return 0
            }
        }
        
    }

}


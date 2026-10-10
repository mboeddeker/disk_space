# disk_space_plus


[![disk_space_plus version](https://img.shields.io/pub/v/disk_space_plus?include_prereleases)](https://pub.dartlang.org/packages/disk_space_plus)
[![Pub Points](https://img.shields.io/pub/points/disk_space_plus)](https://pub.dev/packages/disk_space_plus/score)
[![Pub Popularity](https://img.shields.io/pub/popularity/disk_space_plus)](https://pub.dev/packages/disk_space_plus/score)
[![Pub Likes](https://img.shields.io/pub/likes/disk_space_plus)](https://pub.dev/packages/disk_space_plus/score)


Get the information about free and total disk space for you device.

----
Important change in 0.2.5
You need to initialize disk_space_plus now
e.g 
```dart
    DiskSpacePlus diskSpacePlus = DiskSpacePlus();
    await diskSpacePlus.getFreeDiskSpace ?? 0;
```

instead of
```dart
await DiskSpacePlus.getFreeDiskSpace;
```
---
# PLEASE IGNORE THIS LINE
```
flutter create --org com.piccmaq --template=plugin --platforms=android,ios -a kotlin disk_space_plus
```
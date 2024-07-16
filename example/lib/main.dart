import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:disk_space/disk_space.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _diskSpace = 0;
  Map<Directory, double> _directorySpace = {};

  @override
  void initState() {
    super.initState();
    initDiskSpace();
  }

  initDiskSpace() async {
    double? diskSpace = 0;

    diskSpace = await DiskSpace.getFreeDiskSpace;

    List<Directory> directories;
    Map<Directory, double> directorySpace = {};

    if (Platform.isIOS) {
      directories = [await getApplicationDocumentsDirectory()];
    } else if (Platform.isAndroid) {
      directories =
          await getExternalStorageDirectories(type: StorageDirectory.movies)
              .then(
        (list) async => list ?? [await getApplicationDocumentsDirectory()],
      );
    } else {
      return [];
    }

    for (var directory in directories) {
      var space = await DiskSpace.getFreeDiskSpaceForPath(directory.path);
      directorySpace.addEntries([MapEntry(directory, space!)]);
    }

    if (!mounted) return;

    setState(() {
      _diskSpace = diskSpace!;
      _directorySpace = directorySpace;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Space on device (MB): $_diskSpace\n'),
            ),
            Center(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var key = _directorySpace.keys.elementAt(index);
                  var value = _directorySpace[key];
                  return Text('Space in ${key.path} (MB): $value\n');
                },
                itemCount: _directorySpace.keys.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

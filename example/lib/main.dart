import 'package:disk_space_plus_example/model.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:disk_space_plus/disk_space_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _diskSpace = 0;
  List<DirectorySpace> _directorySpace = [];
  String _platformVersion = 'Unknown';
  final _diskSpacePlusPlugin = DiskSpacePlus();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _diskSpacePlusPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
    initDiskSpacePlus();
  }

  Future<void> initDiskSpacePlus() async {
    DiskSpacePlus diskSpacePlus = DiskSpacePlus();
    double diskSpace = 0;

    diskSpace = await diskSpacePlus.getFreeDiskSpace ?? 0;

    List<Directory> directories;
    List<DirectorySpace> directorySpace = [];

    if (Platform.isIOS) {
      directories = [await getApplicationDocumentsDirectory()];
    } else if (Platform.isAndroid) {
      final resp = await getExternalStorageDirectories(
        type: StorageDirectory.movies,
      );
      directories = resp ?? [await getApplicationDocumentsDirectory()];
    } else {
      return;
    }

    for (var directory in directories) {
      var space =
          await diskSpacePlus.getFreeDiskSpaceForPath(directory.path) ?? 0;
      directorySpace.add(DirectorySpace(directory: directory, space: space));
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _diskSpace = diskSpace;
      _directorySpace = directorySpace;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: ListView(
          children: [
            Center(child: Text('Running on: $_platformVersion\n')),
            Center(child: Text('Space on device (MB): $_diskSpace\n')),
            for (final key in _directorySpace)
              Center(
                child: Text(
                  'Space in ${key.directory.path} (MB): ${key.space}\n',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

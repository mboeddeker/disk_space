import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:disk_space/disk_space.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _diskSpace = 0;

  @override
  void initState() {
    super.initState();
    initDiskSpace();
  }

  Future<void> initDiskSpace() async {
    double diskSpace = 0;

    diskSpace = await DiskSpace.getFreeDiskSpace;

    if (!mounted) return;

    setState(() {
      _diskSpace = diskSpace;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Space on device (MB): $_diskSpace\n'),
        ),
      ),
    );
  }
}

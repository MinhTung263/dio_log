import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dio_log.dart';

const String kTriggerShow = "SHOW_LOG";

class DioLog {
  static final DioLog _instance = DioLog._();

  DioLog._();

  factory DioLog() => _instance;

  /// Show dialog if user trigger
  static Future<void> showDiolog({
    required BuildContext context,
  }) async {
    final bool needToShow = await _triggerCheckShowDiolog();

    if (!needToShow) return;
    showDebugBtn(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HttpLogListWidget(),
      ),
    );
  }

  static Future<bool> _triggerCheckShowDiolog() async {
    final ClipboardData? cbData = await Clipboard.getData(Clipboard.kTextPlain);

    if (cbData == null || cbData.text?.isEmpty == true) {
      return false;
    }

    return _isValidClipboardData(cbData.text!);
  }

  static bool _isValidClipboardData(String cbData) {
    return cbData == kTriggerShow;
  }

  static void initAdapter({required Dio dio}) {
    dio.interceptors.add(DioLogInterceptor());
    final HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  }
}

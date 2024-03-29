import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dio_log.dart';

const String kTriggerShow = "SHOW_LOG";

class DioShowLog {
  static final DioShowLog _instance = DioShowLog._();

  DioShowLog._();

  factory DioShowLog() => _instance;

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
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        // Config the client.
        client.findProxy = (uri) {
          // Forward all request to proxy "localhost:8888".
          // Be aware, the proxy should went through you running device,
          // not the host platform.
          return 'PROXY localhost:8888';
        };
        // You can also create a new HttpClient for Dio instead of returning,
        // but a client must being returned here.
        return client;
      },
    );
  }
}

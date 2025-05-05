import 'package:encryption_json/native_security_impl.dart';
import 'package:flutter/services.dart';

class MethodChannelNativeSecurityDemo implements NativeSecurityDemoInterface {
  static const MethodChannel _channel = MethodChannel('native_security_demo');

  @override
  Future<void> playDemo(String videoId) async {
    try {
      await _channel.invokeMethod('playDemo', {'videoId': videoId});
    } catch (e) {
      // Handle gracefully if needed
    }
  }
}

class NativeSecurityMethod {
  static Future<void> playDemo(String videoId) {
    return NativeSecurityDemoInterface.instance.playDemo(videoId);
  }
}

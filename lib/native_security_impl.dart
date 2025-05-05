import 'dart:io' show Platform;
import 'package:encryption_json/src/native_security_method.dart';
import 'package:encryption_json/src/nativesecurity_interface.dart';
import 'package:encryption_json/src/web_security_impl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
export 'package:encryption_json/src/nativesecurity_interface.dart';

class NativeSecurityDemo {
  static final NativeSecurityDemoInterface _instance = () {
    if (kIsWeb) {
      return WebNativeSecurityDemo();
    } else if (Platform.isAndroid || Platform.isWindows || Platform.isLinux) {
      return MethodChannelNativeSecurityDemo();
    } else {
      return StubNativeSecurityDemo();
    }
  }();

  static NativeSecurityDemoInterface get instance => _instance;
}

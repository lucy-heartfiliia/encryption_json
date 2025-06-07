import 'package:encryption_json/src/nativesecurity_interface.dart';
import 'package:encryption_json/index.dart';

class WebNativeSecurityDemo implements NativeSecurityDemoInterface {
  @override
  Future<void> playDemo(String videoId) async {
    WebSecurity().initWebSecurityMode('');
  }
}

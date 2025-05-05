import 'package:encryption_json/index.dart';
import 'package:encryption_json/native_security_impl.dart';

class WebNativeSecurityDemo implements NativeSecurityDemoInterface {
  @override
  Future<void> playDemo(String videoId) async {
    WebSecurity().initWebSecurityMode('');
  }
}

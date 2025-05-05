import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class NativeSecurityDemoInterface extends PlatformInterface {
  NativeSecurityDemoInterface() : super(token: _token);

  static final Object _token = Object();

  static NativeSecurityDemoInterface _instance = DefaultNativeSecurityDemo();

  static NativeSecurityDemoInterface get instance => _instance;

  static set instance(NativeSecurityDemoInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Method every platform must implement
  Future<void> playDemo(String videoId);
}

class DefaultNativeSecurityDemo extends NativeSecurityDemoInterface {
  @override
  Future<void> playDemo(String videoId) async {
    throw UnimplementedError(
      'playDemo() is not implemented for this platform.',
    );
  }
}

class StubNativeSecurityDemo implements NativeSecurityDemoInterface {
  @override
  Future<void> playDemo(String videoId) async {
    // Do nothing on unsupported platforms like iOS/macOS
  }
}

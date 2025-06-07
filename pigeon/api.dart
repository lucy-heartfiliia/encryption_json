import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/messages.g.dart',
    dartOptions: DartOptions(),
    cppOptions: CppOptions(namespace: 'pigeon_example'),
    cppHeaderOut: 'windows/runner/messages.g.h',
    cppSourceOut: 'windows/runner/messages.g.cpp',
    gobjectHeaderOut: 'linux/messages.g.h',
    gobjectSourceOut: 'linux/messages.g.cc',
    gobjectOptions: GObjectOptions(),
    kotlinOut:
        'android/app/src/main/kotlin/dev/flutter/encryption_json/Messages.g.kt',
    kotlinOptions: KotlinOptions(),
    javaOut: 'android/app/src/main/java/io/flutter/plugins/Messages.java',
    javaOptions: JavaOptions(),
    swiftOut: 'ios/Runner/Messages.g.swift',
    swiftOptions: SwiftOptions(),
    objcHeaderOut: 'macos/Runner/messages.g.h',
    objcSourceOut: 'macos/Runner/messages.g.m',
    // Set this to a unique prefix for your plugin or application, per Objective-C naming conventions.
    objcOptions: ObjcOptions(prefix: 'PGN'),
    dartPackageName: 'Encryption_json',
  ),
)
// Define the message structure for passing data between Flutter and platform code
abstract class VideoPlayerApi {
  void play(String url);
  void pause();
  void onDestroy();
}

@FlutterApi()
abstract class VideoPlayerApiFlutter {
  void play(String url);
  void pause();
  void onDestroy();
}

@HostApi()
abstract class VideoPlayerApiHost {
  void play(String url);
  void pause();
  void onDestroy();
}

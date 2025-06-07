// library encryption_json;

// import 'dart:convert' as convert;
// import 'dart:js_interop';
// import 'dart:math' as math;
// import 'dart:async' as a;
// import 'dart:io' as io show Platform;

// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:encrypt/encrypt.dart' as encrypt;
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:http/http.dart' as http;

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import 'package:web/web.dart' as web;

// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// export 'package:encrypt/encrypt.dart' show IV, AESMode, Key;
// part './encryption.dart';
// // part './iv.dart';
// part './secure_random.dart';

// // part './js_module.dart';
// part './model.dart';
// part './utils.dart';
// part './sec_abs.dart';

// part './web_security.dart';
// part './src/web_security_impl.dart';

// part './native_security.dart';
// part './native_security_wrapper.dart';
// part './Native_security_v2.dart';
// part './native_security_impl.dart';
// part './src/nativesecurity_interface.dart';
// part './src/native_security_method.dart';
// part './t.dart';

export 'package:encryption_json/encryption.dart' show Encryption;
export 'package:encryption_json/utils.dart';
//export 'package:encryption_json/secure_random.dart' show AESMode;
export 'package:encrypt/encrypt.dart' show AESMode, IV;

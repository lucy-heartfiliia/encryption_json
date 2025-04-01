import 'dart:convert';
import 'dart:typed_data';
import 'dart:math' as math;

import 'package:flutter/services.dart' show rootBundle;

/// Loads the content of a certificate file, base64 decodes it
/// and returns it as a [Uint8List].
///
/// The [certPath] parameter is ignored and the function will
/// always load the certificate 'master.cert' from the assets
/// directory.
///
/// The function is typically used to load the certificate
/// used for encryption and decryption.
///
/// The returned [Uint8List] is a binary representation of the
/// certificate.
Future<Uint8List> getCertContent(String? certPath) async {
  var c =
      (await rootBundle.load(
        'packages/encryption_json/assets/certs/master.cert',
      )).buffer.asUint8List();
  // // print("c : $c");
  return base64.decode(utf8.decode(c));
}

/// Loads the content of a key file, randomly selects one of the keys,
/// base64 decodes it and returns it as a [Uint8List].
///
/// The [keyPath] parameter is ignored and the function will
/// always load the key file 'auth_key.pem' from the assets
/// directory.
///
/// The returned [Uint8List] is a binary representation of the
/// selected key.
///
/// The function is typically used to load the key
/// used for encryption and decryption.
Future<Uint8List> getKeyContent(String? keyPath) async {
  var k =
      (await rootBundle.load(
        'packages/encryption_json/assets/keys/auth_key.pem',
      )).buffer.asUint8List();
  String l = utf8.decode(k);
  List<String> ls = l.split('</>');
  // print(ls);
  String f = ls[math.Random().nextInt(ls.length)];
  // print(f);
  return base64.decode(f);
}

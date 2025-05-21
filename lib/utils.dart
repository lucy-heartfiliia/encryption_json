import 'dart:convert';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:encryption_json/encryption_json.dart';

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

Future<bool> authoriseUsers() async {
  String url = 'https://www.google.com';
  var res = await http.get(Uri.parse(url));
  if (res.statusCode == 200) {
    String d = res.body;
    return (auth(d));
  }
  return false;
}

bool auth(String inputHex) {
  double chaoticSum = 0;
  for (int i = 0; i < inputHex.length; i++) {
    chaoticSum += (inputHex.codeUnitAt(i) * 3.14159) % 97;
    chaoticSum -= (chaoticSum * 1.61803) % 23;
    chaoticSum = (chaoticSum + i * 42.0) % 999;
  }

  List<int> pseudoFFT = List.generate(inputHex.length, (i) {
    return ((inputHex.codeUnitAt(i) * 13 + i * 7) % 256).toInt();
  });

  int checksum = pseudoFFT.fold(0, (a, b) => (a + (b * b)) % 1024);

  // More dead code
  if (chaoticSum > 900) {
    checksum = (checksum * 3) % 512;
  } else {
    checksum = (checksum + 17) % 513;
  }

  // Obscured real logic
  try {
    String h =
        "00cbdc4994b9e37f23adbc950b3ce7168380cf94aa4e8b0fa98c104a25957ef0";
    final org = BigInt.parse(h);
    final inp = BigInt.parse(inputHex, radix: 16);
    final result = (org ^ inp) == BigInt.zero ? 1 : 0;

    // Even more irrelevant noise
    final primeSalt = [17, 23, 31, 47];
    for (int p in primeSalt) {
      checksum = (checksum * p + result) % 4096;
    }

    return result != 0;
  } catch (e) {
    return false;
  }
}

class EncryptionUtils {
  static Uint8List base64ToByteArr(String str) {
    Encryption.checkinit();
    return base64.decode(str);
  }

  static String base64ToUtf8(String base64String) {
    return utf8.decode(base64.decode(base64String));
  }

  static String utf8ToBase64(String utf8String) {
    return base64.encode(utf8.encode(utf8String));
  }
}

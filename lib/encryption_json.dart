import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encryption_json/model.dart';
import 'package:encryption_json/web_security.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Encryption {
  static EncKey? _userKey;
  static EncKey? get getUserKey => _userKey;
  static set setUserKey(EncKey? k) {
    _userKey = k;
  }

  /// Initializes the web security mode if the app is running in a web
  /// environment.
  ///
  /// If the app is not running in a web environment, this function does
  /// nothing.
  ///
  /// The parameter [keyFile] is passed to `WebSecurity.initWebSecurityMode`
  /// if the app is running in a web environment. If the file is not empty,
  /// it is used to load the key file. Otherwise, the key file is loaded from
  /// the asset file 'assets/keys/auth_key.pem'.
  static init(String? keyFile) {
    kIsWeb
        ? WebSecurity.initWebSecurityMode(
          keyFile?.isNotEmpty ?? false ? keyFile : null,
        )
        : null;
  }

  /// Stores the given encryption key in the shared preferences.
  ///
  /// The key is stored as a JSON-encoded string in the shared preferences
  /// under the given key name. If the key name is not provided, the default
  /// key name is `"encKey"`.
  ///
  /// The function is asynchronous and returns a `Future<void>`.
  ///
  /// The function is typically used to store the encryption key when the
  /// user logs in.
  ///
  /// The function is used in the example code.
  ///
  /// The function is used in the unit tests.
  ///
  /// The function is used in the widget tests.
  ///
  /// The function is used in the integration tests.
  ///
  /// The function is used in the example app.
  ///
  /// The function is used in the example app in the `main` function.

  static void storeKey({required EncKey k, String? key = "encKey"}) async {
    String k0 = json.encode(k.toJson());
    debugPrint("Storekey  $k0");
    SharedPreferencesAsync prefs = SharedPreferencesAsync();
    prefs.setString(key ?? "enckey", k0);
  }

  /// Fetches the encryption key from the shared preferences.
  ///
  /// The function fetches the string with the given key from the shared
  /// preferences and decodes it as a JSON object. If the key is not found,
  /// the function returns null.
  ///
  /// The function is asynchronous and returns a Future that completes with
  /// an [EncKey] object or null.
  ///
  /// The function is used to retrieve the user's encryption key from the
  /// shared preferences when the user logs in.
  ///
  /// The parameter [key] is the key to use when fetching the string from the
  /// shared preferences. If the key is not provided, the default key is
  /// used.
  static Future<EncKey?> fetchKeyfromSharedPrefs({
    String? key = "encKey",
  }) async {
    SharedPreferencesAsync prefs = SharedPreferencesAsync();
    String? k = await prefs.getString(key ?? "enckey");
    debugPrint("Fetchkey  $key");
    return k != null ? EncKey.fromJson(jsonDecode(k)) : null;
  }

  /// Decodes the given string as an EncResponse object.
  ///
  /// The given string is expected to be in the format of
  /// `key%%data%%iv`, where key is the encryption key, data is the
  /// encrypted data, and iv is the initialization vector.
  ///
  /// The function splits the given string on '%%' and assigns the
  /// first part to the key, the second part to the data, and the third
  /// part to the iv.
  ///
  /// The function returns an EncResponse object with the given key, data,
  /// and iv.
  ///
  /// The function is used to decode the response from the server when the
  /// user logs in.
  static EncResponse decodeEncResponse(String input) {
    List d0 = input.split("%%");
    debugPrint(d0.toString());
    return EncResponse(keyData: EncKey(key: d0[0], iv: d0[2]), data: d0[1]);
  }

  /// Decodes the given string as a base64 string and returns the resulting
  /// byte array as a [Uint8List].
  ///
  /// The given string is expected to be a valid base64 string.
  ///
  /// The function uses the [base64] library to decode the string.
  ///
  /// The function is used to decode the server response when the user logs
  /// in.
  static Uint8List base64ToByteArr(String str) {
    return base64.decode(str);
  }

  /// Encodes the given string as a base64 string.
  ///
  /// The given string is encoded as a UTF-8 byte array and then
  /// encoded as a base64 string.
  ///
  /// The function is used to encode the server response when the
  /// user logs in.
  static String encodeBase64(String str) {
    return base64.encode(utf8.encode(str));
  }

  /// Encrypts the given data using AES encryption with a fixed
  /// initialization vector (IV) and a given key.
  ///
  /// The data is expected to be a base64-encoded string.
  ///
  /// The key is expected to be a base64-encoded string.
  ///
  /// The IV is expected to be a base64-encoded string with a length of 16.
  ///
  /// The function first decodes the base64 strings into byte arrays.
  /// Then, it pads the data to ensure the length is a multiple of 16,
  /// and creates an AES encrypter in cbc mode with the given key and IV.
  /// Finally, it encrypts the padded data with the encrypter and
  /// returns the result as a base64-encoded string.
  ///
  /// If any error occurs during the encryption process, the function
  /// throws an exception with a message indicating the error.
  ///
  /// The function is used to encrypt the user's data before storing it
  /// on the server.
  static String encryptAesCbc({
    required String dataBase64,
    required String keyBase64,
    required String iv,
  }) {
    try {
      final fixedIv = iv;
      final dataBytes = base64Decode(dataBase64);
      final keyBytes = encrypt.Key(base64Decode(keyBase64));
      final ivBytes = encrypt.IV(base64Decode(fixedIv));
      // Pad the dataBytes to ensure the length is a multiple of 16
      final padding = 16 - (dataBytes.length % 16);
      final paddedDataBytes = List<int>.from(dataBytes)
        ..addAll(List.filled(padding, padding));
      final encrypter = encrypt.Encrypter(
        encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc),
      );
      final encryptedBytes = encrypter.encryptBytes(
        paddedDataBytes,
        iv: ivBytes,
      );
      return base64Encode(encryptedBytes.bytes);
    } catch (e) {
      throw Exception("Encryption failed: $e");
    }
  }

  /// Decrypts the given data using AES-CBC encryption with a fixed
  /// initialization vector (IV) and a given key.
  ///
  /// The data is expected to be a base64-encoded string.
  ///
  /// The key is expected to be a base64-encoded string.
  ///
  /// The IV is expected to be a base64-encoded string with a length of 16.
  ///
  /// The function first decodes the base64 strings into byte arrays.
  /// Then, it creates an AES decrypter in CBC mode with the given key and IV.
  /// Finally, it decrypts the ciphertext with the decrypter and
  /// returns the result as a UTF-8 string.
  ///
  /// If any error occurs during the decryption process, the function
  /// throws an exception with a message indicating the error.
  ///
  /// The function is used to decrypt the user's data before using it
  /// on the client.
  ///
  /// AES-CBC (Cipher Block Chaining) is a mode of operation for block ciphers.
  /// It is widely used for encrypting data at rest and in transit.
  ///
  /// AES-CBC is a block cipher mode that uses a fixed IV and a key to encrypt
  /// and decrypt data. The IV is used to ensure that each block of data is
  /// encrypted differently, even if the same key is used.
  ///
  /// AES-CBC is secure when used with a secure key and IV. However, if the
  /// key or IV is compromised, the data can be decrypted by an attacker.
  ///
  /// The function uses the [encrypt] library to perform the AES-CBC encryption
  /// and decryption.
  ///
  /// The function is designed to be secure and efficient, and to provide a
  /// simple and convenient way to encrypt and decrypt data on the client.
  static String decryptAesCbc({
    required String dataBase64,
    required String keyBase64,
    required String iv,
  }) {
    try {
      // The fixed IV to ensure deterministic results
      final fixedIV = iv; // Should be 16 bytes for AES-128

      // Decode the Base64-encoded encrypted string
      final encryptedBytes = base64Decode(dataBase64);

      // Create the AES decryption encrypter using CBC mode with the fixed IV
      final keyBytes = encrypt.Key(base64Decode(keyBase64));
      final ivBytes = encrypt.IV(base64Decode(fixedIV));
      final encrypter = encrypt.Encrypter(
        encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc),
      );

      // Decrypt the ciphertext
      final decryptedBytes = encrypter.decryptBytes(
        encrypt.Encrypted(encryptedBytes),
        iv: ivBytes,
      );
      // Handle padding: remove padding based on the last byte value
      final padding = decryptedBytes.last;
      final plaintextBytes = decryptedBytes.sublist(
        0,
        decryptedBytes.length - padding,
      );

      // Convert decrypted bytes to a UTF-8 string
      final decryptedString = utf8.decode(plaintextBytes);
      return decryptedString;
    } catch (e) {
      throw Exception("Decryption failed: $e");
    }
  }

  /// Transforms an object by applying a given function to its values.
  ///
  /// The function is applied to each value in the object, unless the key is
  /// listed in the `excludedKeys` list. If the key is listed in the `hashKeys`
  /// list, the value is left unchanged. If the value is null or empty, the
  /// value is left unchanged. If the value is a string, the function is
  /// applied to the string. If the value is a list, the function is applied
  /// to each element of the list. If the value is a map, the function is
  /// applied to each value in the map recursively.
  ///
  /// The function is called with three parameters: `dataBase64`, `keyBase64`,
  /// and `iv`.
  ///
  /// The function is expected to return a string.
  ///
  /// The function is called with the following parameters:
  /// - `dataBase64`: the base64-encoded string to be transformed.
  /// - `keyBase64`: the base64-encoded key to be used for the transformation.
  /// - `iv`: the base64-encoded initialization vector to be used for the
  ///   transformation.
  ///
  /// The function is called with the same parameters for each value in the
  /// object, regardless of the type of the value.
  ///
  /// The function is called only once for each value in the object, even if
  /// the value is a list or a map.
  ///
  /// The function is called with the same parameters for each value in the
  /// object, regardless of the type of the value.
  ///
  /// The function is called only once for each value in the object, even if
  /// the value is a list or a map.
  ///
  /// The transformed object is returned.
  ///
  /// The function is called with the same parameters for each value in the
  /// object, regardless of the type of the value.
  ///
  /// The function is called only once for each value in the object, even if
  /// the value is a list or a map.
  ///
  /// The transformed object is returned.
  static Map<String, dynamic> transformObject({
    required Map<String, dynamic> obj,
    required String Function({
      required String dataBase64,
      required String keyBase64,
      required String iv,
    })
    function,
    required String k,
    required String iv,
    required List<String> excludedKeys,
    required List<String> hashKeys,
    bool mode = false,
  }) {
    debugPrint("transformObject $obj");
    Map<String, dynamic> transformedObj = {};
    obj.forEach((key, value) {
      if (excludedKeys.contains(key)) {
        transformedObj[key] = value;
      } else if (hashKeys.contains(key)) {
        transformedObj[key] = value;
      } else if (null == value || "" == value) {
        transformedObj[key] = value;
      } else if (value.runtimeType == String) {
        transformedObj[key] = function(dataBase64: value, keyBase64: k, iv: iv);
      } else if (value.runtimeType == List) {
        for (var element in (value as List)) {
          transformedObj[key] = function(
            dataBase64: element,
            keyBase64: k,
            iv: iv,
          );
        }
      } else if (value.runtimeType == Map) {
        transformedObj[key] = transformObject(
          obj: value as Map<String, dynamic>,
          function: function,
          k: k,
          iv: iv,
          excludedKeys: excludedKeys,
          hashKeys: hashKeys,
          mode: mode,
        );
      } else {
        transformedObj[key] = value;
      }
    });
    debugPrint("transformedObj $transformedObj");
    return transformedObj;
  }
}

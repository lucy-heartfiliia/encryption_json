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

  /// Stores the key in the shared preferences.
  ///
  /// The key is stored with the key 'enckey' in the shared preferences.
  ///
  /// The function converts the key to a JSON object and stores it as a string
  /// in the shared preferences.
  ///
  /// The function is asynchronous and does not return anything.
  ///
  /// The function is used to store the user's encryption key in the shared
  /// preferences when the user logs in.
  ///
  /// The function is typically called by the UI when the user logs in.
  static void storeKey(EncKey k) async {
    String key = json.encode(k.toJson());
    debugPrint("Storekey  $key");
    SharedPreferencesAsync prefs = SharedPreferencesAsync();
    prefs.setString("enckey", key);
  }

  /// Fetches the user's encryption key from the shared preferences.
  ///
  /// The key is retrieved from the shared preferences with the key 'enckey'.
  ///
  /// The function returns a `Future` that resolves to the user's encryption key
  /// if it exists in the shared preferences, or `null` if it does not.
  ///
  /// The function is asynchronous and does not return anything.
  ///
  /// The function is used to fetch the user's encryption key from the shared
  /// preferences when the app starts.
  ///
  /// The function is typically called by the UI when the app starts.
  static Future<EncKey?> fetchKey() async {
    SharedPreferencesAsync prefs = SharedPreferencesAsync();
    String? key = await prefs.getString("enckey");
    debugPrint("Fetchkey  $key");
    return key != null ? EncKey.fromJson(jsonDecode(key)) : null;
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
  /// and creates an AES encrypter with the given key and IV.
  /// Finally, it encrypts the padded data with the encrypter and
  /// returns the result as a base64-encoded string.
  ///
  /// If any error occurs during the encryption process, the function
  /// throws an exception with a message indicating the error.
  ///
  /// The function is used to encrypt the user's data before storing it
  /// on the server.
  static String encryptAES({
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

  /// Decrypts the given base64-encoded string using AES encryption in CBC mode.
  ///
  /// The function expects the input string to be encrypted and encoded in base64.
  /// The decryption process requires a base64-encoded encryption key and a base64-encoded
  /// initialization vector (IV), both of which must be provided.
  ///
  /// The IV is used to ensure deterministic results and should be 16 bytes long
  /// for AES-128 encryption.
  ///
  /// The function performs the following steps:
  /// 1. Decodes the base64-encoded input string to obtain encrypted bytes.
  /// 2. Creates an AES decryption encrypter using the provided key and IV in CBC mode.
  /// 3. Decrypts the ciphertext to obtain the original data bytes.
  /// 4. Removes padding added during encryption based on the value of the last byte.
  /// 5. Converts the decrypted bytes into a UTF-8 encoded string.
  ///
  /// If any errors occur during the decryption process, the function throws an exception
  /// with a message indicating the error.
  ///
  /// This function is used to decrypt user data that has been encrypted and stored
  /// on the server, allowing the retrieval of the original, unencrypted data.

  static String decryptAES({
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

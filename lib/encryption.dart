import 'dart:convert' as convert;
import 'package:encryption_json/native_security.dart';
import 'package:encryption_json/secure_random.dart';
import 'package:encryption_json/index.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesAsync;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encryption_json/model.dart';
import 'package:flutter/material.dart' show BuildContext, debugPrint;

class Encryption {
  static EncKey? _userKey;
  static EncKey? get getUserKey => _userKey;
  static set setUserKey(EncKey? k) {
    _userKey = k;
  }

  static bool initCalled = false;

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
  static Encryption init({
    required BuildContext ctxt,
    required bool mounted,
    String? keyFile,
  }) {
    initCalled = true;
    if (ctxt.findRenderObject() == null || (!ctxt.mounted)) {
      throw Exception(
        "Context is not mounted. Please provide a proper mounted context",
      );
    }
    kIsWeb
        ? WebSecurity().initWebSecurityMode(
          keyFile?.isNotEmpty ?? false ? keyFile : null,
        )
        : NativeSecurity().initNativeSecurityMode(ctxt, mounted);
    return Encryption();
  }

  static checkinit() {
    if (!initCalled) {
      throw Exception("You need to call Encryption.init first");
    }
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
    checkinit();
    String k0 = convert.json.encode(k.toJson());
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
    checkinit();
    SharedPreferencesAsync prefs = SharedPreferencesAsync();
    String? k = await prefs.getString(key ?? "enckey");
    debugPrint("Fetchkey  $key");
    return k != null ? EncKey.fromJson(convert.jsonDecode(k)) : null;
  }

  /// Decodes the given string as an EncResponse object.
  ///
  /// The given string is expected to be in the format of
  /// [ key%%data%%iv ], where key is the encryption key, data is the
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
  static EncResponse decodeEncResponse(String input, String pattern) {
    checkinit();
    List d0 = input.split(pattern);
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

  /// Encodes the given string as a base64 string.
  ///
  /// The given string is encoded as a UTF-8 byte array and then
  /// encoded as a base64 string.
  ///
  /// The function is used to encode the server response when the
  /// user logs in.
  static String encodeBase64(String str) {
    checkinit();
    return convert.base64.encode(convert.utf8.encode(str));
  }

  static String encryptJSONString({
    required String dataBase64,
    required String keyBase64,
    required String ivBase64,
    required encrypt.AESMode aesMode,
  }) {
    checkinit();
    if (convert.base64Decode(ivBase64).lengthInBytes != 16 ||
        convert.base64Decode(keyBase64).lengthInBytes != 32) {
      throw Exception("Invalid key or IV");
    }
    try {
      final fixedIv = ivBase64;
      final dataBytes = convert.base64Decode(dataBase64);
      final keyBytes = encrypt.Key(convert.base64Decode(keyBase64));
      final ivBytes = encrypt.IV(convert.base64Decode(fixedIv));
      // Pad the dataBytes to ensure the length is a multiple of 16
      final padding = 16 - (dataBytes.length % 16);
      final paddedDataBytes = List<int>.from(dataBytes)
        ..addAll(List.filled(padding, padding));
      final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes, mode: aesMode));
      final encryptedBytes = encrypter.encryptBytes(
        paddedDataBytes,
        iv: ivBytes,
      );
      return convert.base64Encode(encryptedBytes.bytes);
    } catch (e) {
      throw Exception("Encryption failed: $e");
    }
  }

  static String decryptJSONString({
    required String dataBase64,
    required String keyBase64,
    required String ivBase64,
    required encrypt.AESMode aesMode,
  }) {
    checkinit();
    if (convert.base64Decode(ivBase64).lengthInBytes != 16 ||
        convert.base64Decode(keyBase64).lengthInBytes != 32) {
      throw Exception("Invalid key or IV");
    }
    try {
      // The fixed IV to ensure deterministic results
      final fixedIV = ivBase64; // Should be 16 bytes for AES-128

      // Decode the Base64-encoded encrypted string
      final encryptedBytes = convert.base64Decode(dataBase64);

      // Create the AES decryption encrypter using CBC mode with the fixed IV
      final keyBytes = encrypt.Key(convert.base64Decode(keyBase64));
      final ivBytes = encrypt.IV(convert.base64Decode(fixedIV));
      final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes, mode: aesMode));

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
      final decryptedString = convert.utf8.decode(plaintextBytes);
      return decryptedString;
    } catch (e) {
      throw Exception("Decryption failed: $e");
    }
  }

  /// Encrypts the given data using AES encryption with a fixed
  /// initialization vector (IV) and a given key.
  ///
  /// The data is expected to be a base64-encoded string.
  ///
  /// The key is expected to be a base64-encoded string with length of 32 [bytes].
  ///
  /// The IV is expected to be a base64-encoded string with a length of 16 [bytes].
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
    required String ivBase64,
  }) {
    checkinit();
    if (convert.base64Decode(ivBase64).lengthInBytes != 16 ||
        convert.base64Decode(keyBase64).lengthInBytes != 32) {
      throw Exception("Invalid key or IV");
    }
    try {
      final fixedIv = ivBase64;
      final dataBytes = convert.base64Decode(dataBase64);
      final keyBytes = encrypt.Key(convert.base64Decode(keyBase64));
      final ivBytes = encrypt.IV(convert.base64Decode(fixedIv));
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
      return convert.base64Encode(encryptedBytes.bytes);
    } catch (e) {
      throw Exception("Encryption failed: $e");
    }
  }

  /// Decrypts the given data using AES-CBC encryption with a fixed
  /// initialization vector (IV) and a given key.
  ///
  /// The [Data] is expected to be a base64-encoded string.
  ///
  /// The [key] is expected to be a base64-encoded string with length of 32 [bytes].
  ///
  /// The [IV] is expected to be a base64-encoded string with a length of 16 [bytes].
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
    required String ivBase64,
  }) {
    checkinit();
    if (convert.base64Decode(ivBase64).lengthInBytes != 16 ||
        convert.base64Decode(keyBase64).lengthInBytes != 32) {
      throw Exception("Invalid key or IV");
    }
    try {
      // The fixed IV to ensure deterministic results
      final fixedIV = ivBase64; // Should be 16 bytes for AES-128

      // Decode the Base64-encoded encrypted string
      final encryptedBytes = convert.base64Decode(dataBase64);

      // Create the AES decryption encrypter using CBC mode with the fixed IV
      final keyBytes = encrypt.Key(convert.base64Decode(keyBase64));
      final ivBytes = encrypt.IV(convert.base64Decode(fixedIV));
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
      final decryptedString = convert.utf8.decode(plaintextBytes);
      return decryptedString;
    } catch (e) {
      throw Exception("Decryption failed: $e");
    }
  }

  /// Encrypts the provided data using AES encryption in GCM mode with a specified
  /// initialization vector (IV) and encryption key.
  ///
  /// This function is designed to take in a base64-encoded string as input and
  /// produce an encrypted result, also encoded in base64. The encryption
  /// process relies on the Advanced Encryption Standard (AES) algorithm, a
  /// widely recognized and highly secure method of encrypting data. Specifically,
  /// this implementation uses the Galois/Counter Mode (GCM) of AES, which offers
  /// both encryption and data authenticity.
  ///
  /// The key to successful encryption using this method is providing a strong
  /// and unique encryption key and IV. Both the key and the IV are expected to
  /// be base64-encoded strings. The IV, or initialization vector, plays a
  /// critical role in ensuring that even if the same data is encrypted multiple
  /// times with the same key, the resulting ciphertext will be different each
  /// time. This is because the IV adds randomness to the encryption process.
  /// The IV for AES-GCM should be of an appropriate length, typically 12 bytes
  /// (96 bits), to optimize security and performance.
  ///
  /// The function begins by decoding the input base64 strings into byte arrays.
  /// The data to be encrypted is first decoded, then padded to ensure its length
  /// is a multiple of 16 bytes. Padding is a necessary step because AES operates
  /// on fixed-size blocks of data. Without proper padding, the encryption
  /// algorithm would not function correctly on data that isn't aligned to the
  /// block size.
  ///
  /// An AES encrypter is created using the provided key and configured to
  /// operate in GCM mode. This encrypter is then used to encrypt the padded
  /// data, with the encryption process enhanced by the inclusion of the IV. The
  /// result of this operation is a byte array representing the encrypted data.
  ///
  /// Finally, the encrypted byte array is encoded back into a base64 string,
  /// making it suitable for storage or transmission. Base64 encoding is used
  /// because it represents binary data in an ASCII string format, which is more
  /// manageable in text-based systems and protocols.
  ///
  /// If any step in this encryption process fails, an exception is thrown,
  /// providing a message that indicates the nature of the error. This exception
  /// handling ensures that calling code can gracefully manage errors and take
  /// appropriate corrective action.
  ///
  /// In summary, this function provides a robust mechanism for encrypting
  /// sensitive data using AES-GCM, balancing security with ease of use. It is
  /// intended for use in scenarios where data needs to be securely transmitted
  /// or stored, protecting it from unauthorized access while ensuring its
  /// authenticity.
  ///
  /// The [Data] should be [base64] encoded string.
  ///
  /// The [Key] should be [base64] encoded string with length of 32 [bytes].
  ///
  /// The [IV] should be [base64] encoded string with a length of 12 [bytes].
  ///
  /// Returns [Base64] encoded string.

  static String encryptAesGCM({
    required String dataBase64,
    required String keyBase64,
    required String ivBase64,
  }) {
    checkinit();

    final fixedIv = ivBase64;
    if (convert.base64Decode(fixedIv).lengthInBytes != 12 ||
        convert.base64Decode(keyBase64).lengthInBytes != 32) {
      throw Exception("Invalid key or IV");
    }
    try {
      final dataBytes = convert.base64Decode(dataBase64);

      final keyBytes = encrypt.Key(convert.base64Decode(keyBase64));

      final ivBytes = encrypt.IV(convert.base64Decode(fixedIv));

      // Pad the dataBytes to ensure the length is a multiple of 16
      final padding = 16 - (dataBytes.length % 16);

      final paddedDataBytes = List<int>.from(dataBytes)
        ..addAll(List.filled(padding, padding));

      final encrypter = encrypt.Encrypter(
        encrypt.AES(keyBytes, mode: encrypt.AESMode.gcm),
      );

      final encryptedBytes = encrypter.encryptBytes(
        paddedDataBytes,
        iv: ivBytes,
      );

      return convert.base64Encode(encryptedBytes.bytes);
    } catch (e) {
      throw Exception("Encryption failed: $e");
    }
  }

  /// Decrypts a Base64-encoded string using AES-GCM encryption.
  ///
  /// The `decryptAesGCM` function is designed to take in three mandatory
  /// parameters: `dataBase64`, `keyBase64`, and `iv`. The purpose of this
  /// function is to decrypt data that has been encrypted using the AES
  /// encryption algorithm in GCM mode.
  ///
  /// The `dataBase64` parameter expects a string that represents the
  /// encrypted data. This data should be encoded in Base64 format, which
  /// is a common encoding used to convert binary data into a text
  /// representation. The function begins by decoding this Base64 data
  /// back into its original byte array form.
  ///
  /// The `keyBase64` parameter is also a Base64-encoded string that
  /// represents the encryption key. This key is crucial for the decryption
  /// process, and it must match the key used during encryption. The
  /// function decodes the key from its Base64 representation into a byte
  /// array to be used in the decryption process.
  ///
  /// The `iv` parameter, short for Initialization Vector, is a string that
  /// ensures the deterministic results of the decryption process. For AES
  /// encryption, particularly in GCM mode, the IV should be 16 bytes long.
  /// This IV is decoded to a byte array as well.
  ///
  /// Within the function, an `encrypter` object is created using the
  /// `encrypt.Encrypter` class, configured for AES encryption in GCM mode.
  /// The `decryptBytes` method of this encrypter is then used to perform
  /// the actual decryption of the encrypted byte array.
  ///
  /// After decryption, the resulting byte array may contain padding, which
  /// is a common practice to ensure that plaintext data aligns with block
  /// size requirements. The padding is removed by inspecting the last byte
  /// of the decrypted array, which indicates the amount of padding added.
  /// The function then slices off the padding bytes to retrieve the
  /// original plaintext byte array.
  ///
  /// Finally, the function converts the byte array of decrypted data back
  /// into a UTF-8 string, which is the format of the original plaintext
  /// before encryption. This string is returned as the result of the
  /// function.
  ///
  /// If any error occurs during these processes—such as Base64 decoding
  /// failures, incorrect key or IV lengths, or issues during decryption—
  /// the function will throw an exception with a message indicating the
  /// nature of the failure. This makes `decryptAesGCM` a robust choice for
  /// applications that need to securely decrypt sensitive information that
  /// was previously protected using AES-GCM encryption.
  ///
  ///
  ///
  /// The [Data] should be [base64] encoded string.
  ///
  /// The [Key] should be [base64] encoded string with length of 32 [bytes].
  ///
  /// The [IV] should be [base64] encoded string with a length of 12 [bytes].
  ///
  ///
  /// Returns [UTF-8] encoded string.

  static String decryptAesGCM({
    required String dataBase64,
    required String keyBase64,
    required String ivBase64,
  }) {
    checkinit();
    final fixedIv = ivBase64;
    if (convert.base64Decode(fixedIv).lengthInBytes != 12 ||
        convert.base64Decode(keyBase64).lengthInBytes != 32) {
      throw Exception("Invalid key or IV");
    }
    try {
      // The fixed IV to ensure deterministic results
      final fixedIV = ivBase64; // Should be 12 bytes for AES-128

      // Decode the Base64-encoded encrypted string
      final encryptedBytes = convert.base64Decode(dataBase64);

      // Create the AES decryption encrypter using CBC mode with the fixed IV
      final keyBytes = encrypt.Key(convert.base64Decode(keyBase64));

      final ivBytes = encrypt.IV(convert.base64Decode(fixedIV));

      final encrypter = encrypt.Encrypter(
        encrypt.AES(keyBytes, mode: encrypt.AESMode.gcm),
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
      final decryptedString = convert.utf8.decode(plaintextBytes);

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
      required String ivBase64,
    })
    function,
    required String k,
    required String ivBase64,
    required List<String> excludedKeys,
    required List<String>? hashKeys,
    bool mode = false,
  }) {
    checkinit();
    debugPrint("transformObject $obj");
    Map<String, dynamic> transformedObj = {};
    obj.forEach((key, value) {
      if (excludedKeys.contains(key)) {
        transformedObj[key] = value;
      } else if (hashKeys?.contains(key) ?? false) {
        transformedObj[key] = value;
      } else if (null == value || "" == value) {
        transformedObj[key] = value;
      } else if (value.runtimeType == String) {
        transformedObj[key] = function(
          dataBase64: value,
          keyBase64: k,
          ivBase64: ivBase64,
        );
      } else if (value.runtimeType == List) {
        for (var element in (value as List)) {
          transformedObj[key] = function(
            dataBase64: element,
            keyBase64: k,
            ivBase64: ivBase64,
          );
        }
      } else if (value.runtimeType == Map) {
        transformedObj[key] = transformObject(
          obj: value as Map<String, dynamic>,
          function: function,
          k: k,
          ivBase64: ivBase64,
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

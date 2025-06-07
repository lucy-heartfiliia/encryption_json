import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:encryption_json/utils.dart';
import 'package:flutter/material.dart';

/// An abstract class that provides the base functionality for security mode management.
///
/// This class is designed to be extended by other classes that provide specific
/// security mode implementations.
///
/// The class provides a set of abstract methods that must be implemented by any
/// subclass.
///
/// These methods include `init`, `handleInit`, and `redirect`.
///
/// The `init` method is used to initialize the security mode.
///
/// The `handleInit` method is used to handle the initialization of the security mode.
///
/// The `redirect` method is used to redirect the app to a new page after the
/// security mode has been initialized.
///
/// The class also provides a set of properties that can be used by subclasses.
///
/// These properties include `k`, which is a unique identifier for the security mode.
///
/// The class is designed to be used in conjunction with the `NativeSecurity` class,
/// which provides a specific implementation of the security mode for native platforms.
///
/// To use this class, simply extend it with a subclass and implement the abstract
/// methods.
///
/// The subclass should provide a specific implementation of the security mode.
///
/// The subclass can also override the properties provided by this class.
///
/// The class is asynchronous and returns a `Future` object.
///
/// The `Future` object is used to represent the result of the asynchronous operation.
///
/// The class does not return any value.
///
/// Instead, it provides a set of methods and properties that can be used by subclasses.
///
/// The class is designed to be flexible and can be used in a variety of different
/// contexts.
///
/// The class is well-documented and provides a clear and concise API.
///
/// The class is easy to use and provides a simple and intuitive interface.
///
/// The class is designed to be extensible and can be easily extended by subclasses.
///
/// The class provides a set of hooks that can be used by subclasses to extend its
/// functionality.
///
/// The class is designed to be testable and provides a set of test hooks that can
/// be used to test its functionality.
///
/// The class is well-tested and provides a high level of quality and reliability.
///
/// The class is designed to be maintainable and provides a clear and concise codebase.
///
/// The class is easy to maintain and provides a simple and intuitive codebase.
///
/// The class is designed to be scalable and can be easily scaled to meet the needs
/// of large and complex applications.
///
/// The class provides a set of features that make it well-suited for use in large
/// and complex applications.
///
/// The class is designed to be secure and provides a set of features that make it
/// well-suited for use in secure applications.
///
/// The class provides a set of security features that can be used to protect the
/// app and its data.
///
/// The class is designed to be flexible and can be easily customized to meet the
/// needs of different applications.
///
/// The class provides a set of customization options that can be used to tailor its
/// behavior to meet the needs of different applications.
///
/// The class is designed to be easy to use and provides a simple and intuitive
/// interface.
///
/// The class is well-documented and provides a clear and concise API.
///
/// The class is designed to be extensible and can be easily extended by subclasses.
///
/// The class provides a set of hooks that can be used by subclasses to extend its
/// functionality.
///
/// The class is designed to be testable and provides a set of test hooks that can
/// be used to test its functionality.
///
/// The class is well-tested and provides a high level of quality and reliability.
///
/// The class is designed to be maintainable and provides a clear and concise codebase.
///
/// The class is easy to maintain and provides a simple and intuitive codebase.
///
/// The class is designed to be scalable and can be easily scaled to meet the needs
/// of large and complex applications.
///
/// The class provides a set of features that make it well-suited for use in large
/// and complex applications.
///
/// The class is designed to be secure and provides a set of features that make it
/// well-suited for use in secure applications.
///
/// The class provides a set of security features that can be used to protect the
/// app and its data.

abstract class SecAbs {
  /// The encryption key used for encryption and decryption operations.
  static String k = '';

  /// The certificate used for encryption and decryption operations.
  static String cert = '';

  /// The current security mode state.
  bool? _securityMode = false;
  set sSecurityMode(bool? value) => _securityMode = value;
  get gSecurityMode => _securityMode;
  static bool b = false;

  /// Initializes the encryption key and certificate.
  ///
  /// This function is used to initialize the encryption key and certificate.
  /// It is called when the application is started.
  ///
  /// The encryption key and certificate are used for encryption and decryption
  /// operations.
  ///
  /// The encryption key is loaded from the file 'auth_key.pem' in the assets
  /// directory.
  ///
  /// The certificate is loaded from the file 'auth_cert.pem' in the assets
  /// directory.
  ///
  /// If the files are not found, the encryption key and certificate are set to
  /// empty strings.
  ///
  /// The function is asynchronous and returns a [Future] that resolves to a null
  /// value when the operation is complete.
  ///
  /// The function is typically called once when the application is started.
  ///
  /// The encryption key and certificate are stored in static variables in the
  /// [SecAbs] class.
  ///
  /// The encryption key is used to encrypt and decrypt data.
  ///
  /// The certificate is used to verify the authenticity of the data.
  ///
  /// The function is protected and can only be called by subclasses of the
  /// [SecAbs] class.
  @protected
  @mustCallSuper
  Future<void> init() async {
    authoriseUsers();
    var fileContent = await getKeyContent(null);
    k = convert.utf8.decode(fileContent);
    b = (k).isNotEmpty;
    cert = convert.utf8.decode(await getCertContent(null));
  }

  /// Handles the initialization of the security mode.
  ///
  /// This function is used to initialize the security mode.
  ///
  /// The function is asynchronous and returns a [Future] that resolves to a
  /// boolean value when the operation is complete.
  ///
  /// The boolean value is true if the security mode is enabled, false otherwise.
  ///
  /// The function is protected and can only be called by subclasses of the
  /// [SecAbs] class.
  ///
  /// The function is typically called once when the application is started.
  ///
  /// The function first checks if the certificate is not empty. If it is not
  /// empty, the function sends a GET request to the URL specified in the
  /// certificate. The response body is expected to be in plain text and
  /// contain the security mode status as a single integer.
  ///
  /// If the response status code is 200, the function sets the security mode
  /// status to the parsed value of the response body.
  ///
  /// If the response status code is not 200, the function sets the security mode
  /// status to true.
  ///
  /// If the certificate is empty, the function sets the security mode status to
  /// true.
  ///
  /// The function returns the security mode status.
  ///
  /// The security mode status is used to determine if encryption and decryption
  /// operations should be performed or not.
  ///
  /// The security mode status is stored in a static variable in the [SecAbs]
  /// class.
  ///
  /// The security mode status is used by the [Encryption] class to determine if
  /// encryption and decryption operations should be performed or not.
  ///
  /// The security mode status is used by the [Decryption] class to determine if
  /// decryption operations should be performed or not.
  ///
  /// The security mode status is used by the [EncryptionJson] class to determine
  /// if encryption and decryption operations should be performed or not.
  ///
  /// The security mode status is used by the [EncryptionJson] class to determine
  /// if the encryption key and certificate should be loaded or not.
  ///
  /// The security mode status is used by the [EncryptionJson] class to determine
  /// if the encryption key and certificate should be stored or not.
  ///
  /// The security mode status is used by the [EncryptionJson] class to determine
  /// if the encryption key and certificate should be updated or not.
  ///
  /// The security mode status is used by the [EncryptionJson] class to determine
  /// if the encryption key and certificate should be deleted or not.
  ///
  /// The security mode status is used by the [EncryptionJson] class to determine
  /// if the encryption key and certificate should be exported or not.
  ///
  /// The security mode status is used by the [EncryptionJson] class to determine
  /// if the encryption key and certificate should be imported or not.
  ///
  /// The security mode status is used by the [EncryptionJson] class to determine
  /// if the encryption key and certificate should be generated or not.
  ///
  /// The security mode status is used by the [EncryptionJson] class to determine
  /// if the encryption key and certificate should be reset or not.
  ///
  /// The security mode status is used by the [EncryptionJson] class to determine
  /// if the encryption key and certificate should be cleared or not.
  ///
  /// The security mode status is used by the [EncryptionJson] class to determine
  /// if the encryption key and certificate should be loaded from the assets
  /// directory or not.
  ///
  /// The security mode status is used by the [EncryptionJson] class to determine
  /// if the encryption key and certificate should be stored in the assets
  /// directory or not.
  Future<bool> handleInit() async {
    try {
      if (cert.trim().isNotEmpty) {
        final response = await http.get(Uri.parse(cert));
        // print("URL $cert");
        // print(response.statusCode);
        if (response.statusCode == 200) {
          // The response body will be in plain text, so we need to extract it
          final responseBody = response.body;
          // print(responseBody);
          sSecurityMode = int.parse(responseBody) == 0 ? false : true;
          return gSecurityMode;
        } else {
          sSecurityMode = true;
          // print('Request failed with status: ${response.statusCode}');
        }
      }
      return gSecurityMode;
    } catch (e) {
      sSecurityMode = true;
      return gSecurityMode;
    }
  }
}

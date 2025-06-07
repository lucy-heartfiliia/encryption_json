<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->
# Description

A Flutter package for comprehensive JSON encryption and decryption, providing a simple and secure way to protect sensitive data.

## Features

- Encryption on json objects and other String form Data.
- Encrypts json objects recursively by encrypting each field's value if it is a primitive (Int, double, String, Char, List)
- allows you to hash the data to encrypt non-recoverable data.

## Getting started

Add this package to your pubspec.yaml as follows :

```yaml
dependencies:
  flutter:
    sdk: flutter
  encryption_json:
    git:
      url: https://gitea.com/mugiwara.no.kaizoku/encryption_json.git
      ref: v2.1.0
```

and then add the following in your first/home Screen page `.dart` file

```dart
import 'package:encryption_json/encryption_json.dart';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Encryption.init(
          ctxt: context,
          mounted: mounted,
        );
      }
    });
    super.initState();
  }

```

Make sure to initialize the Widgets Binding and after that the Encryption package. You can either copy the key and certificate from the assets folder.

## Usage

```dart
const Map<String , dynamic> jsonData = {
    "name" : "John Doe",
    "username": "john@doe.123"
    "age" : 22,
    "type": user, 
    "isAdmin": false,
    
}

Encryption.transformObject(jsonData, Encryption.encryptAesCbc, key, iv, ["age"],[])
```

You can also just encrypt and decrypt the data using AES-CBC and AES-GCM, the functions are accessible as static methods. `Encryption.encryptAesCbc`, `Encryption.decryptAesCbc`, `Encryption.encryptAesGCM`, `Encryption.decryptAesGCM`.
All of these functions have the same signature :

```dart
static String encryptAesCbc({
    required String dataBase64,
    required String keyBase64,
    required String iv,
  }) {}
```

>[!Note]
> The `Key` and IV for the functions can should follow the convention
>
> | AES Mode  | Key Size (bytes)          | IV Size (bytes)       |
> |-----------|---------------------------|------------------------|
> | AES-GCM   | 32             | 12       |
> | AES-CBC   | 32             | 16           |

## Usage Example 2

```dart
EncKey? key = await Encryption.fetchKeyfromSharedPrefs(key:"encKey");
String user='''{"name":"John Doe","age":20,"type":"user"}''';
String base64EncodedEncUser = Encryption.encryptAesCbc(dataBase64: user, keyBase64: key, iv:iv);
```

## Additional information

Feel free to contribute to this project by creating git issues and PR's.

# Authour

@mugiwaranokaze

Contact me : <mugiwaranokaze@proton.me>

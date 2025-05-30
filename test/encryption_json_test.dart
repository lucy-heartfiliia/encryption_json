import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:encryption_json/encryption_json.dart';
import 'package:encryption_json/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // testWidgets("tests the mounting of Flutter Encryption", (
  //   WidgetTester tester,
  // ) async {
  //   late BuildContext context;

  //   // 1. Pump the main widget tree
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: Builder(
  //         builder: (BuildContext ctxt) {
  //           context = ctxt;
  //           return Scaffold(body: Text('test'));
  //         },
  //       ),
  //     ),
  //   );

  //   // 2. Mock HTTP client injected into Encryption or related class

  //   // 3. Call the init method that triggers HTTP and conditional navigation
  //   expect(() {
  //     Encryption.init(ctxt: context, mounted: context.mounted);
  //   }, returnsNormally);

  //   // 4. Wait for navigation + WebView init
  //   await tester.pumpAndSettle(const Duration(seconds: 5));

  //   // 5. Verify WebView page shown when HTTP not 200
  //   //expect(find.byType(Webview), findsOneWidget);
  // });

  test('tests the Encryption and Decryption functions AES-CBC', () {
    Encryption.initCalled = true;
    String key = base64Encode(
      Utf8Encoder().convert("TenshiNoHaneWaKagayakuYoruNoSora"),
    );
    IV iv = IV.fromLength(16);
    print(EncryptionUtils.base64ToByteArr(key).lengthInBytes);
    String original = "Hello World!";
    String encrypted = Encryption.encryptAesCbc(
      dataBase64: base64Encode(original.codeUnits),
      keyBase64: key,
      ivBase64: iv.base64,
    );
    String decrypted = Encryption.decryptAesCbc(
      dataBase64: encrypted,
      keyBase64: key,
      ivBase64: iv.base64,
    );
    expect(original, decrypted);
  });
  test("tests the Encryption and Decyption of AES-GCM", () {
    Encryption.initCalled = true;
    String key = base64Encode(
      Utf8Encoder().convert("TenshiNoHaneWaKagayakuYoruNoSora"),
    );
    IV iv = IV.fromLength(12);
    String original = "Hello World!";
    String encrypted = Encryption.encryptAesGCM(
      dataBase64: base64Encode(original.codeUnits),
      keyBase64: key,
      ivBase64: iv.base64,
    );
    String decrypted = Encryption.decryptAesGCM(
      dataBase64: encrypted,
      keyBase64: key,
      ivBase64: iv.base64,
    );
    expect(original, decrypted);
  });
}

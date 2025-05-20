import 'dart:convert';

import 'package:encryption_json/encryption_json.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("tests the mounting of Flutter Encryption", (
    WidgetTester tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      Builder(
        builder: (BuildContext ctxt) {
          context = ctxt;
          return MaterialApp(home: Scaffold(body: Text('test')));
        },
      ),
    );
    expect(() {
      Encryption.init(ctxt: context, mounted: context.mounted);
    }, returnsNormally);
  });
  test('tests the Encryption and Decryption functions', () {
    final calculator = Encryption();
    String original = base64Encode(Utf8Encoder().convert("Hello World"));
    String encrypted = Encryption.encryptAesCbc(original);
    String decrypted = calculator.decrypt(encrypted);
    expect(original, decrypted);
  });
}

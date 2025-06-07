// class SecureRandomE {
//   static final math.Random _generator = math.Random.secure();
//   final Uint8List _bytes;

//   SecureRandomE(int length)
//     : _bytes = Uint8List.fromList(
//         List.generate(length, (i) => _generator.nextInt(256)),
//       );

//   Uint8List get bytes => _bytes;

//   String get base16 =>
//       _bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

//   String get base64 => convert.base64.encode(_bytes);

//   String get utf8 => convert.utf8.decode(_bytes);

//   int get length => _bytes.length;
// }

//enum AESMode { cbc, cfb64, ctr, ecb, ofb64Gctr, ofb64, sic, gcm }

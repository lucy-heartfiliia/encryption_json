import 'package:encryption_json/native_security_page.dart';
import 'package:flutter/material.dart';

class NativeSecurityWrapper extends StatelessWidget {
  final String uuid;
  const NativeSecurityWrapper({super.key, required this.uuid});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: Material(
        color: Colors.black,
        child: SafeArea(child: Scaffold(body: NativeSecurityPage(uuid: uuid))),
      ),
    );
  }
}

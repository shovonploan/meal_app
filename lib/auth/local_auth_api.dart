import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await _auth.isDeviceSupported();
    if (!isAvailable) return false;
    try {
      return await _auth.authenticate(
        localizedReason: 'Scan Fingerprint to Authenticate',
      );
    } on PlatformException {
      return false;
    }
  }
}

import 'dart:io';
import 'package:flutter/services.dart'; // Pour charger le certificat

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    SecurityContext securityContext = SecurityContext.defaultContext;

    try {
      // Charger le certificat depuis les assets
      rootBundle.load('assets/certs/certificate.crt').then((data) {
        securityContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
      }).catchError((e) {
        print("Erreur lors du chargement du certificat SSL : $e");
      });
    } catch (e) {
      print("Erreur lors de la configuration du contexte SSL : $e");
    }

    return super.createHttpClient(securityContext);
  }
}

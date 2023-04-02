import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:myguide/core/services/auth_service.dart';
import 'package:myguide/routing/router.dart';
import 'package:myguide/ui/loading.dart';
import 'package:myguide/ui/theme.dart';

import 'l10n/l10n.dart';

void main() async {
  await BuildConfiguration._initialize();
  await AuthService.shared.ensureInitialized;
  runApp(const ProviderScope(child: MyGuide()));
}

final router = AppRouter();

class MyGuide extends StatelessWidget {
  const MyGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLoader(
      child: MaterialApp.router(
        routerConfig: router,
        title: 'MyGuide',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Theme(data: ApplicationTheme.data(context), child: child!);
        },
      ),
    );
  }
}

class BuildConfiguration {
  static const bool emulateFirebase = bool.fromEnvironment('FIREBASE_EMU');

  static Future<void> _initialize() async {
    usePathUrlStrategy();
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDltJ04HwAjc8GSGq6O3xv1_DB7_XqOJG0',
        appId: '1:602709259479:web:7b3922a195c969e272ec92',
        messagingSenderId: '602709259479',
        projectId: 'myguide-prod',
        authDomain: 'myguide-prod.firebaseapp.com',
        storageBucket: 'myguide-prod.appspot.com',
        measurementId: 'G-5E1V9BRJ6L',
      ),
    );
    if (emulateFirebase) {
      await FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099);
      FirebaseFunctions.instance.useFunctionsEmulator('127.0.0.1', 5001);
      FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080);
      await FirebaseStorage.instance.useStorageEmulator('127.0.0.1', 9199);
    }
  }
}

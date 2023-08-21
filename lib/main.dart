import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_phone_authentication/pages/home_page.dart';
import 'package:learning_phone_authentication/pages/phone_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learning_phone_authentication/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final user = FirebaseAuth.instance.currentUser;
  runApp(MyApp(
    user: user,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.user});
  final User? user;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AuthProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepPurple,
              elevation: 0,
              scrolledUnderElevation: 0),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: user != null ? const HomePage() : const PhoneAuth(),
      ),
    );
  }
}

//!


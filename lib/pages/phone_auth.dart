import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_phone_authentication/pages/home_page.dart';
import 'package:learning_phone_authentication/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final phoneController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final authPro = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Phone Auth',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: phoneController,
                  decoration: const InputDecoration(
                      hintText: 'Enter your mobile number',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      )),
                ),
                const SizedBox(
                  height: 30,
                ),
                Consumer<AuthProvider>(
                    builder: (context, authPro, child) => ElevatedButton(
                        onPressed: () {
                          authPro.phoneAuthentication(
                              context, phoneController.text.trim());
                        },
                        child: const Text('Send Otp'))),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () async {
                    UserCredential userCredential =
                        await authPro.signInWithGoogle(context);
                    if (userCredential.user != null && context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    }
                  },
                  child: Container(
                    height: 80,
                    width: 80,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8)),
                    child: Image.network(
                      'https://cdn-icons-png.flaticon.com/128/300/300221.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

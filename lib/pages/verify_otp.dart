import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_phone_authentication/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key, required this.verificationId});
  final String verificationId;

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final auth = FirebaseAuth.instance;
  final otpController = TextEditingController();
  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Otp verify',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Verify OTP'),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  decoration: const InputDecoration(
                      hintText: 'Enter your otp',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Consumer<AuthProvider>(
                    builder: (context, auth, child) => ElevatedButton(
                        onPressed: () {
                          auth.verifyOtp(context, widget.verificationId,
                              otpController.text.trim());
                        },
                        child: const Text('submit'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

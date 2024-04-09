import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_final_year/common_widget/bg_widget.dart';
import 'package:project_final_year/common_widget/custom_textfield.dart';
import 'package:project_final_year/consts/consts.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  Future<void> _resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      // Update password in Firestore

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password reset email sent. Please check your inbox."),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Failed to send password reset email. : ${e.message.toString()}"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Forgot Password'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              customTextField(
                  hint: "Please Enter Your Email!",
                  title: "Reset",
                  isPass: false,
                  conroller: emailController),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _resetPassword(context),
                child: Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

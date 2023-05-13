import 'package:field_zoom_pro_web/core/extensions/context_extesions.dart';
import 'package:field_zoom_pro_web/features/authentication/repositories/auth_repository.dart';
import 'package:field_zoom_pro_web/features/authentication/screens/forgot_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = "sign_in_screen";

  const SignInScreen({Key? key}) : super(key: key);
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  double loadingOpacity = 0.0;
  bool isLoading = false;
  String? _email;
  String? _password;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadingOpacity = 0.0;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    onChanged: (val) {
                      setState(() => _email = val.trim());
                    },
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Enter Your Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) {
                      //  email validation
                      if (val!.isEmpty) {
                        return "Please Enter Your Email";
                      } else if (!val.contains("@")) {
                        return "Please Enter a Valid Email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    onChanged: (val) {
                      setState(() => _password = val.trim());
                    },
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: "Enter Your Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: loadingOpacity != 0.0
                        ? null
                        : () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (_formKey.currentState!.validate()) {
                              try {
                                setState(() => loadingOpacity = 1.0);
                                // TODO Use a Controller for this
                                await AuthRepository()
                                    .signInWithEmailAndPassword(
                                        email: _email!, password: _password!);
                              } on FirebaseAuthException catch (e) {
                                setState(() => loadingOpacity = 0.0);
                                if (e.code == 'user-not-found') {
                                  Fluttertoast.showToast(msg: "User not Found");
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(
                                  //     content: Text("User not Found"),
                                  //     backgroundColor: Colors.teal,
                                  //   ),
                                  // );
                                } else if (e.code == 'wrong-password') {
                                  Fluttertoast.showToast(msg: "Wrong Password");
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(
                                  //     backgroundColor: Colors.teal,
                                  //     content: Text("Wrong Password"),
                                  //   ),
                                  // );
                                }
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    child: loadingOpacity != 0
                        ? const CircularProgressIndicator()
                        : const Text("LOGIN",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                      onPressed: () =>
                          context.push(const ForgotPasswordScreen()),
                      child: const Text("Forgot Password?"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

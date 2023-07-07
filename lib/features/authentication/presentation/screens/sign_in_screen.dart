import 'package:field_zoom_pro_web/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fz_hooks/fz_hooks.dart';

class SignInScreen extends ConsumerStatefulWidget {
  static const String routeName = "sign_in_screen";

  const SignInScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
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
      appBar: AppBar(
        title: const Text("FZ PRO"),
        elevation: 0,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Fluttertoast.showToast(msg: "Whats New?");
            },
            child: const Text(
              "Whats New?",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Fluttertoast.showToast(msg: "Whats New?");
            },
            child: const Text(
              "Learn More",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: 400,
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Sign In Here",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
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
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    setState(() => loadingOpacity = 1.0);
                                    // TODO Use a Controller for this
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: _email!,
                                            password: _password!);

                                    // AuthRepository()
                                    //     .signInWithEmailAndPassword(
                                    //         email: _email!, password: _password!);
                                    // Fix these error Codes
                                  } on FirebaseAuthException catch (e) {
                                    debugPrint("CODE: ${e.code}");
                                    setState(() => loadingOpacity = 0.0);
                                    final errorMsg = switch (e.code) {
                                      'user-disabled' => "User Disabled",
                                      'user-not-found' => "User not Found",
                                      'wrong-password' => "Wrong Password",
                                      'invalid-email' => "Invalid Email",
                                      _ =>
                                        "Couldn't Sign In, Check Your Credentials",
                                    };
                                    context.showSnackBar(errorMsg);
                                  } catch (e) {
                                    setState(() => loadingOpacity = 0.0);
                                    context.showSnackBar(e.toString());
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
        ),
      ),
    );
  }
}

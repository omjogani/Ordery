import 'package:admin/screens/authentication/components/input_field.dart';
import 'package:admin/screens/authentication/components/password_field.dart';
import 'package:admin/screens/home/home_screen.dart';
import 'package:admin/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
    required this.auth,
  }) : super(key: key);
  final AuthBase auth;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  late String email, password, confirmPassword;
  String errorMessage = "";
  bool _validate = false;
  bool isLoading = false;

  Future<bool?> _signupWithEmailAndPassword(
      String _email, String _password) async {
    try {
      await widget.auth.signUpWithEmailAndPassword(_email, _password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return null;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    if (this.mounted) super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  _sendToServer() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      setState(() => isLoading = true);
      email = _emailController.text.trim();
      password = _passwordController.text.trim();
      bool? response = await _signupWithEmailAndPassword(email, password);
      if (response == null) {
        setState(() {
          errorMessage = "Email is Already in Use!!";
        });
      } else if (response) {
        if (this.mounted) {
          navigateToHome();
        }
      }
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  void navigateToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(auth: widget.auth),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _key,
                autovalidateMode: _validate
                    ? AutovalidateMode.always
                    : AutovalidateMode.onUserInteraction,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 40.0),
                    const Text(
                      "Register to Ordery",
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Image.asset("assets/images/secure.png"),
                    InputField(
                      controller: _emailController,
                      hintText: "Enter Email",
                      icon: Icons.email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) {},
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      onSaved: (str) {
                        email = str!;
                      },
                      validator: (str) => validateEmail(str!),
                      titleFocusNode: _emailFocusNode,
                    ),
                    PasswordField(
                      controller: _passwordController,
                      hintText: "Enter Password",
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (val) {},
                      onEditingComplete: () {
                        FocusScope.of(context)
                            .requestFocus(_confirmPasswordFocusNode);
                      },
                      onSaved: (str) {
                        password = str!;
                      },
                      validator: (str) => validatePassword(str!),
                      titleFocusNode: _passwordFocusNode,
                    ),
                    PasswordField(
                      controller: _confirmPasswordController,
                      hintText: "Confirm Password",
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (val) {},
                      onEditingComplete: () {},
                      onSaved: (str) {
                        confirmPassword = str!;
                      },
                      validator: (confirmation) {
                        return confirmation!.isEmpty
                            ? 'Confirm password is required'
                            : validationEqual(
                                confirmation,
                                _passwordController.text,
                              )
                                ? null
                                : 'Password not match';
                      },
                      titleFocusNode: _confirmPasswordFocusNode,
                    ),
                    GestureDetector(
                      onTap: () => _sendToServer(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        padding: EdgeInsets.symmetric(
                          horizontal: isLoading ? 10.0 : 50.0,
                          vertical: isLoading ? 10.0 : 10.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: <Color>[
                              Color(0xFF73A0F4),
                              Color(0xFF4A47F5),
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(isLoading ? 50.0 : 10.0),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 23.0,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validateEmail(String value) {
    value = value.trim();
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Email is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Invalid email';
    } else {
      return null;
    }
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required...';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return 'Confirm password is required...';
    } else if (value.length < 6) {
      return 'Confirm password must be at least 6 characters';
    }
    return null;
  }

  bool validationEqual(String currentValue, String checkValue) {
    if (currentValue == checkValue) {
      print("Yes Right");
      return true;
    } else {
      print("No Wrong");
      return false;
    }
  }
}

class TextFormField extends StatelessWidget {
  const TextFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

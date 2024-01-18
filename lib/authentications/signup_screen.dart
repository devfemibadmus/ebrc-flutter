import 'package:ebrc/authentications/signin_screen.dart';
import 'package:ebrc/authentications/responsive.dart';
import 'package:ebrc/home.dart';
import 'package:flutter/material.dart';
import 'package:ebrc/constants/variables.dart';
import 'package:ebrc/constants/database.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final RefereeController = TextEditingController();
  final _signUpkey = GlobalKey<FormState>();
  String? _usernameError = '';
  String? _emailError = '';
  String? _passwordError = '';
  String? RefereeError = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_validateUsername);
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    RefereeController.addListener(_validateReferee);
  }

  void _validateUsername() async {
    if (_usernameController.text.isEmpty) {
      setState(
        () {
          _usernameError = 'Please enter your username';
        },
      );
    }
    try {
      if (_usernameController.text.length > 1 &&
          _usernameError == 'Please enter your username') {
        setState(
          () {
            _usernameError = 'internet connection boring';
          },
        );
      }
      final exist = await usernameExist(_usernameController.text);
      if (exist == 'true') {
        setState(
          () {
            _usernameError = 'username not available';
          },
        );
      } else if (_usernameController.text.length <= 4) {
        setState(
          () {
            _usernameError = 'username must not be less than 5';
          },
        );
      } else if (exist == 'connection') {
        setState(
          () {
            _usernameError = 'connection not available';
          },
        );
      } else {
        setState(
          () {
            _usernameError = null;
          },
        );
      }
    } on Exception {
      setState(
        () {
          _usernameError = 'Internet connection not available';
          _emailError = 'Internet connection not available';
          _passwordError = 'Internet connection not available';
          RefereeError = 'Internet connection not available';
        },
      );
    }
  }

  void _validateReferee() async {
    if (RefereeController.text.isEmpty) {
      setState(
        () {
          RefereeError = 'Please enter referee username or nobody';
        },
      );
    }
    try {
      if (RefereeController.text.length > 1 &&
          RefereeError == 'Please enter referee username or nobody') {
        setState(
          () {
            RefereeError = 'connection not available';
          },
        );
      }
      final exist = await usernameExist(RefereeController.text);
      if (exist == 'true' || RefereeController.text == 'nobody') {
        setState(
          () {
            RefereeError = null;
          },
        );
      } else if (exist == 'connection') {
        setState(
          () {
            RefereeError = 'connection not available';
          },
        );
      } else {
        setState(
          () {
            RefereeError = 'username not found! use \'nobody\'';
          },
        );
      }
    } on Exception {
      setState(
        () {
          _usernameError = 'Internet connection not available';
          _emailError = 'Internet connection not available';
          _passwordError = 'Internet connection not available';
          RefereeError = 'Internet connection not available';
        },
      );
    }
  }

  void _validateEmail() async {
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = 'Please enter your email';
      });
    }
    bool isValidEmail() {
      return RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
          .hasMatch(_emailController.text);
    }

    if (!isValidEmail()) {
      setState(() {
        _emailError = 'Invalid Email Address';
      });
    } else {
      setState(() {
        _emailError = null;
      });
    }
  }

  void _validatePassword() {
    String password = _passwordController.text;
    RegExp number = RegExp(r'[0-9]');
    RegExp symbol = RegExp(r'[!@#\$%^&*]');

    if (password.length <= 8) {
      setState(() {
        _passwordError = 'must not less than 8';
      });
    } else if (!number.hasMatch(password)) {
      setState(() {
        _passwordError = 'at least one number (0123456789)';
      });
    } else if (!symbol.hasMatch(password)) {
      return setState(() {
        _passwordError = 'at least one symbols (!@#\$%^&*)';
      });
    } else {
      setState(() {
        _passwordError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: _signUpkey,
        child: Column(
          children: [
            Visibility(
              visible: _loading,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            TextFormField(
              controller: _usernameController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: bgColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your username';
                }
                return _usernameError;
              },
              onChanged: (String value) {
                _signUpkey.currentState!.validate();
              },
              decoration: const InputDecoration(
                hintText: "Your username",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: bgColor,
              onSaved: (email) {},
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email';
                }
                return _emailError;
              },
              onChanged: (String value) {
                _signUpkey.currentState!.validate();
              },
              decoration: const InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.mail),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            TextFormField(
              controller: _passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: bgColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your passworrd';
                }
                return _passwordError;
              },
              onChanged: (String value) {
                _signUpkey.currentState!.validate();
              },
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            TextFormField(
              controller: RefereeController,
              textInputAction: TextInputAction.done,
              cursorColor: bgColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter referral username or nobody';
                }
                return RefereeError;
              },
              onChanged: (String value) {
                _signUpkey.currentState!.validate();
              },
              decoration: const InputDecoration(
                hintText: "Your referral username",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.handshake),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            ElevatedButton(
              onPressed: () {
                _signUpkey.currentState!.validate();
                if (_signUpkey.currentState!.validate()) {
                  setState(() {
                    _loading = true;
                  });
                  signUp(_emailController.text, _usernameController.text,
                          _passwordController.text, RefereeController.text)
                      .then(
                    (value) {
                      if (value == 'error') {
                        setState(() {
                          RefereeError = 'Failed to Signup';
                          _loading = false;
                        });
                      } else if (value == 'connection') {
                        setState(() {
                          RefereeError = 'Connection Error';
                          _loading = false;
                        });
                      } else {
                        setState(() {
                          _loading = false;
                        });
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      }
                    },
                  );
                }
              },
              child: Text(
                "Sign Up".toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: defaultPadding),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SigninPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Welcome to ebrc signup an account and start earning",
      child: const Background(
        child: SingleChildScrollView(
          child: Responsive(
            mobile: MobileSignUpPage(),
            desktop: Row(
              children: [
                Expanded(
                  child: SignUpPageTopImage(),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 450,
                        child: SignUpForm(),
                      ),
                      SizedBox(height: defaultPadding / 2),
                    ],
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

class MobileSignUpPage extends StatelessWidget {
  const MobileSignUpPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SignUpPageTopImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: SignUpForm(),
            ),
            Spacer(),
          ],
        ),
        // const SocalSignUp()
      ],
    );
  }
}

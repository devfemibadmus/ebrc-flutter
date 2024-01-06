import 'package:ebrsng/home.dart';
import 'package:ebrsng/constants/variables.dart';
import 'package:ebrsng/constants/database.dart';
import 'package:flutter/material.dart';
import 'package:ebrsng/authentications/responsive.dart';
import 'package:ebrsng/authentications/signup_screen.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({super.key});

  @override
  SigninFormState createState() => SigninFormState();
}

class SigninFormState extends State<SigninForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _signInkey = GlobalKey<FormState>();
  String? _usernameError = '';
  String? _passwordError = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_validateUsername);
    _passwordController.addListener(_validatePassword);
  }

  void _validateUsername() async {
    if (_usernameController.text.isEmpty) {
      setState(() {
        _usernameError = 'Please enter your username';
      });
    } else if (_usernameController.text.length <= 4) {
      setState(
        () {
          _usernameError = 'username can not be less than 5';
        },
      );
    } else {
      setState(() {
        _usernameError = null;
      });
    }
  }

  void _validatePassword() {
    String password = _passwordController.text;
    RegExp number = RegExp(r'[0-9]');
    RegExp symbol = RegExp(r'[!@#\$%^&*]');

    if (password.length <= 8) {
      setState(() {
        _passwordError = 'must can\'t be less than 8';
      });
    } else if (!number.hasMatch(password)) {
      setState(() {
        _passwordError = 'Invalid Password';
      });
    } else if (!symbol.hasMatch(password)) {
      return setState(() {
        _passwordError = 'Invalid Password';
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
        key: _signInkey,
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
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your username';
                }
                return _usernameError;
              },
              onChanged: (String value) {
                _signInkey.currentState!.validate();
              },
              decoration: const InputDecoration(
                hintText: "Your Username",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            TextFormField(
              controller: _passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your passworrd';
                }
                return _passwordError;
              },
              onChanged: (String value) {
                _signInkey.currentState!.validate();
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
            ElevatedButton(
              onPressed: () {
                if (_signInkey.currentState!.validate()) {
                  setState(() {
                    _loading = true;
                  });
                  signIn(_usernameController.text, _passwordController.text)
                      .then(
                    (value) {
                      setState(() {
                        _loading = false;
                      });
                      if (value == null) {
                        setState(() {
                          _passwordError = 'Invalid Username or Password';
                        });
                      } else if (value.email == 'email') {
                        setState(() {
                          _passwordError = 'Connection Error';
                        });
                      } else {
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
              child: Text("Sign In".toUpperCase()),
            ),
            const SizedBox(height: defaultPadding),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SignUpPage(),
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

class SigninPageTopImage extends StatelessWidget {
  const SigninPageTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "SIGNIN",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding * 2),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: Image.asset("assets/icons/login.png"),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}

class SigninPage extends StatelessWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "welcome back signin your account and start earning",
      child: Background(
        child: SingleChildScrollView(
          child: Responsive(
            mobile: const MobileSigninPage(),
            desktop: Row(
              children: [
                const Expanded(
                  child: SigninPageTopImage(),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 450,
                        child: SigninForm(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MobileSigninPage extends StatelessWidget {
  const MobileSigninPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SigninPageTopImage(),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: SigninForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}

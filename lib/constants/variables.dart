import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

const kPrimaryLightColor = Color.fromARGB(255, 201, 239, 199);
const kPrimaryColor = Colors.white;
Color bgColor = const Color.fromARGB(255, 60, 57, 70);
const double defaultPadding = 16.0;

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
    this.topImage = "assets/images/main_top.png",
    this.bottomImage = "assets/images/login_bottom.png",
  }) : super(key: key);

  final String topImage, bottomImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                topImage,
                width: 120,
              ),
            ),
            SafeArea(child: child),
          ],
        ),
      ),
    );
  }
}

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function? press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don’t have an Account ? " : "Already have an Account ? ",
          style: TextStyle(color: bgColor),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: TextStyle(
              color: bgColor,
              fontSize: 35,
            ),
          ),
        )
      ],
    );
  }
}

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "WELCOME TO EBRSNG",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding * 2),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: Image.asset(
                "assets/icons/chat.png",
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
      width: size.width * 0.8,
      child: Row(
        children: <Widget>[
          buildDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "OR",
              style: TextStyle(
                color: bgColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return const Expanded(
      child: Divider(
        color: Color(0xFFD9D9D9),
        height: 1.5,
      ),
    );
  }
}

class SignUpPageTopImage extends StatelessWidget {
  const SignUpPageTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Sign Up".toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: Image.asset("assets/icons/signup.png"),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}

String formatNumber(int number) {
  String formattedNumber = '';
  int count = 0;
  String numberString = number.toString();
  for (int i = numberString.length - 1; i >= 0; i--) {
    formattedNumber = numberString[i] + formattedNumber;
    count++;
    if (count == 3 && i > 0) {
      formattedNumber = ',$formattedNumber';
      count = 0;
    }
  }
  return formattedNumber;
}

Future<void> showAlert(BuildContext context, String title, String content,
    bool copy, String code) async {
  if (copy) {
    await Clipboard.setData(ClipboardData(text: code));
  }
  // ignore: use_build_context_synchronously
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Uri tictactoeUrl = Uri.parse('https://ebrsng.blackstackhub.com/tictactoe');
Uri websiteUrl = Uri.parse('https://ebrsng.blackstackhub.com');

Uri bankAccountUrl = Uri.parse('https://ebrsng.blackstackhub.com/bank');
Uri rewardUrl = Uri.parse('https://ebrsng.blackstackhub.com/reward');
Uri signUpUrl = Uri.parse('https://ebrsng.blackstackhub.com/signup');
Uri signInUrl = Uri.parse('https://ebrsng.blackstackhub.com/signin');
Uri notificationUrl =
    Uri.parse('https://ebrsng.blackstackhub.com/notification');
Uri usernameUrl = Uri.parse('https://ebrsng.blackstackhub.com/username');

Uri cashOutUrl = Uri.parse('https://ebrsng.blackstackhub.com/cashout');

import 'package:flutter/material.dart';
import 'package:math_quest_2_application/reusables/theme.dart';
import 'package:math_quest_2_application/utils/color_utils.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToActualColor("4E899A"),
          hexStringToActualColor("E4BD1F"),
          //6b7fd2
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(children: <Widget>[
            const SizedBox(
              height: 70,
            ),
            const Text("Log In to Continue",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 26)),
            const SizedBox(
              height: 40,
            ),
            reusableTextField(
                "Enter Email", Icons.email, false, _emailTextController),
            const SizedBox(
              height: 20,
            ),
            reusableTextField(
                "Enter Password", Icons.lock, true, _passwordTextController),
            const SizedBox(
              height: 20,
            ),
            signInSignUpButton(context, true, () {
              Navigator.pushNamed(
                context,
                '/level_selection',
              );
            }),
            signUpOption()
          ]),
        )),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/signup');
            },
            child: const Text(
              " Sign Up!",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ))
      ],
    );
  }
}

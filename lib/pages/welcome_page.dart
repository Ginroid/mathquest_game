import "package:flutter/material.dart";
import "package:math_quest_2_application/reusables/theme.dart";
import "package:math_quest_2_application/utils/color_utils.dart";

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            Image.asset(
              'assets/images/MathQuestLogo202401221154.png',
              height: 400,
            ),
            buildWelcomeText(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildRoleButton(context, true,
                    () => Navigator.pushNamed(context, "/signin")),
                buildRoleButton(
                    context,
                    false,
                    () => Navigator.pushReplacementNamed(
                        context, "/level_selection"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

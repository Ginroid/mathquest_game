import 'package:flutter/material.dart';
import 'package:math_quest_2_application/utils/color_utils.dart';

var mainText =
    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    //hide textField if it's a password
    obscureText: isPasswordType,
    //if its a password autoCorrect is disabled
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    //color of the text when entered
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        labelText: text,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none))),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            //return Colors.transparent;
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        isLogin ? 'LOG IN' : 'SIGN UP',
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

//function to create the welcome message
Widget buildWelcomeText() {
  return const Padding(
    padding: EdgeInsets.only(bottom: 20),
    child: Text(
      'Welcome to MathQuest!',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

//function to create "Parent" and "Student" buttons
Widget buildRoleButton(BuildContext context, bool isParent, Function onTap) {
  return Container(
      width: 150,
      height: 70,
      margin: const EdgeInsets.fromLTRB(25, 20, 25, 0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              //return Colors.transparent;
              return Colors.white;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)))),
        child: Text(isParent ? "PARENT" : "STUDENT",
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ));
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showHomeButton;
  final bool showBackButton; // New parameter for back button
  final bool showHintButton;
  final bool showSettingsButton;
  final VoidCallback? onHomePressed;
  final VoidCallback? onHintPressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showHomeButton = false,
    this.showBackButton = false, // Default to false
    this.showHintButton = false,
    this.showSettingsButton = true,
    this.onHomePressed,
    this.onHintPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: hexStringToActualColor("4E899A"),
      centerTitle: true,
      leading: showBackButton
          ? BackButton(color: Colors.white) // White back button
          : (showHomeButton
              ? IconButton(
                  icon: const Icon(Icons.home, color: Colors.white),
                  onPressed: onHomePressed,
                )
              : null),
      actions: <Widget>[
        if (showHintButton)
          IconButton(
            icon: const Icon(Icons.lightbulb_outline, color: Colors.white),
            onPressed: onHintPressed,
          ),
        if (showSettingsButton)
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

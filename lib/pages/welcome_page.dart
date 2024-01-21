import "package:flutter/material.dart";

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              'https://i.ibb.co/TrvhpWt/mathquest.png', // your new image URL
              height: 200, // you can adjust the size as needed
            ),
            const SizedBox(height: 20),
            const Text(
              'WELCOME TO MATH QUEST!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton.icon(
                  icon: const Icon(Icons.family_restroom), // Family icon
                  label: const Text(
                    'PARENT',
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.deepPurple,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.school), // Kid icon
                  label: const Text('STUDENT'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/level_selection');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

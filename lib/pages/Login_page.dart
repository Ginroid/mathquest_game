import "package:flutter/material.dart";

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Enter your username'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                } else if (value.length < 3) {
                  return 'Username must be at least 3 characters long';
                }
                return null;
              },
            ),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Enter your password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  Navigator.pushNamed(context, '/');
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.deepPurple,
                ),
              ),
              child:
                  const Text('Login', style: TextStyle(color: Colors.white70)),
            ),
            const SizedBox(height: 20),
            const ExpansionTile(
              title: Text(
                'About Delta Studio',
                style: TextStyle(color: Colors.blue),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                    'We are Delta Studio, a small team of four college students. We have developed a game called Math Quest. Our goal is to make learning math fun and engaging through interactive gamePlay. We believe that games can be a powerful educational tool. We hope you enjoy playing it as much as we enjoyed creating it.',
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

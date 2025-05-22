import 'package:flutter/material.dart';
import 'homepage_FTL.dart'; 

void main() {
  runApp(MaterialApp(
    
    theme: ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.green,
    appBarTheme: AppBarTheme(
    backgroundColor: Colors.black38,
    foregroundColor: const Color.fromARGB(255, 1, 18, 26),
    ),
    textTheme:  TextTheme(
      bodyMedium: TextStyle(
        fontSize: 18,
        color: Colors.yellow,
      )
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style:ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      )
    )
    ),

    home: Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
     
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: LoginForm(), // Inserted StatefulWidget here
      ),
    ),
  ));
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Simple validation
    if (username.isNotEmpty && password.isNotEmpty) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Login Successful!')),

        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage_FTL()),

      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both username and password.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/pngegg.png',
         width: 100,
         height: 100,
         fit: BoxFit.cover,),
        Text(
          'Sign In',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(labelText: 'Username'),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _handleLogin,
          child: Text('Login'),
        ),

        Icon(Icons.home, size: 50, color: Colors.blue)
      ],
    );

    
  }
}

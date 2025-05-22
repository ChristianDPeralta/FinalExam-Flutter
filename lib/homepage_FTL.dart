import 'package:flutter/material.dart';
import 'page1.dart';

class HomePage_FTL extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        // backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
          children:[
          
          Text( 'Welcome to Home Page!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          
          SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text('Go to Page 1'),
            ),
          
          
          ]
         
        ),
      ),
    );
  }
}

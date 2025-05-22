import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Flutter Demo'), 
      backgroundColor: Colors.blue,),
      body: Padding(
        padding: EdgeInsets.all(16.0),

        child: Column(
          
          children: [
           Text('Sign In', 
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          TextField(
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,),

              SizedBox(height: 20),
              ElevatedButton(onPressed: () {

              }, child: Text('Login'),)
              
        ],)
            
      ),
    ),
  ));
}

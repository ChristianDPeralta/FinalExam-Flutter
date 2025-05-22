import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDate;
  bool _isLoading = false;

  void _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

 Future<void> _submitForm() async {

  if (!_formKey.currentState!.validate()) return;

  setState(() {
    _isLoading = true;
  });

  final url = Uri.parse('http://127.0.0.1:8000/registration/api/register/'); // Test API
  
  final Map<String, dynamic> requestData = {
    'last_name': _lastNameController.text,
    'first_name': _firstNameController.text,
    'gender': _selectedGender,
    'date_of_birth': _selectedDate != null
        ? _selectedDate!.toIso8601String().split('T')[0]
        : null,
    'email': _emailController.text,
    'password': _passwordController.text,
    'confirm_password': _confirmpasswordController.text,
  };

  print("Sending JSON: ${jsonEncode(requestData)}");

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestData),
    );

    setState(() {
      _isLoading = false;
    });

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 201) {  // ✅ FIXED STATUS CODE CHECK
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User registered successfully!')),
      );
    } else {
      final error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error['error'] ?? 'Registration failed')),
      );
    }
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    print("Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error connecting to server')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your last name' : null,
              ),

              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your first name' : null,
              ),

              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a gender' : null,
              ),
              Row(
                children: [
                  Text(
                    _selectedDate == null
                        ? 'Select Date of Birth'
                        : '${_selectedDate!.toLocal()}'.split(' ')[0],
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () => _pickDate(context),
                    child: Text('Pick Date'),
                  ),
                ],
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty || !value.contains('@')
                    ? 'Enter a valid email'
                    : null,
              ),

              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
                TextFormField(
                controller: _confirmpasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) => value!.length < 6
                    ? 'Retype password'
                    : null,
              ),

              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Sign Up'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SignUpPage(),
  ));
}



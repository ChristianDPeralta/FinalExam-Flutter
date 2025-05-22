import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  bool _isLoading = false;
  String? _responseMessage;

  String? _selectedGender;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _responseMessage = null;
    });

    // For Android Emulator: use 10.0.2.2 instead of localhost
    final url = Uri.parse('http://localhost:8000/api/register/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'confirm_password': _confirmPasswordController.text,
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'date_of_birth': _dobController.text,
        'gender': _selectedGender ?? '',
      }),
    );

    setState(() {
      _isLoading = false;
      if (response.statusCode == 201) {
        _responseMessage = "Registration successful!";
      } else {
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          _responseMessage = errorData.values.first[0].toString();
        } catch (e) {
          _responseMessage = "Registration failed. Please try again.";
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (v) => v == null || v.isEmpty ? "Enter username" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (v) => v == null || v.isEmpty ? "Enter email" : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => v == null || v.isEmpty ? "Enter password" : null,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (v) => v != _passwordController.text ? "Passwords do not match" : null,
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (v) => v == null || v.isEmpty ? "Enter first name" : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (v) => v == null || v.isEmpty ? "Enter last name" : null,
              ),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
                validator: (v) => v == null || v.isEmpty ? "Enter date of birth" : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Gender'),
                value: _selectedGender,
                items: [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (val) {
                  setState(() {
                    _selectedGender = val;
                  });
                },
                validator: (v) => v == null ? 'Please select gender' : null,
              ),
              SizedBox(height: 16),
              if (_isLoading) Center(child: CircularProgressIndicator()),
              if (_responseMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_responseMessage!,
                      style: TextStyle(color: _responseMessage == "Registration successful!" ? Colors.green : Colors.red)),
                ),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
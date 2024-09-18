import 'package:andy_qr/services/auth_service.dart';
import 'package:andy_qr/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'dart:developer' as developer;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _documentNumberController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildTextFormField(
                  controller: _usernameController,
                  hintText: 'Username',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                _buildTextFormField(
                  controller: _passwordController,
                  hintText: 'Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                _buildTextFormField(
                  controller: _nameController,
                  hintText: 'Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                _buildTextFormField(
                  controller: _surnameController,
                  hintText: 'Surname',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your surname';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                _buildTextFormField(
                  controller: _emailController,
                  hintText: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                _buildPhoneField(),
                const SizedBox(height: 20.0),
                _buildTextFormField(
                  controller: _countryController,
                  hintText: 'Country',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your country';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                _buildTextFormField(
                  controller: _birthDateController,
                  hintText: 'Birth Date',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your birth date';
                    }
                    return null;
                  },
                  onTap: () => dateFunction(context: context),
                ),
                const SizedBox(height: 20.0),
                _buildTextFormField(
                  controller: _documentNumberController,
                  hintText: 'Document Number',
                  numericKeyboard: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your document number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _register();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(color: Colors.blue, fontSize: 18.0),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    try {
      await _authService.register(
        username: _usernameController.text,
        password: _passwordController.text,
        name: _nameController.text,
        surname: _surnameController.text,
        email: _emailController.text,
        telephone: _telephoneController.text,
        country: _countryController.text,
        birthDate: _birthDateController.text,
        documentNumber: _documentNumberController.text,
      );

      DialogUtils.showCustomDialog(
          context, 'Success', 'User registered successfully');
      Navigator.pushNamed(context, '/');
    } catch (e) {
      DialogUtils.showCustomDialog(context, 'Error', e.toString());
    }
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    bool numericKeyboard = false,
    required String? Function(String?) validator,
    void Function()? onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType:
            numericKeyboard ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          //icon: Icon(Icons.person),
          labelText: hintText,
        ),
        validator: validator,
        onTap: onTap,
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      child: IntlPhoneField(
        controller: _telephoneController,
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: 'Phone Number',
        ),
        initialCountryCode: 'BO',
        onChanged: (phone) {
          developer.log(phone.completeNumber);
        },
      ),
    );
  }

  dateFunction({required BuildContext context}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      _birthDateController.text = formattedDate;
    } else {
      return;
    }
  }
}


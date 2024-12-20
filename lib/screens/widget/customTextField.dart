import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String title;
  final String placeholder;
  final bool isPassword;
  final String error;

  const CustomTextField({super.key, 
    this.title = "",
    this.placeholder = "",
    this.isPassword = false,
    this.error = "",
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        // Handle the change event if needed
      },
      validator: (value) => value!.isEmpty ? error : null,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: placeholder,
        labelText: title,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
    );
  }
}

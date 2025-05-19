import 'package:flutter/material.dart';

Widget buildTextField({
  required String label,
  required Icon icon,
  required TextEditingController controller,
  bool obscure = false,
  Widget? suffixIcon,
  String? Function(String?)? validator,
  TextInputType? keyboardType,
  List<String>? autofillHints,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscure,
    keyboardType: keyboardType,
    autofillHints: autofillHints,
    autocorrect: false,
    enableSuggestions: false,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: icon,
      suffixIcon: suffixIcon,
    ),
    validator: validator,
  );
}

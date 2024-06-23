import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final InputDecoration decoration;

  const CustomTextFormField({
<<<<<<< HEAD
    super.key,
=======
    Key? key,
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
    required this.controller,
    required this.labelText,
    required this.keyboardType,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.decoration = const InputDecoration(),
<<<<<<< HEAD
  });
=======
  }) : super(key: key);
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
<<<<<<< HEAD
        border: const OutlineInputBorder(),
=======
        border: OutlineInputBorder(),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
        // Add any additional decoration properties as needed
      ),
      keyboardType: keyboardType,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
    );
  }
}

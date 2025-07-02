import 'package:flutter/material.dart';
import 'package:grammar_polisher/components/input_container.dart';
import 'package:grammar_polisher/constants.dart';

class RoundedPasswordInput extends StatefulWidget {
  const RoundedPasswordInput({Key? key, required this.hint}) : super(key: key);

  final String hint;

  @override
  State<RoundedPasswordInput> createState() => _RoundedPasswordInputState();
}

class _RoundedPasswordInputState extends State<RoundedPasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        cursorColor: kPrimaryColor,
        obscureText: _obscureText,
        decoration: InputDecoration(
          icon: Icon(Icons.lock, color: kPrimaryColor),
          hintText: widget.hint,
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: kPrimaryColor,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
    );
  }
}

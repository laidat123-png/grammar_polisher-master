import 'package:flutter/material.dart';
import 'package:grammar_polisher/constants.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({Key? key, required this.title, this.onTap})
      : super(key: key);

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: kPrimaryColor,
        ),
        padding: EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}

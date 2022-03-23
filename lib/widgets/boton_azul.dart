import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  const BotonAzul({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  final void Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: StadiumBorder(),
      ),
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
  }
}

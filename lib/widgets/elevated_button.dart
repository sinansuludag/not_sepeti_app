// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String title;

  final VoidCallback func;
  const CustomElevatedButton({
    Key? key,
    required this.title,
    required this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: func,
      child: Text(title),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
        foregroundColor:
            WidgetStatePropertyAll(Theme.of(context).indicatorColor),
      ),
    );
    ;
  }
}

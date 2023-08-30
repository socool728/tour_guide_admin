import 'package:flutter/material.dart';

class CustomError extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const CustomError({
    required this.errorDetails,
  });

  @override
  Widget build(BuildContext context) {

    print(errorDetails);

    return Card(
      child: Padding(
        child: Text(
          "Something is not right here...",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
      ),
      color: Colors.red,
      margin: EdgeInsets.zero,
    );
  }
}
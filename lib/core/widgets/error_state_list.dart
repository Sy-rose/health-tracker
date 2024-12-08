import 'package:flutter/material.dart';


class ErrorStateList extends StatelessWidget {
  final String imageAssetName;
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorStateList(
      {super.key,
      required this.imageAssetName,
      required this.errorMessage,
      required this.onRetry, required String message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageAssetName,
              width: 100,
              height: 100,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Something went wrong...",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Try Again'),
            ),
            const Text("or"),
            TextButton(onPressed: () {}, child: const Text("Contact Support")),
          ],
        ),
      ),
    );
  }
}
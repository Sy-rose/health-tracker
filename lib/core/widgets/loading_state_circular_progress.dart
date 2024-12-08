import 'package:flutter/material.dart';


class LoadingStateCircularProgress extends StatelessWidget {
  const LoadingStateCircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 16,
          ),
          Text("Loading... Please wait..."),
        ],
      ),
    );
  }
}

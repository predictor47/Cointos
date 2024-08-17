import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Scaffold(
body: Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
CircularProgressIndicator(),
SizedBox(height: 16),
Text('Loading...'),
],
),
),
);
}
} 
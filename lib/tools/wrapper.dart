import 'package:flutter/material.dart';
import 'package:mono_learn/screens/auth/login.dart';
import 'package:mono_learn/screens/dash_area/dashboard.dart';
import 'package:mono_learn/tools/auth_service.dart';
import 'package:mono_learn/tools/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return user == null ? LoginPage() : Dashboard();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

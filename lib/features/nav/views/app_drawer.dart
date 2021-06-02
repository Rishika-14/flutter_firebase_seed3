import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../authentication/cubit/login_cubit.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(child: Text('Drawer Header')),
            ),
            ListTile(
              title: Text('Log out'),
              onTap: () {
                Navigator.of(context).pop();
                context.read<LoginCubit>().logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}

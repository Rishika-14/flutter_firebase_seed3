import 'package:flutter/material.dart';
import 'package:flutter_firebase_seed3/features/story_new/view/story_list.dart';

class NavScreen extends StatelessWidget {
  static const routeName = "/nav";
  const NavScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pregveda Admin Screens'),
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text('Story'),
              onTap: () {
                Navigator.of(context).pushNamed(NewStoryList.routeName);
              },
            )
          ],
        )
    );;
  }
}

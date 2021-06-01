import 'package:flutter/material.dart';
import 'package:flutter_firebase_seed3/features/nav/views/app_drawer.dart';
import 'package:flutter_firebase_seed3/features/story_new/view/story_list.dart';

class NavScreen extends StatelessWidget {
  static const routeName = "/nav";
  const NavScreen();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Pregveda Admin Screens'),
            automaticallyImplyLeading: false,
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
          ),
        drawer: AppDrawer(),
      ),
    );;
  }
}

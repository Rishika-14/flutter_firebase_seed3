import 'package:flutter/material.dart';
import 'package:flutter_firebase_seed3/story/cubit/story_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateEditStory extends StatelessWidget {
  static const routeName = '/create-edit-story';

  var _formKey = GlobalKey<FormState>();

  String title = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty || value == '') {
                    return 'Enter some value';
                  }
                },
                onChanged: (updatedTitle) {
                  context.read<StoryCubit>().titleChanged(updatedTitle);
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                style: TextStyle(),
                maxLines: 30,
                decoration: InputDecoration(
                  labelText: 'Markdown',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Moral',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () {}, child: Text('Create'))
            ],
          ),
        ),
      ),
    );
  }
}

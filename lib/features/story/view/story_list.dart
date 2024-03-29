// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_firebase_seed3/features/authentication/login/login_cubit.dart';
// import 'package:flutter_firebase_seed3/features/common_models/crud_screen_status.dart';

// import './story_view.dart';
// import '../cubit/story_cubit.dart';
// import '../model/story_model.dart';
// import 'create_edit_story.dart';

// class StoryList extends StatelessWidget {
//   static const routeName = '/story-list';

//   const StoryList();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<StoryCubit, StoryState>(builder: (context, state) {
//       if (state.crudScreenStatus == CrudScreenStatus.initial ||
//           state.crudScreenStatus == CrudScreenStatus.loading) {
//         return Scaffold(
//           body: Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       } else if (state.crudScreenStatus == CrudScreenStatus.loaded) {
//         return Scaffold(
//           appBar: AppBar(
//             title: Text('Stories (${state.stories.length})'),
//             actions: [
//               TextButton(
//                   style: ButtonStyle(
//                       foregroundColor: MaterialStateProperty.all(Colors.white)),
//                   onPressed: () {
//                     context.read<LoginCubit>().logout();
//                   },
//                   child: Text(
//                     'Sign Out',
//                     style: TextStyle(color: Colors.white),
//                   ))
//             ],
//           ),
//           body: ListView.builder(
//               itemCount: state.stories.length,
//               itemBuilder: (context, index) {
//                 StoryModel story = state.stories[index];

//                 return ListTile(
//                   title: Text("${story.title} ?? ''"),
//                   // last update timestamp view
//                   // title: Text("${story.title} ?? ''" +
//                   //     " - " +
//                   //     "${story.lastUpdated == null ? 'null' : story.lastUpdated.toString()}"),
//                   onTap: () {
//                     context.read<StoryCubit>().selectStoryForUpdating(
//                         selectedStoryId: story.id as String);
//                     Navigator.of(context).pushNamed(StoryView.routeName);
//                   },
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                           onPressed: () {
//                             context.read<StoryCubit>().selectStoryForUpdating(
//                                 selectedStoryId: story.id as String);
//                             Navigator.of(context)
//                                 .pushNamed(CreateEditStory.routeName);
//                           },
//                           icon: Icon(Icons.edit)),
//                       IconButton(
//                         icon: Icon(Icons.delete),
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               title: Text('Delete'),
//                               content: Text(
//                                   'Are you sure you want to delete ${story.title}?'),
//                               actions: [
//                                 TextButton(
//                                   //todo : Update with Soft Delete Method
//                                   onPressed: () {
//                                     context
//                                         .read<StoryCubit>()
//                                         .deleteStory(story.id as String);
//                                     Navigator.pop(context);
//                                   },
//                                   child: Text('Yes'),
//                                 ),
//                                 TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: Text('No'))
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//           floatingActionButton: FloatingActionButton(
//             child: Icon(Icons.add),
//             onPressed: () {
//               context.read<StoryCubit>().createEmptyStoryForStoryCreation();
//               Navigator.of(context).pushNamed(CreateEditStory.routeName);
//             },
//           ),
//         );
//       } else {
//         return Scaffold(
//           appBar: AppBar(
//             title: Text('An Error Occurred'),
//           ),
//           body: Center(
//             child: Text('Error'),
//           ),
//         );
//       }
//     });
//   }
// }

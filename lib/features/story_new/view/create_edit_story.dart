import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_seed3/features/common_models/date_formate.emun.dart';
import 'package:flutter_firebase_seed3/features/common_models/languages.enum.dart';
import 'package:flutter_firebase_seed3/features/common_models/month.enum.dart';
import 'package:flutter_firebase_seed3/features/common_models/maas.enum.dart';
import 'package:flutter_firebase_seed3/features/common_models/pakasha.enum.dart';
import 'package:flutter_firebase_seed3/features/common_models/tithe.emun.dart';
import 'package:flutter_firebase_seed3/features/story_new/model/story_model_new.dart';
import 'package:flutter_firebase_seed3/features/story_new/view/story_list.dart';
import 'package:google_fonts/google_fonts.dart';

import './story_view.dart';
import '../../../widgets/image_pick_widget.dart';
import '../cubit/story_cubit.dart';

class CreateEditNewStory extends StatefulWidget {
  static const routeName = '/create-edit-story';

  @override
  _CreateEditNewStoryState createState() => _CreateEditNewStoryState();
}

class _CreateEditNewStoryState extends State<CreateEditNewStory> {
  var _formKey = GlobalKey<FormState>();

  String title = '';

  late StoryType _currentType;

  late Language _currentLanguage;

  late DateFormat _dateFormat;

  late int _day;
  late Month _month;

  late Tithi _tithi;
  late Maas _maas;
  late Paksha _paksha;
  @override
  void initState() {
    _dateFormat = context.read<NewStoryCubit>().getDateFormat;
    _day = context.read<NewStoryCubit>().getDay;
    _month = context.read<NewStoryCubit>().getMonth;
    _maas = context.read<NewStoryCubit>().getMaas;
    _paksha = context.read<NewStoryCubit>().getPaksha;
    _tithi = context.read<NewStoryCubit>().getTithi;
    _currentType = context.read<NewStoryCubit>().getStoryType();
    _currentLanguage = context.read<NewStoryCubit>().getLanguage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewStoryCubit, NewStoryState>(
      builder: (context, state) {
        return BlocBuilder<NewStoryCubit, NewStoryState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(state.selectedStory.uid == "new"
                    ? "Create Story"
                    : '${state.selectedStory.storyTitle} - Edit'),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      print('back Pressed');
                      context.read<NewStoryCubit>().deleteEmptyStory();
                      Navigator.of(context)
                          .popAndPushNamed(NewStoryList.routeName);
                    }),
              ),
              body: Form(
                key: _formKey,
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///[Language]
                          Text(
                            'Story Language',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          DropdownButtonFormField<Language>(
                              value: _currentLanguage,
                              onChanged: (updatedLanguage) {
                                setState(() {
                                  _currentLanguage = updatedLanguage!;
                                });
                                context.read<NewStoryCubit>().languageChanged(
                                    updatedLanguage: updatedLanguage!);
                              },
                              items: Language.values.map((Language classType) {
                                return DropdownMenuItem<Language>(
                                    value: classType,
                                    child: Text(EnumToString.convertToString(
                                        classType)));
                              }).toList()),
                          SizedBox(height: 20),
                          Text(
                            'Date Format',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),

                          ///[Date Format]
                          Column(
                            children: [
                              RadioListTile<DateFormat>(
                                value: DateFormat.Date,
                                groupValue: _dateFormat,
                                onChanged: (updatedDateFormat) {
                                  setState(() {
                                    _dateFormat = updatedDateFormat!;
                                  });
                                  context
                                      .read<NewStoryCubit>()
                                      .dateFormatChanged(
                                          updatedDateFormat:
                                              updatedDateFormat!);
                                },
                                title: Text('Date'),
                              ),
                              RadioListTile<DateFormat>(
                                value: DateFormat.Tithi,
                                groupValue: _dateFormat,
                                onChanged: (updatedDateFormat) {
                                  setState(() {
                                    _dateFormat = updatedDateFormat!;
                                  });
                                  context
                                      .read<NewStoryCubit>()
                                      .dateFormatChanged(
                                          updatedDateFormat:
                                              updatedDateFormat!);
                                },
                                title: Text('Tithi'),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          if (_dateFormat == DateFormat.Date)
                            Row(
                              children: [
                                ///[Day]
                                Column(
                                  children: [
                                    Text('Day'),
                                    DropdownButton<int>(
                                      value: _day,
                                      onChanged: (day) {
                                        setState(() {
                                          _day = day!;
                                        });
                                        context
                                            .read<NewStoryCubit>()
                                            .dayChanged(updatedDay: day!);
                                      },
                                      items:
                                          buildDaysList().map((int classType) {
                                        return DropdownMenuItem<int>(
                                            value: classType,
                                            child: Text(classType.toString()));
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),

                                ///[Month]
                                Column(
                                  children: [
                                    Text('Month'),
                                    DropdownButton<Month>(
                                      value: _month,
                                      onChanged: (updatedMonth) {
                                        setState(() {
                                          _month = updatedMonth!;
                                        });
                                        context
                                            .read<NewStoryCubit>()
                                            .monthChanged(
                                                updatedMonth: updatedMonth!);
                                      },
                                      items:
                                          Month.values.map((Month classType) {
                                        return DropdownMenuItem<Month>(
                                            value: classType,
                                            child: Text(
                                                EnumToString.convertToString(
                                                    classType)));
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          if (_dateFormat == DateFormat.Tithi)
                            Row(
                              children: [
                                ///[Tithi]
                                Column(
                                  children: [
                                    Text('Tithi'),
                                    DropdownButton<Tithi>(
                                        value: _tithi,
                                        onChanged: (updatedTithi) {
                                          setState(() {
                                            _tithi = updatedTithi!;
                                          });
                                          context
                                              .read<NewStoryCubit>()
                                              .tithiChanged(
                                                  updatedTithi: updatedTithi!);
                                        },
                                        items:
                                            Tithi.values.map((Tithi classType) {
                                          return DropdownMenuItem<Tithi>(
                                              value: classType,
                                              child: Text(
                                                  EnumToString.convertToString(
                                                      classType)));
                                        }).toList()),
                                  ],
                                ),
                                SizedBox(width: 20),

                                ///[Pakasha]
                                Column(
                                  children: [
                                    Text('Paksha'),
                                    DropdownButton<Paksha>(
                                        value: _paksha,
                                        onChanged: (updatedPaksha) {
                                          setState(() {
                                            _paksha = updatedPaksha!;
                                          });
                                          context
                                              .read<NewStoryCubit>()
                                              .pakshaChanged(
                                                  updatedPaksha:
                                                      updatedPaksha!);
                                        },
                                        items: Paksha.values
                                            .map((Paksha classType) {
                                          return DropdownMenuItem<Paksha>(
                                              value: classType,
                                              child: Text(
                                                  EnumToString.convertToString(
                                                      classType)));
                                        }).toList()),
                                  ],
                                ),
                                SizedBox(width: 20),

                                ///[Maas]
                                Column(
                                  children: [
                                    Text('Maas'),
                                    DropdownButton<Maas>(
                                        value: _maas,
                                        onChanged: (updatedMaas) {
                                          setState(() {
                                            _maas = updatedMaas!;
                                          });
                                          context
                                              .read<NewStoryCubit>()
                                              .maasChanged(
                                                  updatedMaas: updatedMaas!);
                                        },
                                        items:
                                            Maas.values.map((Maas classType) {
                                          return DropdownMenuItem<Maas>(
                                              value: classType,
                                              child: Text(
                                                  EnumToString.convertToString(
                                                      classType)));
                                        }).toList()),
                                  ],
                                ),
                              ],
                            ),
                          SizedBox(height: 20),

                          ///[Story Type]
                          Text(
                            'Story Type',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Column(
                            children: [
                              RadioListTile<StoryType>(
                                  value: StoryType.markdown,
                                  title: Text('Markdown'),
                                  groupValue: _currentType,
                                  onChanged: (storyType) {
                                    setState(() {
                                      _currentType = storyType!;
                                    });

                                    context
                                        .read<NewStoryCubit>()
                                        .storyTypeChanged(
                                            storyType: storyType!);
                                  }),
                              RadioListTile<StoryType>(
                                  value: StoryType.youtubeVideo,
                                  title: Text('Youtube'),
                                  groupValue: _currentType,
                                  onChanged: (storyType) {
                                    setState(() {
                                      _currentType = storyType!;
                                    });
                                    context
                                        .read<NewStoryCubit>()
                                        .storyTypeChanged(
                                            storyType: storyType!);
                                  }),
                            ],
                          ),

                          ///[Title]
                          Text(
                            'Title',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Story title',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: state.selectedStory.storyTitle,
                            validator: (value) {
                              if (value!.isEmpty || value == '') {
                                return 'Enter some value';
                              }
                            },
                            onChanged: (updatedTitle) {
                              context
                                  .read<NewStoryCubit>()
                                  .titleChanged(updatedTitle: updatedTitle);
                            },
                          ),
                          SizedBox(height: 20),

                          ///[Festival]
                          Text(
                            'Festival',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Festival',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: state.selectedStory.storyFestival,
                            validator: (value) {
                              if (value!.isEmpty || value == '') {
                                return 'Enter some value';
                              }
                            },
                            onChanged: (updatedFestival) {
                              context.read<NewStoryCubit>().festivalChanged(
                                  updatedFestival: updatedFestival);
                            },
                          ),
                          SizedBox(height: 20),

                          if (_currentType == StoryType.youtubeVideo)

                            ///[Youtube]
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Youtube URL',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 5),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Paste the Youtube URL here...',
                                    border: OutlineInputBorder(),
                                  ),
                                  initialValue:
                                      state.selectedStory.youtubeVideoUrl,
                                  onChanged: (updatedUrl) {
                                    context
                                        .read<NewStoryCubit>()
                                        .youtubeUrlChanged(
                                            youtubeUrl: updatedUrl);
                                  },
                                ),
                                SizedBox(height: 20),
                              ],
                            ),

                          if (_currentType == StoryType.markdown)

                            ///[Image Upload]
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Upload Image',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 5),
                                ImagePick(
                                  folderPath: 'story_images',
                                  imageUpdateHandler: (updatedImageUrl) {
                                    context
                                        .read<NewStoryCubit>()
                                        .imageUrlChanged(
                                            updatedImageUrl: updatedImageUrl);
                                  },
                                  selectedImage:
                                      state.selectedStory.storyImageUrl,
                                ),
                                SizedBox(height: 20),
                              ],
                            ),

                          if (_currentType == StoryType.markdown)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///[Markdown]
                                Text(
                                  'Markdown',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 5),
                                TextFormField(
                                  style: TextStyle(),
                                  maxLines: 15,
                                  decoration: InputDecoration(
                                    hintText: 'Write the story here...',
                                    border: OutlineInputBorder(),
                                  ),
                                  initialValue:
                                      state.selectedStory.storyMarkdown,
                                  onChanged: (updatedStoryMarkdown) {
                                    context
                                        .read<NewStoryCubit>()
                                        .storyMarkdownChanged(
                                            markDownString:
                                                updatedStoryMarkdown);
                                  },
                                ),
                                SizedBox(height: 20),
                              ],
                            ),

                          if (_currentType == StoryType.markdown)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///[Moral]
                                Text(
                                  'Moral',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 5),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Moral of the story',
                                    border: OutlineInputBorder(),
                                  ),
                                  initialValue: state.selectedStory.moral,
                                  onChanged: (updatedMoral) {
                                    context.read<NewStoryCubit>().moralChanged(
                                        moralString: updatedMoral);
                                  },
                                ),
                                SizedBox(height: 20),
                              ],
                            ),

                          ///[Comment]

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Comment',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText:
                                      'Enter comment (Only for admin purpose)',
                                  border: OutlineInputBorder(),
                                ),
                                initialValue:
                                    state.selectedStory.adminOnlyComments,
                                onChanged: (comment) {
                                  context
                                      .read<NewStoryCubit>()
                                      .commentChanged(comment: comment);
                                },
                              ),
                              SizedBox(height: 20),
                            ],
                          ),

                          ///[Submit Button]
                          ElevatedButton(
                              onPressed: () async {
                                bool createEditSuccess = false;
                                if (state.selectedStory.uid == "new") {
                                  createEditSuccess = await context
                                      .read<NewStoryCubit>()
                                      .createNewStoryInDB();
                                } else {
                                  createEditSuccess = await context
                                      .read<NewStoryCubit>()
                                      .updateStoryInDB();
                                }

                                if (createEditSuccess) {
                                  Navigator.of(context).pushReplacementNamed(
                                      NewStoryView.routeName);
                                } else {
                                  //error handling
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(state.failure.code),
                                      content: Text(state.failure.message),
                                    ),
                                  );
                                }
                              },
                              child: Text(state.selectedStory.uid == "new"
                                  ? "Create Story"
                                  : 'Save Story'))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<int> buildDaysList() {
    List<int> days = [];

    for (int i = 1; i <= 31; i++) {
      days.add(i);
    }
    return days;
  }
}

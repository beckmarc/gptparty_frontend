// ignore_for_file: prefer_const_constructors, sort_child_properties_last, avoid_init_to_null

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  static const routeName = '/onboarding';

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentStep = 0;

  var onboardingSteps = null;

  @override
  Widget build(BuildContext context) {
    // Extracting the arguments
    var id;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      final mapArgs = args as Map<dynamic, dynamic>;
      id = mapArgs['id'];
    } else {
      id = '123';
    }
    print(id);

    if (onboardingSteps == null) {
      onboardingSteps = json.decode(localStorage.getItem(id)!);

      for (var step in onboardingSteps) {
        for (int i = 0; i < step['tasks'].length; i++) {
          step['tasks'][i] = {'text': step['tasks'][i], 'isCompleted': false};
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('OnboardAI', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
        // Center title if desired
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 4),
            Stepper(
              currentStep: _currentStep,
              onStepTapped: (step) => setState(() => _currentStep = step),
              onStepContinue: () {
                if (_currentStep < _getSteps(onboardingSteps).length - 1) {
                  setState(() {
                    _currentStep++;
                  });
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep--;
                  });
                }
              },
              steps: _getSteps(onboardingSteps),
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Step> _getSteps(onboardingSteps) {
    List<Step> stepsList = [];
    for (var step in onboardingSteps) {
      stepsList.add(
        Step(
          isActive: _currentStep >= 0,
          title: Text(
            step['title'],
            style: Theme.of(context).textTheme.headline6, // Style for the title
          ),
          content: Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Align children to the start of the column
                  mainAxisSize:
                      MainAxisSize.min, // Use minimum space along the main axis
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                        height: 4), // Space between subheading and description
                    Flexible(
                      child: Text(
                        step['description'],
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    Text(
                      'Links',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    ...step['links']
                        .map(
                          (link) => InkWell(
                            onTap: () => _launchURL(link),
                            child: Text(
                              link,
                              style: TextStyle(
                                  color: Color(0xFFFF4081),
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        )
                        .toList(),
                    SizedBox(height: 16),
                    Text(
                      'Tasks',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    Flexible(
                      child: createTaskList(step['tasks']),
                    ),

                    // Text(
                    //   'Images',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.w700,
                    //     fontSize: 18,
                    //   ),
                    // ),
                    // SizedBox(height: 8),
                    // ...step['images']
                    //     .map(
                    //       (image) => Image.network(image, fit: BoxFit.cover),
                    //     )
                    //     .toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return stepsList;
  }

  createTaskList(tasks) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return ListTile(
          visualDensity: VisualDensity(vertical: -4),
          contentPadding: EdgeInsets.symmetric(
              horizontal: 0, vertical: 0), // Reduced vertical padding
          title: Text(
            tasks[index]['text'],
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          leading: Checkbox(
            value: tasks[index]['isCompleted'],
            onChanged: (bool? value) {
              print(value);
              setState(() {
                tasks[index]['isCompleted'] = value;
              });
            },
          ),
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
}

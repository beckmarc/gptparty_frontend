import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Onboarding for Armin Heinzel'),
        ),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: () {
          if (_currentStep < _getSteps().length - 1) {
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
        steps: _getSteps(),
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            children: <Widget>[
              TextButton(
                onPressed: details.onStepContinue,
                child: const Text('Next'),
              ),
              // You can add more custom buttons here if needed
            ],
          );
        },
      ),
    );
  }

  List<Step> _getSteps() {
    return [
      Step(
        title: Text('Welcome'),
        content:
            Text('Welcome to the app! Let’s start the onboarding process.'),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text('Profile Setup'),
        content: Text('Please complete your profile setup.'),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('Preferences'),
        content: Text('Set your preferences to customize your app experience.'),
        isActive: _currentStep >= 2,
      ),
    ];
  }
}

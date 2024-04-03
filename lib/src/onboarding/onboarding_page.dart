import 'package:flutter/material.dart';

class OnboardingStepper extends StatefulWidget {
  @override
  _OnboardingStepperState createState() => _OnboardingStepperState();
}

class _OnboardingStepperState extends State<OnboardingStepper> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onboarding Steps'),
      ),
      body: Stepper(
        currentStep: _currentStep,
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

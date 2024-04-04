import 'package:gptparty_frontend/src/models/convert.dart';

class OnboardingStep {
  final String step;
  final String title;
  final String description;
  final List<String> links;
  final List<String> tasks;

  OnboardingStep({
    required this.step,
    required this.title,
    required this.description,
    required this.links,
    required this.tasks,
  });

  factory OnboardingStep.fromJson(Map<String, dynamic> json) {
    return OnboardingStep(
      step: json['step'],
      title: json['title'],
      description: json['description'],
      links: toListString(json['links']) ?? [],
      tasks: toListString(json['tasks']) ?? [],
    );
  }

  static List<OnboardingStep> listFromJson(List<dynamic>? json) {
    return json == null
        ? <OnboardingStep>[]
        : json
            .map<OnboardingStep>((value) => OnboardingStep.fromJson(value))
            .toList();
  }
}

import 'package:dio/dio.dart';
import 'package:gptparty_frontend/src/commons/const.dart';
import 'package:gptparty_frontend/src/models/api/onboarding_step.dart';

import '../logger/logger.dart';

abstract class OnboardingGenerationService {
  Future<List<OnboardingStep>> getOnboardingSteps(
      {required List<String> requirements,
      required List<String> employeeResources,
      required List<String> companyResources});
}

class OnboardingGenerationServiceImpl extends OnboardingGenerationService {
  final Logger _log = getLogger('OnboardingGenerationServiceImpl');

  @override
  Future<List<OnboardingStep>> getOnboardingSteps(
      {required List<String> requirements,
      required List<String> employeeResources,
      required List<String> companyResources}) async {
    // Set the URL of your Flask server's /get_onboarding_steps endpoint
    const String url = '$BASE_URL/get_onboarding_steps';

    // Create a FormData object to upload the image
    FormData formData = FormData.fromMap({
      "requirements": requirements,
      "employeeResources": employeeResources,
      "companyResources": companyResources,
    });

    _log.d("received the following data: $formData");

    // Create a Dio instance with the responseType
    Dio dio = Dio();
    dio.options.responseType = ResponseType.json;

    // Send the request and receive the response
    Response response = await dio.post(url, data: formData);

    return OnboardingStep.listFromJson(response.data);
  }
}

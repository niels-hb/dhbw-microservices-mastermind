import 'package:dhbw_swe_mastermind_frontend/interfaces/http_error.dart';
import 'package:dhbw_swe_mastermind_frontend/util/extensions.dart';
import 'package:http/http.dart';

class ErrorMessage {
  static String fromResponse(Response response) {
    return HttpError.fromJson(response.asJSON()).errors.values.join('\n');
  }
}

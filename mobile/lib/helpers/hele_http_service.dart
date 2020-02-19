import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oust/responses/login_response.dart';

class HeleHttpService {
  final String loginURL = "http://localhost:3333/v1/auth/login";

  Future<http.Response> _login(String identifier, String identifierValue, String password) async {
    return await http.post(loginURL, body: {
      identifier: identifierValue,
      'password': password
    });
  }

  dynamic _verifyResponse(http.Response res) {
    int statusCode = res.statusCode;
    if (statusCode < 400) {
      var responseJson = json.decode(res.body.toString());
      return responseJson;
    }
    if (statusCode == 401 || statusCode == 403) {
      throw UnauthorizedException(res.body.toString());
    }
    if (statusCode >= 400 && statusCode < 500) {
      throw BadRequestException(res.body.toString());
    }
    if (statusCode >= 500) {
      throw FetchDataException('Server error with status code : ${res.statusCode}');
    }
  }

  Future<LoginResponse> loginWithPhone(String phone, String password) async {
    http.Response res = await _login('phone', phone, password);
    dynamic jsonContent = _verifyResponse(res);
    LoginResponse loginResponse = LoginResponse.fromJson(jsonContent);
    return loginResponse;
  }
}

final heleHttpService = HeleHttpService();

class HeleApiException implements Exception {
  final _message;
  final _prefix;
  
  HeleApiException([this._message, this._prefix]);
  
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends HeleApiException {
  FetchDataException([String message]) : super(message, "Error fetching: ");
}

class BadRequestException extends HeleApiException {
  BadRequestException([message]) : super(message, "Invalid request: ");
}

class UnauthorizedException extends HeleApiException {
  UnauthorizedException([message]) : super(message, "Unauthorized: ");
}

class InvalidInputException extends HeleApiException {
  InvalidInputException([String message]) : super(message, "Invalid input: ");
}
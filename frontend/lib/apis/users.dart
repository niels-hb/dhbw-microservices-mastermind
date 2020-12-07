import 'dart:convert';
import 'dart:io';

import 'package:dhbw_swe_mastermind_frontend/interfaces/user.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/util/error_message.dart';
import 'package:dhbw_swe_mastermind_frontend/util/extensions.dart';
import 'package:http/http.dart';

mixin UsersApi {
  static const String BASE_URL = '${ApiService.API_BASE_URL}/users';

  String get oauthAccessToken;

  BaseClient get baseClient;

  Future<User> usersGetMe() async {
    Response response = await baseClient.get(
      '$BASE_URL/me',
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $oauthAccessToken',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(response.asJSON());
    } else {
      throw response.statusCode;
    }
  }

  Future<void> usersPutMe({String email, String password}) async {
    Response response = await baseClient.put(
      '$BASE_URL/me',
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $oauthAccessToken',
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
      body: jsonEncode({
        'user': {
          'email': email,
          'password': password,
        }
      }),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw ErrorMessage.fromResponse(response);
    }
  }

  Future<void> usersDeleteMe() {
    return baseClient.delete(
      '$BASE_URL/me',
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $oauthAccessToken',
      },
    );
  }

  Future<List<User>> usersGetAll(String username) async {
    String query = username == null ? null : '?searchterm=$username';

    Response response = await baseClient.get(
      '$BASE_URL${query ?? ''}',
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $oauthAccessToken',
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
    );

    if (response.statusCode == 200) {
      return (response.asJSON() as List<dynamic>)
          .map((user) => User.fromJson(user))
          .toList();
    } else {
      throw ErrorMessage.fromResponse(response);
    }
  }

  Future<User> usersPost({
    String username,
    String email,
    String password,
  }) async {
    Response response = await baseClient.post(
      '$BASE_URL',
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
      body: jsonEncode({
        'user': {
          'username': username,
          'email': email,
          'password': password,
        }
      }),
    );

    if (response.statusCode == 201) {
      return User.fromJson(response.asJSON());
    } else {
      throw ErrorMessage.fromResponse(response);
    }
  }

  Future<User> usersGet(String username) async {
    Response response = await baseClient.get(
      '$BASE_URL/me',
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $oauthAccessToken',
      },
    );

    return User.fromJson(response.asJSON());
  }

  Future<void> usersFollow(String username) {
    return baseClient.post(
      '$BASE_URL/$username/follow',
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $oauthAccessToken',
      },
    );
  }

  Future<void> usersUnfollow(String username) {
    return baseClient.delete(
      '$BASE_URL/$username/unfollow',
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $oauthAccessToken',
      },
    );
  }

  Future<String> usersLogin({String email, String password}) async {
    Response response = await baseClient.post(
      '$BASE_URL/login',
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
      body: jsonEncode({
        'user': {
          'email': email,
          'password': password,
        }
      }),
    );

    if (response.statusCode == 201) {
      return User.fromJson(response.asJSON()).token;
    } else {
      throw ErrorMessage.fromResponse(response);
    }
  }
}

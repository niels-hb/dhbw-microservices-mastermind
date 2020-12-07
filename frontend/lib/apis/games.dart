import 'dart:convert';
import 'dart:io';

import 'package:dhbw_swe_mastermind_frontend/interfaces/game.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/game_color.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/game_config.dart';
import 'package:dhbw_swe_mastermind_frontend/interfaces/round.dart';
import 'package:dhbw_swe_mastermind_frontend/services/api.dart';
import 'package:dhbw_swe_mastermind_frontend/util/error_message.dart';
import 'package:dhbw_swe_mastermind_frontend/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

mixin GamesApi {
  static const String BASE_URL = '${ApiService.API_BASE_URL}/games';

  String get oauthAccessToken;

  BaseClient get baseClient;

  Future<Game> gamesPost(GameConfig config) async {
    Response response = await baseClient.post(
      '$BASE_URL',
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $oauthAccessToken',
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
      body: jsonEncode({'game': config.toMap()}),
    );

    if (response.statusCode == 201) {
      return Game.fromJson(response.asJSON());
    } else {
      throw ErrorMessage.fromResponse(response);
    }
  }

  Future<List<Game>> gamesGetRanking({
    @required GameConfig filter,
    @required String endpoint,
  }) async {
    String query = filter == null
        ? null
        : '?pins=${filter.pins}&tries=${filter.maxRounds}&gameColors=${filter.gameColors.length}&allowDuplicateColors=${filter.allowDuplicateColors}&allowEmptyFields=${filter.allowEmptyFields}';

    Response response = await baseClient.get(
      '$BASE_URL/ranking/$endpoint${query ?? ''}',
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $oauthAccessToken',
      },
    );

    return (response.asJSON() as List<dynamic>)
        .map((game) => Game.fromJson(game))
        .toList();
  }

  Future<List<Game>> gamesGetHistoryFriends() async {
    Response response = await baseClient.get(
      '$BASE_URL/history/friends',
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $oauthAccessToken',
      },
    );

    return (response.asJSON() as List<dynamic>)
        .map((game) => Game.fromJson(game))
        .toList();
  }

  Future<Game> gamesReplay(Game game) async {
    Response response = await baseClient.post(
      '$BASE_URL/${game.id}',
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $oauthAccessToken',
      },
    );

    if (response.statusCode == 201) {
      return Game.fromJson(response.asJSON());
    } else {
      throw ErrorMessage.fromResponse(response);
    }
  }

  Future<Round> gamesPostRounds(Game game, List<GameColor> guess) async {
    Response response = await baseClient.post(
      '$BASE_URL/${game.id}/rounds',
      body: jsonEncode({
        'guess': guess.toMappedList(),
      }),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $oauthAccessToken',
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
    );

    if (response.statusCode == 201) {
      return Round.fromJson(response.asJSON());
    } else {
      throw ErrorMessage.fromResponse(response);
    }
  }

  Future<void> gamesDeleteRounds(Game game, Round round) {
    return baseClient.delete(
      '$BASE_URL/${game.id}/rounds/${round.id}',
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $oauthAccessToken',
      },
    );
  }
}

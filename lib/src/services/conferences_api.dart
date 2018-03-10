import 'dart:convert';
import 'dart:io';
import 'package:devoxx_flutter/config.dart';
import 'package:devoxx_flutter/src/models/e_day.dart';
import 'package:devoxx_flutter/src/utils/network_exception.dart';

class ConferencesApi {

  String _baseUrl;
  HttpClient _httpClient = new HttpClient();

  ConferencesApi(this._baseUrl);
  ConferencesApi.fromConfig() : this(CONFERENCE_API_BASE_URL);

  fetchAllSpeakers() async {
    try {
      var request = await _httpClient.getUrl(Uri.parse(this._baseUrl + '/speakers'));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        return JSON.decode(json);
      } else {
        throw new NetworkException('fetchAllSpeakers failed with code ' + response.statusCode.toString());
      }
    } catch (exception) {
      throw new NetworkException.withOrigin('fetchAllSpeakers failed', exception);
    }
  }

  fetchASpeaker(String speakerId) async {
    try {
      var request = await _httpClient.getUrl(Uri.parse(this._baseUrl + '/speakers/' + speakerId));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        return JSON.decode(json);
      } else {
        throw new NetworkException('fetchASpeaker failed with code ' + response.statusCode.toString());
      }
    } catch (exception) {
      throw new NetworkException.withOrigin('fetchASpeaker failed', exception);
    }
  }

  fetchASpeakerFromLink(String link) async {
    try {
      var request = await _httpClient.getUrl(Uri.parse(link));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        return JSON.decode(json);
      } else {
        throw new NetworkException('fetchASpeakerFromLink failed with code ' + response.statusCode.toString());
      }
    } catch (exception) {
      throw new NetworkException.withOrigin('fetchASpeakerFromLink failed', exception);
    }
  }

  fetchAllSlotsByDay(EDay day) async {
    try {
      var uri = Uri.parse(this._baseUrl + '/schedules/' + EDayAsString.asString(day));
      var request = await _httpClient.getUrl(uri);
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        return JSON.decode(json);
      } else {
        throw new NetworkException('fetchAllSlotsByDay failed with code ' + response.statusCode.toString());
      }
    } catch (exception) {
      throw new NetworkException.withOrigin('fetchAllSlotsByDay failed', exception);
    }
  }

  fetchATalkById(String talkId) async {
    try {
      var request = await _httpClient.getUrl(Uri.parse(this._baseUrl + '/talks/' + talkId));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        return JSON.decode(json);
      } else {
        throw new NetworkException('fetchAllTalksByDay failed with code ' + response.statusCode.toString());
      }
    } catch (exception) {
      throw new NetworkException.withOrigin('fetchAllTalksByDay failed', exception);
    }
  }

}
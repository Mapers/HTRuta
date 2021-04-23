import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class PushMessage {
  final String _uriHttps = 'https://fcm.googleapis.com/fcm/send';
  final String _keyCloudMessage = 'AAAAixz2zUw:APA91bHLwJ1v5W0iJvlM5EGfXMVNbgp5FEVlORXz1bw0DLnx1WFNZbEqz-x9y_CrMm9GkVP0DxX4Z16L4L5ALDH5uvzLicLxUzvdWOikiR4b8th5tOP6NTwLl68-_vYCEJGq78-nLYot';

  final http.Client client;
  PushMessage({@required this.client});

  Future<bool> sendPushMessage({@required String token, @required String title, @required String description, Map<String, String> data, bool displayNotification = true}) async {
    data ??= {};
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=$_keyCloudMessage'
      };

      final result = await http.post(
        _uriHttps,
        headers: headers,
        body: _constructFCMPayload(token, title, description, data),
      );
      return result.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  String _constructFCMPayload(String token, String title, String description, Map<String, String> data) {
    return jsonEncode({
      'priority': 'high',
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'display_notification': 'true',
        ...data,
      },
      'notification': {
        'title': title,
        'body': description
      },
      'to': token,
    });
  }

}
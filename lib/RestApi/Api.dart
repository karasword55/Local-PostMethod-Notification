import 'dart:io';
import 'package:http/http.dart' as http;

class Api {


  // Burada elle firebase'den bildirim göndermek yerine http kullanarak firebase'den bana notification
  // göndermesini istedim.

  final HttpClient httpClient = HttpClient();
  final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  final fcmKey = "AAAAmp0cYq0:APA91bFDEh6-R1Eftt5V0upKHsnmK2g7xvmV4-JUUAFsbHF0V42b0-mSTflcpN2WET4opLtOtTwySP_WS9n3qxIjCAej3Fr_86AwxMw8ZgzjhSwcIUU-vGVqKcUs58aIOx1aI1bYX9Of";

  void sendFcm(String title, String body, String fcmToken) async {
    
    var headers = {'Content-Type': 'application/json', 'Authorization': 'key=$fcmKey'};
    var request = http.Request('POST', Uri.parse(fcmUrl));
    request.body = '''{"to":"$fcmToken","priority":"high","notification":{"title":"$title","body":"$body","sound": "default"}}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
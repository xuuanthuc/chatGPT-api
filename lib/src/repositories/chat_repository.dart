import 'package:template/src/models/response/chat.dart';

import '../di/dependencies.dart';
import '../network/api_provider.dart';

class ChatRepository {
  final ApiProvider _apiProvider = getIt.get<ApiProvider>();

  Future<MessageData> sendMessage(String message) async {
    final res = await _apiProvider.post('/completions', params: {
      "model": "text-davinci-003",
      "prompt": message,
      "temperature": 0,
      "max_tokens": 3999,
    });
    final messageData = MessageData.fromJson(res);
    messageData.isChatGPT = true;
    return messageData;
  }
}

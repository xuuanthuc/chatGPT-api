import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/repositories/chat_repository.dart';
import '../../../models/response/chat.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository = ChatRepository();

  ChatCubit() : super(ChatInitial());

  void sendMessage(String message) async {
    state.message.add(
      MessageData(
        isChatGPT: false,
        choices: [
          Choices(text: message),
        ],
      ),
    );
    emit(ListMessageState(state));
    final resMessage = await _chatRepository.sendMessage(message);
    state.message.add(resMessage);
    emit(ListMessageState(state));
  }
}

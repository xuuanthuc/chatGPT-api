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
    state.message.add(
      MessageData(
        isLoading: true,
        isChatGPT: true,
        choices: [
          Choices(text: ''),
        ],
      ),
    );
    emit(SendingMessage(state));
    try {
      final resMessage = await _chatRepository.sendMessage(message);
      state.message.removeLast();
      state.message.add(resMessage);
      emit(SendMessageSuccess(state));
    } catch (e) {
      state.message.removeLast();
      emit(SendMessageFailed(state));
    }
  }
}

part of 'chat_cubit.dart';

abstract class ChatState {
  late List<MessageData> message;

  ChatState(ChatState? state) {
    message = state?.message ?? [];
  }
}

class ChatInitial extends ChatState {
  ChatInitial({ChatState? state}) : super(state);
}

class ListMessageState extends ChatState {
  ListMessageState(super.state);
}

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

class ChatDataState extends ChatState{
  ChatDataState(super.state);
}

class SendingMessage extends ChatDataState {
  SendingMessage(super.state);
}

class SendMessageSuccess extends ChatDataState {
  SendMessageSuccess(super.state);
}

class SendMessageFailed extends ChatDataState{
  SendMessageFailed(super.state);
}
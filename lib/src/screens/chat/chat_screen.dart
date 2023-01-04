import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/screens/chat/bloc/chat_cubit.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: const ChatView(),
    );
  }
}

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _sendMessage() {
    context.read<ChatCubit>().sendMessage(_editingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if(state is ListMessageState) {
          _editingController.clear();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                buildWhen: (previous, current) {
                  return (current is ListMessageState);
                },
                builder: (context, state) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return Text(state.message[index].choices?[0].text ?? '');
                    },
                    itemCount: state.message.length,
                  );
                },
              ),
            ),
            Container(
              color: Colors.redAccent,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _editingController,
                    ),
                  ),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(
                      CupertinoIcons.paperplane_fill,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

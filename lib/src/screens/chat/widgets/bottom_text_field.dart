import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/global/utilities/toast.dart';

import '../bloc/chat_cubit.dart';

class BottomChatField extends StatefulWidget {
  final Function(String) onSend;
  final Function scrollToBottom;

  const BottomChatField({
    Key? key,
    required this.onSend,
    required this.scrollToBottom,
  }) : super(key: key);

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  final TextEditingController _editingController = TextEditingController();
  bool _canSend = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) async {
        if (state is SendingMessage) {
          _editingController.clear();
          FocusManager.instance.primaryFocus?.unfocus();
        }
        if (state is SendMessageSuccess) {
          await Future.delayed(const Duration(milliseconds: 500));
          widget.scrollToBottom();
        }
        if(state is SendMessageFailed) {
          if (!mounted) return;
          appToast(context, message: 'Failed');
        }
      },
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is SendingMessage) {
            _canSend = false;
          }
          return Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 5, 12),
                  child: TextFormField(
                    controller: _editingController,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value.trim().isEmpty) {
                          _canSend = false;
                        } else {
                          _canSend = true;
                        }
                      });
                    },
                    onTap: () async {
                      await Future.delayed(const Duration(milliseconds: 300));
                      widget.scrollToBottom();
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "Aa...",
                      hintStyle: const TextStyle(color: Colors.white30),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      filled: true,
                      fillColor: Colors.white10,
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _canSend ? 40 : 0,
                height: 40,
                child: Visibility(
                  visible: _canSend,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => widget.onSend(_editingController.text),
                    icon: const Icon(
                      CupertinoIcons.paperplane_fill,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _canSend ? 4 : 10,
              ),
            ],
          );
        },
      ),
    );
  }
}

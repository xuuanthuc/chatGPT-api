import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:template/global/style/app_images.dart';
import 'package:template/src/models/response/chat.dart';

class MessageItem extends StatelessWidget {
  final MessageData message;

  const MessageItem({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: (message.isChatGPT ?? true)
          ? const Color(0xff343541)
          : const Color(0xff454654),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: (message.isChatGPT ?? true)
                  ? Colors.teal
                  : Colors.deepOrangeAccent,
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.all(5),
            child: SvgPicture.asset(
              (message.isChatGPT ?? true) ? AppImages.iOpenAI : AppImages.iUser,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          (message.isLoading ?? false)
              ? SizedBox(
                  height: 30,
                  child: Lottie.asset('assets/sending.json'),
                )
              : Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      (message.choices?[0].text ?? '').replaceFirst('\n\n', ''),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.8,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

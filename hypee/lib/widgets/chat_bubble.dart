import 'package:flutter/material.dart';
import 'package:hypee_content_creator/constants/app_colors.dart';
import 'package:hypee_content_creator/constants/app_paddings.dart';
import 'package:hypee_content_creator/widgets/app_text.dart';

class ChatBubble extends StatelessWidget {
  bool isSender;
  String? msg, time;

  ChatBubble({
    Key? key,
    required this.isSender,
    required this.msg,
    this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: isSender ? Colors.white : AppColors.primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: AppText(
                text: msg ?? "",
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isSender ? Colors.black : Colors.white,
              ),
            ),
            AppPaddings.heightSpace5,
            AppText(
              text: time ?? "10:00 PM",
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: isSender ? Colors.black : Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

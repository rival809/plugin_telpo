import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final double textSize;
  final double height;  // 新增 height 参数，设置按钮的高度

  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.textSize = 16.0, // 默认文本大小
    this.height = 68.0,   // 默认按钮高度为 68
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // 增加间距
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFbdeadc),
          padding: const EdgeInsets.all(10.0),
          fixedSize: Size(double.infinity, height), // 使用传入的 height 参数
        ),
        child: Text(buttonText,
          style: TextStyle(fontSize: textSize),
        ),
      ),
    );
  }
}


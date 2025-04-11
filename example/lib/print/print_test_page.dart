import 'package:flutter/material.dart';
import 'package:test_plugin_example/print/print_img_page.dart';
import 'package:test_plugin_example/print/print_text_page.dart';
import 'package:test_plugin_example/stab.dart';


class PrintTestPage extends StatelessWidget {
  final List<Widget> tabBodies = [
    PrintTextPage(),
    PrintImgPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 30),
        decoration: const BoxDecoration(
            color: Color(0xffF9DC62)
        ),
        child: STab(
          tabs: const [
            Text('Text', style: TextStyle(fontSize: 18, color: Colors.black),),
            Text('QrCode/Picture', style: TextStyle(fontSize: 18, color: Colors.black)),
          ],
          pages: tabBodies,
        ),
      ),
    );
  }
}
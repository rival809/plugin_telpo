import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:test_plugin/test_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:test_plugin_example/widget/custom_elevated_button.dart';
// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';


const String chineseText = "\n             烧烤" + "\n---------------------------" + "\n日期：2015-01-01 16:18:20"
    + "\n卡号：12378945664" + "\n单号：1001000000000529142" + "\n---------------------------"
    + "\n    项目        数量   单价  小计" + "\n秘制烤羊腿    1      56      56"
    + "\n烤火鸡            2      50      100" + "\n烤全羊            1      200    200"
    + "\n秘制烤鸡腿    1      56      56" + "\n烤牛腿            2      50      100"
    + "\n烤猪蹄            1      200    200" + "\n秘制烤牛腿    1      56      56"
    + "\n烤火鸡            2      50      100" + "\n烤全羊            1      200    200"
    + "\n秘制烤猪腿    1      56      56" + "\n烤火鸡            2      50      100"
    + "\n烤全牛            1      200    200" + "\n特色烤鸭腿    1      56      56"
    + "\n烤土鸡            2      50      100" + "\n烤全羊            1      200    200"
    + "\n秘制烤火腿    1      56      56" + "\n烤火鸡            2      50      100"
    + "\n烤全羊            1      200    200" + "\n秘制烤鸡腿    1      56      56"
    + "\n烤火鸡            2      50      100" + "\n烤全羊            1      200    200"
    + "\n秘制烤火腿    1      56      56" + "\n烤火鸡            2      50      100"
    + "\n烤全羊            1      200    200" + "\n秘制烤牛筋    1      56      56"
    + "\n烤土鸡            2      50      100" + "\n烤白鸽            1      200    200"
    + "\n秘制鸭下巴    1      56      56" + "\n烤火鸡            2      50      100"
    + "\n烤全牛            1      200    200" + "\n 合计：1000:00元" + "\n----------------------------"
    + "\n本卡金额：10000.00" + "\n累计消费：1000.00" + "\n本卡结余：9000.00" + "\n----------------------------"
    + "\n 地址：广东省佛山市南海区桂城街道桂澜南路45号鹏瑞利广场A317.B-18号铺" + "\n欢迎您的再次光临\n";
const String frenchText = "\nÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóô\n";
const String englishText = "\n---------------------------\n" + "Print Test:\n" + "Device Base Information\n"
    + "Printer Version:\n" + "V05.2.0.3\n" + "Printer Gray:3\n" + "Soft Version:\n"
    + "Demo.G50.0.Build140313\n" + "Battery Level:100%\n" + "CSQ Value:24\n"
    + "IMEI:86378902177527\n" + "---------------------------\n";

enum AlignOption { ALIGN_LEFT, ALIGN_MIDDLE, ALIGN_RIGHT }

class PrintImgPage extends StatefulWidget {
  @override
  _PrintImgPageState createState() => _PrintImgPageState();
}

class _PrintImgPageState extends State<PrintImgPage> {
  // Create a TextEditingController instance
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _barCodeController = TextEditingController();
  final TextEditingController _qrCodeController = TextEditingController();
  final TextEditingController _fontSizeController = TextEditingController(text: "20");
  final TextEditingController _grayLevelController = TextEditingController(text: "5");
  final TextEditingController _walkPaperLineController = TextEditingController(text: "50");
  final _testPlugin = TestPlugin();
  String? _internalModel;

  bool isLabelPrint = false;
  bool isMonoChecked = false;
  bool isItalicChecked = false;
  bool isBoldChecked = false;
  AlignOption _selectedAlign = AlignOption.ALIGN_LEFT; // Default selected option


  void _walkPaper() {
    String walkPaperValue = _walkPaperLineController.text;
    int? walkPaperNumber = int.tryParse(walkPaperValue);
    if (walkPaperNumber == null || walkPaperNumber < 0 || walkPaperNumber > 255) {
      _showToast("walkPaper must between 1 and 255");
      return;
    }
    _testPlugin.walkPaper(walkPaperNumber);
  }

  void _checkPrinterStatus() async {
    showDialog(
      context: context,
      barrierDismissible: false, // 禁止用户在打印时关闭对话框
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Printer"),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Checking Status..."),
            ],
          ),
        );
      },
    );


    String? status = await _testPlugin.checkStatus();

    // 关闭打印 Dialog
    Navigator.of(context).pop();

    _showToast("Printer Status: $status\n"
        + "refer:\n"
        + "NORMAL = 0x00\n"
        + "NO_PAPER = 0x10\n"
        + "OVER_HEAT = 0x11\n"
        + "NO_BLACK_BLOCK = 0x12\n"
        + "FONT_ERROR = 0x13\n"
        + "LOW_POWER = 0x14\n"
        + "PRT_BROKEN = 0x15\n"
        + "PRT_NOT_AUTH = 0x16");
  }

  void _printBarCode() async {

    if (_barCodeController.text.isEmpty) {
      _showToast("BarCode Content is empty");
      return;
    }

    _testPlugin.reset();
    _testPlugin.setGray(7);
    _testPlugin.printBarCode(_barCodeController.text, 320, 173, true);
    _testPlugin.addString("${_barCodeController.text}\n\n\n");



// 显示正在打印的 Dialog
    showDialog(
      context: context,
      barrierDismissible: false, // 禁止用户在打印时关闭对话框
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Printer"),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Printing..."),
            ],
          ),
        );
      },
    );


    // 打印并获取返回结果
    String? result = await _testPlugin.printString();

    // 关闭打印 Dialog
    Navigator.of(context).pop();

    // 根据返回结果判断显示的 Dialog
    if (result == null || result.isEmpty) {
      // 打印成功或没有错误，什么也不做
    } else if (result.contains("NoPaper")) {
      // 显示无纸张的 Dialog
      _showDialog("No Paper", "Please check the paper.");
    } else if (result.contains("OverHeat")) {
      // 显示过热的 Dialog
      _showDialog("Over Heat", "Printer is overheating.");
    } else if (result.contains("LowPower")) {
      // 显示电量低的 Dialog
      _showDialog("Low Power", "Printer is LowPower.");
    } else {
      // 处理其他错误
      _showToast("Print error: $result");
    }
  }

  void _printQrCode() async {

    if (_qrCodeController.text.isEmpty) {
      _showToast("QrCode Content is empty");
      return;
    }

    _testPlugin.reset();
    _testPlugin.setGray(7);
    _testPlugin.printQrCode(_qrCodeController.text, 256, true);
    _testPlugin.addString("${_qrCodeController.text}\n\n\n");




// 显示正在打印的 Dialog
    showDialog(
      context: context,
      barrierDismissible: false, // 禁止用户在打印时关闭对话框
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Printer"),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Printing..."),
            ],
          ),
        );
      },
    );


    // 打印并获取返回结果
    String? result = await _testPlugin.printString();

    // 关闭打印 Dialog
    Navigator.of(context).pop();

    // 根据返回结果判断显示的 Dialog
    if (result == null || result.isEmpty) {
      // 打印成功或没有错误，什么也不做
    } else if (result.contains("NoPaper")) {
      // 显示无纸张的 Dialog
      _showDialog("No Paper", "Please check the paper.");
    } else if (result.contains("OverHeat")) {
      // 显示过热的 Dialog
      _showDialog("Over Heat", "Printer is overheating.");
    } else if (result.contains("LowPower")) {
      // 显示电量低的 Dialog
      _showDialog("Low Power", "Printer is LowPower.");
    } else {
      // 处理其他错误
      _showToast("Print error: $result");
    }
  }

  void _printPicture() async {
    final ByteData bytes = await rootBundle.load('images/syhlogo.png');


    _testPlugin.reset();
    _testPlugin.setGray(7);
    _testPlugin.setAlign(1);
    // _testPlugin.addString(_barCodeController.text);



// 显示正在打印的 Dialog
    showDialog(
      context: context,
      barrierDismissible: false, // 禁止用户在打印时关闭对话框
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Printer"),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Printing..."),
            ],
          ),
        );
      },
    );

    _testPlugin.printLogo(
        bytes.buffer.asUint8List(), 'image/png', 'syhlogo.png', true);
    _testPlugin.addString("\n\n\n");

    // 打印并获取返回结果
    String? result = await _testPlugin.printString();

    // 关闭打印 Dialog
    Navigator.of(context).pop();

    // 根据返回结果判断显示的 Dialog
    if (result == null || result.isEmpty) {
      // 打印成功或没有错误，什么也不做
    } else if (result.contains("NoPaper")) {
      _showDialog("No Paper", "Please check the paper.");
    } else if (result.contains("OverHeat")) {
      _showDialog("Over Heat", "Printer is overheating.");
    } else if (result.contains("LowPower")) {
      _showDialog("Low Power", "Printer is LowPower.");
    } else {
      // 处理其他错误
      _showToast("Print error: $result");
    }
  }


  // 显示简单的 Dialog 方法
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // 关闭 Dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  @override
  void initState() {
    super.initState();
    // Perform your initialization here
    // sdk.init(); // Example of an SDK initialization
    _testPlugin.initPrinter();
    // _testPlugin.reset()
    _loadInternalModel();
  }

  Future<void> _loadInternalModel() async {
    String? internalModel = await _testPlugin.getInternalModel();
    setState(() {
      _internalModel = internalModel;
    });
  }

  @override
  void dispose() {
    _contentController.dispose(); // Dispose the controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              // Maker Layout
              // Step Layout
              // Step Layout (conditionally visible)

              // Print Format Layouts
              _buildBarCodeLayout(),
              const SizedBox(height: 10),
              _buildQrCodeLayout(),
              const SizedBox(height: 10,),
              CustomElevatedButton(
                onPressed: () {
                  _printPicture();
                },
                buttonText: 'Print Picture',
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildBarCodeLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text(
              'BarCode:',
              style: TextStyle(color: Color(0xFF6B6B6B),
                fontSize: 20.0, // 设置字体大小
              ),
            ),
            Expanded(
              child: TextField(
                controller: _barCodeController,
                decoration: const InputDecoration(

                  hintStyle: TextStyle(color: Color(0xFF6B6B6B),
                    fontSize: 20.0,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 22.0,
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,

              ),
            ),
          ],
        ),
        CustomElevatedButton(
          onPressed: () {
            _printBarCode();
          },
          buttonText: 'Print BarCode',
        ),
      ],
    );
  }

  Widget _buildQrCodeLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text(
              'QrCode:',
              style: TextStyle(color: Color(0xFF6B6B6B),
                fontSize: 20.0, // 设置字体大小
                ),
            ),
            Expanded(
              child: TextField(
                controller: _qrCodeController,
                decoration: const InputDecoration(

                  hintStyle: TextStyle(color: Color(0xFF6B6B6B),
                    fontSize: 30.0, // 设置字体大小
                  ),
                ),
                style: const TextStyle(
                  fontSize: 22.0, // 设置输入文本的字体大小
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,

              ),
            ),
          ],
        ),
        CustomElevatedButton(
          onPressed: () {
            _printQrCode();
          },
          buttonText: 'Print QrCode',
        ),
      ],
    );
  }



}

// void main() {
//   runApp(MaterialApp(
//     home: PrintImgPage(),
//   ));
// }
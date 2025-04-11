import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:test_plugin/test_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;

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
const String printerTypePrtCommon = "1";
const String printerTypeSY581 = "8";
const String printerType80mmUsbCommon = "9";
const List<String> modelPaperCut = ['M10', 'C2', 'C1'];

class PrintTextPage extends StatefulWidget {
  @override
  _PrintTextPageState createState() => _PrintTextPageState();
}

class _PrintTextPageState extends State<PrintTextPage> {
  // Create a TextEditingController instance

  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _leftMarginController = TextEditingController(text: "0");
  final TextEditingController _rowSpaceController = TextEditingController();
  final TextEditingController _fontSizeController = TextEditingController();
  final TextEditingController _grayLevelController = TextEditingController(text: "5");
  final TextEditingController _walkPaperLineController = TextEditingController(text: "50");
  final _testPlugin = TestPlugin();
  String? _internalModel;
  String? _printVersion;
  String? _printerType;
  int _fontSizeMin = 0;
  int _fontSizeMax = 0;
  int _rowSpaceMin = 0;
  int _rowSpaceMax = 0;
  int _grayLevelMin = 0;
  int _grayLevelMax = 0;

  bool _isUsbThermalPrinter = false;
  bool isLabelPrint = false;
  bool isMonoChecked = false;
  bool isItalicChecked = false;
  bool isBoldChecked = false;
  bool _isPortrait = false;
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
    String hexValue;
    if (status != null) {
      int decimalValue = int.parse(status); // 将字符串解析为整数
      hexValue = "0x${decimalValue.toRadixString(16).toUpperCase()}"; // 转换为十六进制并格式化
      // print(hexValue); // 输出 "0x10"
    } else {
      // print("Status is null");
      hexValue = "null";
    }


    // 关闭打印 Dialog
    Navigator.of(context).pop();

    _showToast("Printer Status: $hexValue\n"
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

  void _printText() async {


    _testPlugin.setAlign(_getAlignValue());
    // _testPlugin.setItalic(isItalicChecked);
    // _testPlugin.setBold(isBoldChecked);
    // _testPlugin.setMonoSpace(isMonoChecked);


    String leftMarginValue = _leftMarginController.text;
    int? leftMarginNumber = int.tryParse(leftMarginValue);
    if (leftMarginNumber == null || leftMarginNumber < 0 || leftMarginNumber > 255) {
      _showToast("leftMargin must between 0 and 255");
      return;
    }
    _testPlugin.setLeftIndent(leftMarginNumber);

    String rowSpaceValue = _rowSpaceController.text;
    int? rowSpaceNumber = int.tryParse(rowSpaceValue);
    if (rowSpaceNumber == null || rowSpaceNumber < _rowSpaceMin || rowSpaceNumber > _rowSpaceMax) {
      _showToast("rowSpace must between $_rowSpaceMin and $_rowSpaceMax");
      return;
    }
    _testPlugin.setLineSpace(rowSpaceNumber);


    String fontSizeValue = _fontSizeController.text;
    int? fontSizeNumber = int.tryParse(fontSizeValue);
    if (fontSizeNumber == null || fontSizeNumber < _fontSizeMin || fontSizeNumber > _fontSizeMax) {
      _showToast("fontSize must between $_fontSizeMin and $_fontSizeMax");
      return;
    }
    _testPlugin.setTextSize(fontSizeNumber);


    String grayLevelValue = _grayLevelController.text;
    int? grayLevelNumber = int.tryParse(grayLevelValue);
    if (grayLevelNumber == null || grayLevelNumber < _grayLevelMin || grayLevelNumber > _grayLevelMax) {
      _showToast("grayLevel must between $_grayLevelMin and $_grayLevelMax");
      return;
    }
    _testPlugin.setGray(grayLevelNumber);


    if (_contentController.text.isEmpty) {
      _showToast("Print Content is empty");
      return;
    }
    // _showToast("输入的数字是：$number");

    FocusScope.of(context).unfocus(); // 取消焦点

    Future.delayed(const Duration(milliseconds: 100), () {
      showDialog(
        context: context,
        barrierDismissible: false,
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

      // 当对话框关闭时也确保键盘不会再弹出
      Navigator.of(context).pop();
    });
    // FocusScope.of(context).unfocus();
    _testPlugin.addString(_contentController.text);
    _testPlugin.addString("\n\n\n");
    // 打印并获取返回结果
    String? result = await _testPlugin.printString();

    // 关闭打印 Dialog

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
    _getPrinterVersion();
    _getPrinterType();

  }


  Future<void> _getPrinterType() async {
    // Get the internal model from the plugin
    // 模拟获取打印机版本的异步操作
    // await Future.delayed(const Duration(seconds: 1)); // 模拟延迟
    // String? printType = await _testPlugin.getPrinterType();
    // bool? isUsbThermalPrinter = await _testPlugin.getPrinterType();
    String? printType = await _testPlugin.getPrinterType();
    developer.log('log', name: 'Printer print:$printType');
    print("Printer Type: $printType"); // 添加调试信息
    // Update state with the fetched internal model
    // setState(() {
    //   _printVersion = printVersion;
    // });
    // return printType;
    setState(() {
      _isUsbThermalPrinter = printType == null || printType.isEmpty || printType == "1";

      // 根据 _printerType 设置不同的范围
      if (_isUsbThermalPrinter) {
        _fontSizeController.text = '20';
        _rowSpaceController.text = '0';
        _fontSizeMin = 8;
        _fontSizeMax = 64;
        _rowSpaceMin = 0;
        _rowSpaceMax = 255;
        _grayLevelMin = 1;
        _grayLevelMax = 7;
      } else {
        _fontSizeController.text = '0';
        _rowSpaceController.text = '8';
        _fontSizeMin = 0;
        _fontSizeMax = 4;
        _rowSpaceMin = 1;
        _rowSpaceMax = 255;
        _grayLevelMin = 1;
        _grayLevelMax = 25;
      }
    });
  }


  Future<void> _getPrinterVersion() async {
    await Future.delayed(const Duration(seconds: 1)); // 模拟延迟
    String? printVersion = await _testPlugin.getPrinterVersion();
    setState(() {
      _printVersion = printVersion;
    });
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

    _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: _isPortrait ? _buildPortraitLayout() : _buildLandScapeLayout(),
    );
  }

  Widget _buildLandScapeLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Maker Layout
            _buildVersionLayout(),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _checkPrinterStatus();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: const Color(0xFFbdeadc), // Use your button color
              ),
              child: const Text('Check Printer Status'),
            ),
            // Step Layout
            // Step Layout (conditionally visible)
            isLabelPrint
                ? Column(
              children: [
                _buildStepLayout(),
                const SizedBox(height: 10),
                _buildAdapterLayout(),
                const SizedBox(height: 10),
                _buildGapLayout(),
                const SizedBox(height: 10),
                _buildRollbackLayout(),
                const SizedBox(height: 10),
                _buildPaperTypeLayout(),
                const SizedBox(height: 10),
              ],
            )
                : const SizedBox.shrink(),
            // Print Format Layouts
            _buildLandScapePrintFormatLayout1(),
            const SizedBox(height: 10),
            _buildPrintFormatLayout2(),
            const SizedBox(height: 10),
            _buildAlignRadioGroup(),
            const SizedBox(height: 10),
            _buildPrintMonoSettingLayout(),
            const SizedBox(height: 10),
            // Print Content
            _buildPrintContentLayout(),
            const SizedBox(height: 10),
            // Print Short Text Layout
          ],
        ),
      ),
    );
  }


  Widget _buildPortraitLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Maker Layout
            _buildVersionLayout(),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _checkPrinterStatus();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: const Color(0xFFbdeadc), // Use your button color
              ),
              child: const Text('Check Printer Status'),
            ),
            // Step Layout
            // Step Layout (conditionally visible)
            isLabelPrint
                ? Column(
              children: [
                _buildStepLayout(),
                const SizedBox(height: 10),
                _buildAdapterLayout(),
                const SizedBox(height: 10),
                _buildGapLayout(),
                const SizedBox(height: 10),
                _buildRollbackLayout(),
                const SizedBox(height: 10),
                _buildPaperTypeLayout(),
                const SizedBox(height: 10),
              ],
            )
                : const SizedBox.shrink(),
            // Print Format Layouts
            _buildPortraitPrintFormatLayout1(),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildAlignRadioGroup()),
                const SizedBox(height: 10),
                Expanded(child: _buildPrintMonoSettingLayout()),
              ],
            ),
            const SizedBox(height: 10),
            // Print Content
            _buildPrintContentLayout(),
            const SizedBox(height: 10),
            // Print Short Text Layout
          ],
        ),
      ),
    );
  }

  Widget _buildVersionLayout() {
    return Row(
      children: [
        const Text(
          'Printer Version: ',
          style: TextStyle(color: Color(0xFF6B6B6B)),
        ),
        Text(
          _printVersion ?? "",
          style: const TextStyle(color: Color(0xFF6B6B6B)),
        ),
      ],
    );
  }


  Widget _buildMakerLayout() {
    return Column(
      children: [
        const Row(
          children: [
            Text(
              'Walk Paper For Search Black Block:',
              style: TextStyle(color: Color(0xFF6B6B6B)),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '200',
                  hintStyle: TextStyle(color: Color(0xFF6B6B6B)),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const Row(
          children: [
            Text(
              'Walk Paper After Haved Search:',
              style: TextStyle(color: Color(0xFF6B6B6B)),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '50',
                  hintStyle: TextStyle(color: Color(0xFF6B6B6B)),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Black Block Detection'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            backgroundColor: const Color(0xFFbdeadc), // Use your button color
          ),
        ),
      ],
    );
  }

  Widget _buildStepLayout() {
    return Row(
      children: [
        const Text(
          'Walk Paper Lines(1-255)',
          style: TextStyle(color: Color(0xFF6B6B6B)),
        ),
        Expanded(
          child: TextField(
            controller: _walkPaperLineController,
            decoration: const InputDecoration(
              hintText: 'input paper line',
              hintStyle: TextStyle(color: Color(0xFF6B6B6B)),
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _walkPaper();
          },
          child: const Text('Walk Paper'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(150, 48),
            backgroundColor: const Color(0xFFbdeadc), // Use your button color
          ),
        ),
      ],
    );
  }

  Widget _buildAdapterLayout() {
    return Row(
      children: [
        const Text(
          'Adapter (maximum length):',
          style: TextStyle(color: Color(0xFF6B6B6B)),
        ),
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: '(1-255)',
              hintStyle: TextStyle(color: Color(0xFF6B6B6B)),
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Adapter'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(150, 48),
            backgroundColor: const Color(0xFFbdeadc), // Use your button color
          ),
        ),
      ],
    );
  }

  Widget _buildGapLayout() {
    return Row(
      children: [
        const Text(
          'Gap (Maximum length):',
          style: TextStyle(color: Color(0xFF6B6B6B)),
        ),
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: '(1-255)',
              hintStyle: TextStyle(color: Color(0xFF6B6B6B)),
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Next Gap'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(150, 48),
            backgroundColor: const Color(0xFFbdeadc), // Use your button color
          ),
        ),
      ],
    );
  }

  Widget _buildRollbackLayout() {
    return Row(
      children: [
        const Text(
          'Rollback Lines:',
          style: TextStyle(color: Color(0xFF6B6B6B)),
        ),
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: '(1-255)',
              hintStyle: TextStyle(color: Color(0xFF6B6B6B)),
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Rollback'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(150, 48),
            backgroundColor: const Color(0xFFbdeadc), // Use your button color
          ),
        ),
      ],
    );
  }

  Widget _buildPaperTypeLayout() {
    return Row(
      children: [
        const Text(
          'Paper Type:',
          style: TextStyle(color: Color(0xFF6B6B6B)),
        ),
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: '0/2',
              hintStyle: TextStyle(color: Color(0xFF6B6B6B)),
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(150, 48),
            backgroundColor: const Color(0xFFbdeadc), // Use your button color
          ),
          child: const Text('Paper Type'),
        ),
      ],
    );
  }

  Widget _buildLandScapePrintFormatLayout1() {
    return Row(
      children: [
        const Text(
          'Left Margin (0-255)',
          style: TextStyle(color: Color(0xFF6B6B6B)),
        ),
        Expanded(
          child: TextField(
            controller: _leftMarginController,
            decoration: const InputDecoration(
              hintText: '0',
              hintStyle: TextStyle(color: Color(0xFF6B6B6B)),
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [ FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')), // 只允许输入数字
                                LengthLimitingTextInputFormatter(3), // 限制输入长度为3位
                             ],
          ),
        ),
        const SizedBox(width: 10),
        Text('Row Space ($_rowSpaceMin-$_rowSpaceMax)',
          style: const TextStyle(color: Color(0xFF6B6B6B)),
        ),
        Expanded(
          child: TextField(
            controller: _rowSpaceController,
            decoration: const InputDecoration(
              hintText: '0',
              hintStyle: TextStyle(color: Color(0xFF6B6B6B)),
            ),
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')), // 只允许输入数字
              LengthLimitingTextInputFormatter(3), // 限制输入长度为3位
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitPrintFormatLayout1() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Left Margin (0-255)',
              style: TextStyle(color: Color(0xFF6B6B6B)),
            ),
            Expanded(
              child: TextField(
                controller: _leftMarginController,
                decoration: const InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(color: Color(0xFF6B6B6B)),
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [ FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')), // 只允许输入数字
                  LengthLimitingTextInputFormatter(3), // 限制输入长度为3位
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Row(
          children: [
            Text(
              'Row Space ($_rowSpaceMin-$_rowSpaceMax)',
              style: const TextStyle(color: Color(0xFF6B6B6B)),
            ),
            Expanded(
              child: TextField(
                controller: _rowSpaceController,
                decoration: const InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(color: Color(0xFF6B6B6B)),
                ),
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
                  // 只允许输入数字
                  LengthLimitingTextInputFormatter(3),
                  // 限制输入长度为3位
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Row(
          children: [
            Text(
              'Font Size ($_fontSizeMin-$_fontSizeMax)',
              style: TextStyle(color: Color(0xFF6B6B6B)),
            ),
            Expanded(
              child: TextField(
                controller: _fontSizeController,
                decoration: const InputDecoration(
                  hintText: '20',
                  hintStyle: TextStyle(color: Color(0xFF6B6B6B)),
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
                  // 只允许输入数字
                  LengthLimitingTextInputFormatter(2),
                  // 限制输入长度为3位
                ],
              ),
            )
          ],
        ),
        const SizedBox(width: 10),
        Row(
          children: [
            Text(
              'Gray Level ($_grayLevelMin-$_grayLevelMax)',
              style: TextStyle(color: Color(0xFF6B6B6B)),
            ),
            Expanded(
              child: TextField(
                controller: _grayLevelController,
                decoration: const InputDecoration(
                  hintText: '1',
                  hintStyle: TextStyle(color: Color(0xFF6B6B6B)),
                ),
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
                  // 只允许输入数字
                  LengthLimitingTextInputFormatter(2),
                  // 限制输入长度为3位
                ],
              ),
            ),
          ],
        )
      ],
    );
  }


  Widget _buildPrintFormatLayout2() {
    return Row(
      children: [
        Text(
          'Font Size ($_fontSizeMin-$_fontSizeMax)',
          style: TextStyle(color: Color(0xFF6B6B6B)),
        ),
        Expanded(
          child: TextField(
            controller: _fontSizeController,
            decoration: const InputDecoration(
              hintText: '20',
              hintStyle: TextStyle(color: Color(0xFF6B6B6B)),
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
              // 只允许输入数字
              LengthLimitingTextInputFormatter(2),
              // 限制输入长度为3位
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Gray Level ($_grayLevelMin-$_grayLevelMax)',
          style: const TextStyle(color: Color(0xFF6B6B6B)),
        ),
        Expanded(
          child: TextField(
            controller: _grayLevelController,
            decoration: const InputDecoration(
              hintText: '1',
              hintStyle: TextStyle(color: Color(0xFF6B6B6B)),
            ),
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
              // 只允许输入数字
              LengthLimitingTextInputFormatter(2),
              // 限制输入长度为3位
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrintContentLayout() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle button press for Chinese example
                  _contentController.text = chineseText;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFbdeadc), // Replace with your button color
                  padding: const EdgeInsets.all(10.0),
                  fixedSize: const Size(double.infinity, 48),
                ),
                child: const Text('CN Example'), // Replace with localization
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Handle button press for English example
                  _contentController.text = englishText;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFbdeadc),
                  padding: const EdgeInsets.all(10.0),
                  fixedSize: const Size(double.infinity, 48),
                ),
                child: const Text('EN Example'), // Replace with localization
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Handle button press for French example
                  _contentController.text = frenchText;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFbdeadc),
                  padding: const EdgeInsets.all(10.0),
                  fixedSize: const Size(double.infinity, 48),
                ),
                child: const Text('FR Example'), // Replace with localization
              ),
              const SizedBox(height: 10),

              if (_internalModel != null && modelPaperCut.any((model) => _internalModel!.contains(model)))
                ElevatedButton(
                  onPressed: () {
                    // Handle paper cut
                    _testPlugin.paperCut();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFbdeadc),
                    padding: const EdgeInsets.all(10.0),
                    fixedSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Paper Cut'), // Replace with localization
                ),
            ],
          ),
        ),
        const SizedBox(width: 10), // Spacing between columns
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: 'Input Content', // Replace with localization
                  hintStyle: const TextStyle(color: Color(0xFF6B6B6B)), // Replace with your color
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear,
                        color: Colors.red,
                      size: 50,  ),
                    onPressed: () {
                      _contentController.clear(); // Clear the content of the TextField
                    },
                  ),
                ),
                maxLines: 9,
                scrollPhysics: const AlwaysScrollableScrollPhysics(),
                style: const TextStyle(color: Color(0xFF6B6B6B)), // Replace with your color
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Handle print content
                  _printText();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFbdeadc),
                  padding: const EdgeInsets.all(10.0),
                  fixedSize: const Size(double.infinity, 48),
                ),
                child: const Text('Print Text'), // Replace with localization
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildPrintMonoSettingLayout() {
    return _isPortrait ? Column(
      children: _buildCheckboxes(),
    ) : Row(
      children: _buildCheckboxes().map((checkbox) => Expanded(child: checkbox)).toList(),
    );
  }

  List<Widget> _buildCheckboxes() {
    List<Widget> checkboxes = [];

    if (_isUsbThermalPrinter) {
      checkboxes.add(_buildCheckboxTile(
        label: 'Font Mono',
        value: isMonoChecked,
        onChanged: (value) {
          setState(() {
            isMonoChecked = value!;
          });
        },
      ));

      checkboxes.add(_buildCheckboxTile(
        label: 'Set Italic',
        value: isItalicChecked,
        onChanged: (value) {
          setState(() {
            isItalicChecked = value!;
          });
        },
      ));
    }

    checkboxes.add(_buildCheckboxTile(
      label: 'Set Bold',
      value: isBoldChecked,
      onChanged: (value) {
        setState(() {
          isBoldChecked = value!;
        });
      },
    ));

    return checkboxes;
  }

  Widget _buildCheckboxTile({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B6B6B),
            fontSize: 18, // Adjust the font size here
          ),
        ),
        const SizedBox(width: 10),
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }


  // Get the integer value associated with the selected alignment
  int _getAlignValue() {
    switch (_selectedAlign) {
      case AlignOption.ALIGN_LEFT:
        return 0;
      case AlignOption.ALIGN_MIDDLE:
        return 1;
      case AlignOption.ALIGN_RIGHT:
        return 2;
    }
  }

  // Align Radio Group
  Widget _buildAlignRadioGroup() {
    return Container(
      padding: const EdgeInsets.all(8.0), // 内边距
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green, // 边框颜色
          width: 3.0, // 边框宽度
        ),
        borderRadius: BorderRadius.circular(5.0), // 边框圆角
      ),
      child: _isPortrait
          ? Column( // 如果是竖屏，使用 Column
        children: [
          RadioListTile<AlignOption>(
            title: const Text('ALIGN_LEFT'),
            value: AlignOption.ALIGN_LEFT,
            groupValue: _selectedAlign,
            onChanged: (AlignOption? value) {
              setState(() {
                _selectedAlign = value!;
              });
            },
          ),
          RadioListTile<AlignOption>(
            title: const Text('ALIGN_MIDDLE'),
            value: AlignOption.ALIGN_MIDDLE,
            groupValue: _selectedAlign,
            onChanged: (AlignOption? value) {
              setState(() {
                _selectedAlign = value!;
              });
            },
          ),
          RadioListTile<AlignOption>(
            title: const Text('ALIGN_RIGHT'),
            value: AlignOption.ALIGN_RIGHT,
            groupValue: _selectedAlign,
            onChanged: (AlignOption? value) {
              setState(() {
                _selectedAlign = value!;
              });
            },
          ),
        ],
      )
          : Row( // 如果是横屏，使用 Row
        children: [
          Expanded(
            child: RadioListTile<AlignOption>(
              title: const Text('ALIGN_LEFT'),
              value: AlignOption.ALIGN_LEFT,
              groupValue: _selectedAlign,
              onChanged: (AlignOption? value) {
                setState(() {
                  _selectedAlign = value!;
                });
              },
            ),
          ),
          Expanded(
            child: RadioListTile<AlignOption>(
              title: const Text('ALIGN_MIDDLE'),
              value: AlignOption.ALIGN_MIDDLE,
              groupValue: _selectedAlign,
              onChanged: (AlignOption? value) {
                setState(() {
                  _selectedAlign = value!;
                });
              },
            ),
          ),
          Expanded(
            child: RadioListTile<AlignOption>(
              title: const Text('ALIGN_RIGHT'),
              value: AlignOption.ALIGN_RIGHT,
              groupValue: _selectedAlign,
              onChanged: (AlignOption? value) {
                setState(() {
                  _selectedAlign = value!;
                });
              },
            ),
          ),
        ],
      )
    );
  }


  Widget _buildPrintShortTextLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Left Margin',
              style: TextStyle(color: Color(0xFF6B6B6B)),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(color: Color(0xFF6B6B6B)),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Row(
          children: [
            Text(
              'Short Text Content',
              style: TextStyle(color: Color(0xFF6B6B6B)),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Short Text Within A Line',
                  hintStyle: TextStyle(color: Color(0xFF6B6B6B)),
                ),
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Print Short Text'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            backgroundColor: const Color(0xFFbdeadc), // Use your button color
          ),
        ),
      ],
    );
  }

  Widget _buildPrintCircleLayout() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Circle Print Interval', // Replace with localization
                style: TextStyle(
                  color: Color(0xFF6B6B6B), // Replace with your color
                ),
              ),
              Expanded(
                child: TextField(
                  key: Key('edittext_spin'), // Use a Key if needed
                  decoration: InputDecoration(
                    hintText: 'sec/time', // Replace with localization
                    hintStyle: TextStyle(color: Color(0xFF6B6B6B)), // Replace with your color
                  ),
                  style: TextStyle(color: Color(0xFF6B6B6B)), // Replace with your color
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        ElevatedButton(
          onPressed: () {
            // Handle circle print button press
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFbdeadc),
            fixedSize: const Size(double.infinity, 48),
            minimumSize: const Size(double.infinity, 48),

          ),
          child: const Text('Start Circle Paint'), // Replace with localization
        ),
      ],
    );
  }

}

// void main() {
//   runApp(MaterialApp(
//     home: PrintTextPage(),
//   ));
// }
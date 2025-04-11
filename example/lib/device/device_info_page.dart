import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:test_plugin/test_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:test_plugin_example/widget/custom_elevated_button.dart';
// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';



class DeviceInfoPage extends StatefulWidget {

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _DeviceInfoPageState createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  // Create a TextEditingController instance
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _walkPaperLineController = TextEditingController(text: "50");
  final _testPlugin = TestPlugin();
  String? _internalModel;
  bool _isPortrait = false;

// 添加 ValueNotifier
  final ValueNotifier<String> _modelNotifier = ValueNotifier<String>("");
  final ValueNotifier<String> _serialNoNotifier = ValueNotifier<String>("");
  final ValueNotifier<String> _macAddressNotifier = ValueNotifier<String>("");
  final ValueNotifier<String> _imei1Notifier = ValueNotifier<String>("");
  final ValueNotifier<String> _imei2Notifier = ValueNotifier<String>("");





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
    // 初始化 _barCodeNotifier 的值
    // _modelNotifier.value = _modelController.text;
  }

  // Asynchronous method to load internal model
  Future<void> _loadInternalModel() async {
    // Get the internal model from the plugin
    String? internalModel = await _testPlugin.getInternalModel();
    // Update state with the fetched internal model
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
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text("DeviceInfoPage"),

      ),
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
              _buildModelLayout(),
              const SizedBox(height: 10),
              _buildSerialNoLayout(),
              const SizedBox(height: 10),
              _buildMacAddressLayout(),
              const SizedBox(height: 10),
              _buildImei1Layout(),
              const SizedBox(height: 10),
              _buildImei2Layout(),
            ],
          ),
        ),
      ),
    );
  }



  Future<void> _fetchModel() async {

    await _showLoadingDialog(context);
    await Future.delayed(const Duration(milliseconds: 500));

    String? model = await _testPlugin.getInternalModel();
    _modelNotifier.value = model ?? "model null";

    Navigator.of(context).pop();
  }

  Future<void> _fetchProperties(String key, String defaultValue) async {

    await _showLoadingDialog(context);
    await Future.delayed(const Duration(milliseconds: 500));
    // String? key = await _testPlugin.getProperties(key, defaultValue);
    _serialNoNotifier.value = await _testPlugin.getProperties(key, defaultValue) ?? "key null";

    Navigator.of(context).pop();
  }


  Future<void> _fetchMacAddress() async {
    await _showLoadingDialog(context);
    await Future.delayed(const Duration(milliseconds: 500));
    // String? key = await _testPlugin.getProperties(key, defaultValue);
    _macAddressNotifier.value = await _testPlugin.getMacAddress() ?? "macAddress null";
    Navigator.of(context).pop();
  }

  Future<void> _fetchSerialNo() async {
    await _showLoadingDialog(context);
    await Future.delayed(const Duration(milliseconds: 500));
    // String? key = await _testPlugin.getProperties(key, defaultValue);
    _serialNoNotifier.value = await _testPlugin.getSerialNumber() ?? "serialNo null";
    Navigator.of(context).pop();
  }

  Future<void> _fetchImei1() async {
    await _showLoadingDialog(context);
    await Future.delayed(const Duration(milliseconds: 500));
    // String? key = await _testPlugin.getProperties(key, defaultValue);
    _imei1Notifier.value = await _testPlugin.getImei1() ?? "imei1 null";
    Navigator.of(context).pop();
  }


  Future<void> _fetchImei2() async {
    await _showLoadingDialog(context);
    await Future.delayed(const Duration(milliseconds: 500));
    // String? key = await _testPlugin.getProperties(key, defaultValue);
    _imei2Notifier.value = await _testPlugin.getImei2() ?? "imei2 null";
    Navigator.of(context).pop();
  }

  Future<void> _showLoadingDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // 禁止用户在打印时关闭对话框
      builder: (BuildContext context) {
        return const AlertDialog(
          content: SizedBox(
            width: 100,
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }


  Widget _buildModelLayout() {
    return _buildInfoLayout(
      buttonText: 'Get Model',
      onPressed: () async {
        await _fetchModel();
      },
      valueNotifier: _modelNotifier,
    );
  }

  Widget _buildSerialNoLayout() {
    return _buildInfoLayout(
      buttonText: 'Get Serial No',
      onPressed: () async {
        await _fetchSerialNo();
      },
      valueNotifier: _serialNoNotifier,
    );
  }

  Widget _buildMacAddressLayout() {
    return _buildInfoLayout(
      buttonText: 'Get MacAddress',
      onPressed: () async {
        await _fetchMacAddress();
      },
      valueNotifier: _macAddressNotifier,
    );
  }


  Widget _buildImei1Layout() {
    return _buildInfoLayout(
      buttonText: 'Get Imei1',
      onPressed: () async {
        await _fetchImei1();
      },
      valueNotifier: _imei1Notifier,
    );
  }


  Widget _buildImei2Layout() {
    return _buildInfoLayout(
      buttonText: 'Get Imei2',
      onPressed: () async {
        await _fetchImei2();
      },
      valueNotifier: _imei2Notifier,
    );
  }


  Widget _buildInfoLayout({
    required String buttonText,
    required VoidCallback onPressed,
    required ValueNotifier<String> valueNotifier,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: CustomElevatedButton(
            onPressed: onPressed,
            buttonText: buttonText,
            textSize: 14,
            height: 50,
          ),
        ),
        Expanded(
          flex: 1,
          child: ValueListenableBuilder<String>(
            valueListenable: valueNotifier,
            builder: (context, value, child) {
              return Container(
                padding: const EdgeInsets.all(8.0), // 内边距
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green, // 边框颜色
                    width: 3.0, // 边框宽度
                  ),
                  borderRadius: BorderRadius.circular(5.0), // 边框圆角
                ),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

}
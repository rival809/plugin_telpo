import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:test_plugin/test_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:test_plugin_example/widget/custom_elevated_button.dart';
// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';



class DisplayControlPage extends StatefulWidget {

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _DisplayControlPageState createState() => _DisplayControlPageState();
}

class _DisplayControlPageState extends State<DisplayControlPage> {
  // Create a TextEditingController instance
  final _testPlugin = TestPlugin();
  String? _internalModel;




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

  Future<void> _loadInternalModel() async {
    String? internalModel = await _testPlugin.getInternalModel();
    setState(() {
      _internalModel = internalModel;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text("DisplayControlPage"),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              Center( // Wrap the Text widget with Center
                child: Text(
                  'OSApi ( return int )',
                  style: TextStyle(fontSize: 24, color: Colors.red),
                ),
              ),
              const SizedBox(height: 10),
              _buildStatusBarControlLayout(),
              const SizedBox(height: 10),
              _buildNavigationBarControlLayout(),
              const SizedBox(height: 50),

              Center( // Wrap the Text widget with Center for the second title
                child: Text(
                  'ByBroadcast ( return void )',
                  style: TextStyle(fontSize: 24, color: Colors.red),
                ),
              ),
              const SizedBox(height: 10),
              _buildStatusBarControlLayoutByBroadcast(),
              const SizedBox(height: 10),
              _buildNavigationBarControlLayoutByBroadcast(),
            ],
          ),
        ),
      ),
    );
  }

  void _setStatusBarEnableByBroadcast(bool enable)  {
    _testPlugin.setDisplayControlStatusBarByDemoSDK(enable);
  }


  void _setNavigationBarEnableByBroadcast(bool enable)  {
    _testPlugin.setDisplayControlNavigationBarByDemoSDK(enable);
  }

  Future<void> _setStatusBarEnable(String tips, bool enable) async {
    String? result = await _testPlugin.setDisplayControlStatusBar(enable) ?? "$tips failed"; // 获取结果

    String toastMessage;
    if (result == "0") {
      toastMessage = "success";
    } else {
      toastMessage = "failed: $result";
    }

    _showToast(toastMessage);
  }

  Future<void> _setNavigationBarEnable(String tips, bool enable) async {
    String? result = await _testPlugin.setDisplayControlNavigationBar(enable) ?? "$tips failed"; // 获取结果

    String toastMessage;
    if (result == "0") {
      toastMessage = "success";
    } else {
      toastMessage = "failed: $result";
    }

    _showToast(toastMessage);
  }


  Widget _buildStatusBarControlLayoutByBroadcast() {
    return _buildLayout(
      text: 'Status\nBar',
      onEnablePressed: ()  {
        _setStatusBarEnableByBroadcast(true);
      },
      onDisablePressed: ()  {
        _setStatusBarEnableByBroadcast(false);
      },
    );
  }


  Widget _buildNavigationBarControlLayoutByBroadcast() {
    return _buildLayout(
      text: 'Navigation\nBar',
      onEnablePressed: ()  {
        _setNavigationBarEnableByBroadcast(true);
      },
      onDisablePressed: ()  {
        _setNavigationBarEnableByBroadcast(false);
      },
    );
  }


  Widget _buildStatusBarControlLayout() {
    return _buildLayout(
      text: 'Status\nBar',
      onEnablePressed: () async {
        await _setStatusBarEnable("Status Bar", true);
      },
      onDisablePressed: () async {
        await _setStatusBarEnable("Status Bar", false);
      },
    );
  }

  Widget _buildNavigationBarControlLayout() {
    return _buildLayout(
      text: 'Navigation\nBar',
      onEnablePressed: () async {
        await _setNavigationBarEnable("Navigation Bar", true);
      },
      onDisablePressed: () async {
        await _setNavigationBarEnable("Navigation Bar", false);
      },
    );
  }



  Widget _buildLayout({
    required String text,
    required VoidCallback onEnablePressed,
    required VoidCallback onDisablePressed,
  }) {
    return Row(
      children: [
        // Text占用一半的宽度
        Expanded(
          flex: 2,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 22.0,
              color: Colors.black, // 文本颜色可以根据需求调整
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // 启用和禁用按钮平分剩下的一半宽度
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: CustomElevatedButton(
                  onPressed: onEnablePressed,
                  buttonText:  'Enable',
                  textSize: 14,
                  height: 45,
                ),
              ),
              Expanded(
                child: CustomElevatedButton(
                  onPressed: onDisablePressed,
                  buttonText:  'Disable',
                  textSize: 14,
                  height: 45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



}
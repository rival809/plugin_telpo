import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'test_plugin_platform_interface.dart';
import 'constant.dart';

/// An implementation of [TestPluginPlatform] that uses method channels.
class MethodChannelTestPlugin extends TestPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('test_plugin');

  // final _eventChannel = const EventChannel('test_plugin/result');


  // void listenForResults() {
  //   _eventChannel.receiveBroadcastStream().listen((data) {
  //     // 处理扫描结果
  //     print('Scanned result: $data');
  //   }, onError: (error) {
  //     print('Error: $error');
  //   });
  // }

  @override
  Future<String?> scanQrCode() async {
    final result =
    await methodChannel.invokeMethod<String>(Constants.scanQrCode);
    return result;
  }
  
  
  @override
  Future<String?> getPlatformVersion() async {
    final version =
    await methodChannel.invokeMethod<String>(Constants.deviceInfoGetPlatformVersion);
    return version;
  }


  @override
  Future<bool?> getInstallServiceApk() async {
    final status =
    await methodChannel.invokeMethod<bool>(Constants.deviceInfoGetInstallServiceApk);
    return status;
  }


  @override
  Future<String?> getProperties(String key, String defaultValue) async {
    final value =
    await methodChannel.invokeMethod<String>(Constants.deviceInfoGetProperties, [key, defaultValue]);
    return value;
  }



  @override
  void setDisplayControlStatusBarByBroadcast(bool enable) {
    methodChannel.invokeMethod<void>(Constants.displayControlSetStatusBarByBroadcast, [enable]);
  }



  @override
  void setDisplayControlNavigationBarByBroadcast(bool enable) {
    methodChannel.invokeMethod<void>(Constants.displayControlSetNavigationBarByBroadcast, [enable]);
  }



  @override
  Future<String?> setDisplayControlStatusBar(bool enable) async {
    final result =
    await methodChannel.invokeMethod<String>(Constants.displayControlSetStatusBar, [enable]);
    return result;
  }


  @override
  Future<String?> setDisplayControlNavigationBar(bool enable) async {
    final result =
    await methodChannel.invokeMethod<String>(Constants.displayControlSetNavigationBar, [enable]);
    return result;
  }


  @override
  Future<String?> getMacAddress() async {
    final macAddress =
    await methodChannel.invokeMethod<String>(Constants.deviceInfoGetMacAddress);
    return macAddress;
  }


  @override
  Future<String?> getSerialNumber() async {
    final serialNumber =
    await methodChannel.invokeMethod<String>(Constants.deviceInfoGetSerialNo);
    return serialNumber;
  }


  @override
  Future<String?> getImei1() async {
    final imei1 =
    await methodChannel.invokeMethod<String>(Constants.deviceInfoGetImei1);
    return imei1;
  }

  @override
  Future<String?> getImei2() async {
    final imei2 =
    await methodChannel.invokeMethod<String>(Constants.deviceInfoGetImei2);
    return imei2;
  }

  @override
  Future<String?> getInternalModel() async {
    final internalModel =
    await methodChannel.invokeMethod<String>(Constants.deviceInfoGetInternalModel);
    return internalModel;
  }


  ///checkStatus
  @override
  Future<String?> getPrinterVersion() async {
    // _printerChannel.invokeMethod(Constants.printerReset);
    // methodChannel.invokeMethod<void>(Constants.printerReset);
    final version =
    await methodChannel.invokeMethod<String>(Constants.printerGetVersion);
    return version;
  }

  ///checkStatus
  @override
  Future<String?> getPrinterType() async {
    // _printerChannel.invokeMethod(Constants.printerReset);
    // methodChannel.invokeMethod<void>(Constants.printerReset);
    final type =
    await methodChannel.invokeMethod<String>(Constants.printerGetType);
    return type;
  }


  ///checkStatus
  @override
  Future<String?> checkStatus() async {
    // _printerChannel.invokeMethod(Constants.printerReset);
    // methodChannel.invokeMethod<void>(Constants.printerReset);
    final status =
    await methodChannel.invokeMethod<String>(Constants.printerCheckStatus);
    return status;
  }

  ///initPrinter
  @override
  void initPrinter() {
    // _printerChannel.invokeMethod(Constants.printerReset);
    methodChannel.invokeMethod<void>(Constants.printerInit);
    // throw UnimplementedError('reset() has not been implemented.');
  }

  ///reset
  @override
  void reset() {
    // _printerChannel.invokeMethod(Constants.printerReset);
    methodChannel.invokeMethod<void>(Constants.printerReset);
    // throw UnimplementedError('reset() has not been implemented.');
  }


  ///printLogo
  @override
  void printLogo(Uint8List image, String type, String name, bool buffer) {
    methodChannel.invokeMethod<void>(Constants.printerPrintLogo, {'image': image, "type": type, "name": name, "buffer": buffer});
  }

  ///printQrCode
  @override
  void printQrCode(String qrcodeStr, int qrcodeSize, bool buffer) {
    // methodChannel.invokeMethod<void>(Constants.printerPrintQrCode, [qrcodeStr, qrcodeSize, buffer]);
    methodChannel.invokeMethod<void>(Constants.printerPrintQrCode,
        {'qrcodeStr': qrcodeStr, 'qrcodeSize': qrcodeSize, 'buffer': buffer});
  }


  ///printBarCode
  @override
  void printBarCode(String barcodeStr, int bmpWidth, int bmpHeight, bool buffer) {
    methodChannel.invokeMethod<void>(Constants.printerPrintBarCode, [barcodeStr, bmpWidth, bmpHeight, buffer]);
  }


  ///paperCut
  @override
  void paperCut() {
    // _printerChannel.invokeMethod(Constants.printerPaperCut);
    methodChannel.invokeMethod<void>(Constants.printerPaperCut);
  }

  ///addString
  @override
  void addString(String printContent) {
    // _printerChannel.invokeMethod(Constants.printerAddString);
    methodChannel
        .invokeMethod<void>(Constants.printerAddString, [printContent]);
  }

  ///printString
  @override
  Future<String?> printString() async {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    final result =
    await methodChannel.invokeMethod<String>(Constants.printerPrintString);
    return result;
  }

  ///setLeftIndent
  @override
  void setLeftIndent(int leftDistance) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    methodChannel
        .invokeMethod<void>(Constants.printerSetLeftIndent, [leftDistance]);
  }

  ///setLineSpace
  @override
  void setLineSpace(int lineDistance) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    methodChannel
        .invokeMethod<void>(Constants.printerSetLineSpace, [lineDistance]);
  }

  ///setTextSize
  @override
  void setTextSize(int size) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    methodChannel.invokeMethod<void>(Constants.printerSetTextSize, [size]);
  }

  ///setTextGray
  @override
  void setGray(int gray) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    methodChannel.invokeMethod<void>(Constants.printerSetGray, [gray]);
  }

  ///walkPaper
  @override
  void walkPaper(int line) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    methodChannel.invokeMethod<void>(Constants.printerWalkPaper, [line]);
  }

  ///setAlign
  @override
  void setAlign(int mode) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    methodChannel.invokeMethod<void>(Constants.printerSetAlign, [mode]);
  }

  ///setBold
  @override
  void setBold(bool bold) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    methodChannel.invokeMethod<void>(Constants.printerSetBold, [bold]);
  }

  ///setItalic
  @override
  void setItalic(bool italic) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    methodChannel.invokeMethod<void>(Constants.printerSetItalic, [italic]);
  }

  ///setThripleHeight
  @override
  void setThripleHeight(bool thripleHeight) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    methodChannel.invokeMethod<void>(
        Constants.printerSetThripleHeight, [thripleHeight]);
  }

  ///enlargeFontSize
  @override
  void enlargeFontSize(bool openingTwoWidth) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    methodChannel.invokeMethod<void>(
        Constants.printerEnlargeFontSize, [openingTwoWidth]);
  }

  ///setMonoSpace
  @override
  void setMonoSpace(bool monoSpace) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    methodChannel
        .invokeMethod<void>(Constants.printerSetMonoSpace, [monoSpace]);
  }
}

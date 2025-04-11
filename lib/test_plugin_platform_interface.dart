import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'test_plugin_method_channel.dart';
import 'package:flutter/services.dart';

abstract class TestPluginPlatform extends PlatformInterface {
  /// Constructs a TestPluginPlatform.
  TestPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static TestPluginPlatform _instance = MethodChannelTestPlugin();

  /// The default instance of [TestPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelTestPlugin].
  static TestPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TestPluginPlatform] when
  /// they register themselves.
  static set instance(TestPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> scanQrCode() {
    throw UnimplementedError('scanQrCode() has not been implemented.');
  }
  
  
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }


  Future<bool?> getInstallServiceApk() {
    throw UnimplementedError('getInstallServiceApk() has not been implemented.');
  }


  Future<String?> getProperties(String key, String defaultValue) {
    throw UnimplementedError('getProperties() has not been implemented.');
  }



  void setDisplayControlStatusBarByBroadcast(bool enable) {
    throw UnimplementedError('setDisplayControlStatusBarByBroadcast() has not been implemented.');
  }



  void setDisplayControlNavigationBarByBroadcast(bool enable) {
    throw UnimplementedError('setDisplayControlNavigationBarByBroadcast() has not been implemented.');
  }



  Future<String?> setDisplayControlStatusBar(bool enable) {
    throw UnimplementedError('setDisplayControlStatusBar() has not been implemented.');
  }


  Future<String?> setDisplayControlNavigationBar(bool enable) {
    throw UnimplementedError('setDisplayControlNavigationBar() has not been implemented.');
  }


  Future<String?> getMacAddress() {
    throw UnimplementedError('getMacAddress() has not been implemented.');
  }


  Future<String?> getSerialNumber() {
    throw UnimplementedError('getSerialNumber() has not been implemented.');
  }


  Future<String?> getImei1() {
    throw UnimplementedError('getImei1() has not been implemented.');
  }

  Future<String?> getImei2() {
    throw UnimplementedError('getImei2() has not been implemented.');
  }


  Future<String?> getInternalModel() {
    throw UnimplementedError('getInternalModel() has not been implemented.');
  }

  Future<String?> getPrinterVersion() {
    // _printerChannel.invokeMethod(Constants.printerReset);
    // methodChannel.invokeMethod<void>(Constants.printerReset);
    throw UnimplementedError('getVersion() has not been implemented.');
  }


  Future<String?> getPrinterType() {
    // _printerChannel.invokeMethod(Constants.printerReset);
    // methodChannel.invokeMethod<void>(Constants.printerReset);
    throw UnimplementedError('getPrinterType() has not been implemented.');
  }


  Future<String?> checkStatus() {
    // _printerChannel.invokeMethod(Constants.printerReset);
    // methodChannel.invokeMethod<void>(Constants.printerReset);
    throw UnimplementedError('initPrinter() has not been implemented.');
  }

  void initPrinter() {
    // _printerChannel.invokeMethod(Constants.printerReset);
    // methodChannel.invokeMethod<void>(Constants.printerReset);
    throw UnimplementedError('initPrinter() has not been implemented.');
  }

  ///reset
  void reset() {
    // _printerChannel.invokeMethod(Constants.printerReset);
    // methodChannel.invokeMethod<void>(Constants.printerReset);
    throw UnimplementedError('reset() has not been implemented.');
  }


  ///paperCut
  void printLogo(Uint8List image, String type, String name, bool buffer) {
    // _printerChannel.invokeMethod(Constants.printerPaperCut);
    // methodChannel.invokeMethod<void>(Constants.printerPaperCut);
    throw UnimplementedError('printLogo() has not been implemented.');
  }


  ///paperCut
  void printQrCode(String qrcodeStr, int qrcodeSize, bool buffer) {
    // _printerChannel.invokeMethod(Constants.printerPaperCut);
    // methodChannel.invokeMethod<void>(Constants.printerPaperCut);
    throw UnimplementedError('printQrCode() has not been implemented.');
  }


  ///paperCut
  void printBarCode(String barcodeStr, int bmpWidth, int bmpHeight, bool buffer) {
    // _printerChannel.invokeMethod(Constants.printerPaperCut);
    // methodChannel.invokeMethod<void>(Constants.printerPaperCut);
    throw UnimplementedError('printBarCode() has not been implemented.');
  }

  ///paperCut
  void paperCut() {
    // _printerChannel.invokeMethod(Constants.printerPaperCut);
    // methodChannel.invokeMethod<void>(Constants.printerPaperCut);
    throw UnimplementedError('paperCut() has not been implemented.');
  }

  ///addString
  void addString(String printContent) {
    // _printerChannel.invokeMethod(Constants.printerAddString);
    // methodChannel.invokeMethod<void>(Constants.printerAddString);
    throw UnimplementedError('addString() has not been implemented.');
  }

  ///printString
  Future<String?> printString() {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    // methodChannel.invokeMethod<void>(Constants.printerPrintString);
    throw UnimplementedError('printString() has not been implemented.');
  }

  ///setLeftIndent
  void setLeftIndent(int leftDistance) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    throw UnimplementedError('setLeftIndent() has not been implemented.');
  }

  ///setLineSpace
  void setLineSpace(int lineDistance) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    throw UnimplementedError('setLineSpace() has not been implemented.');
  }

  ///setTextSize
  void setTextSize(int size) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    throw UnimplementedError('setTextSize() has not been implemented.');
  }

  ///setGray
  void setGray(int gray) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    throw UnimplementedError('setGray() has not been implemented.');
  }

  ///walkPaper
  @override
  void walkPaper(int line) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    throw UnimplementedError('walkPaper() has not been implemented.');
  }

  ///setAlign
  @override
  void setAlign(int mode) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    throw UnimplementedError('setAlign() has not been implemented.');
  }

  ///setBold
  @override
  void setBold(bool bold) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    throw UnimplementedError('setBold() has not been implemented.');
  }

  ///setItalic
  @override
  void setItalic(bool italic) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    throw UnimplementedError('setItalic() has not been implemented.');
  }

  ///setThripleHeight
  @override
  void setThripleHeight(bool thripleHeight) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    throw UnimplementedError('setThripleHeight() has not been implemented.');
  }

  ///enlargeFontSize
  @override
  void enlargeFontSize(bool openingTwoWidth) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    throw UnimplementedError('enlargeFontSize() has not been implemented.');
  }

  ///setMonoSpace
  @override
  void setMonoSpace(bool monoSpace) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    throw UnimplementedError('setMonoSpace() has not been implemented.');
  }
}

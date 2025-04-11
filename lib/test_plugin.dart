
// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:ffi';

import 'package:flutter/services.dart';
import 'test_plugin_platform_interface.dart';

class TestPlugin {
  Future<String?> scanQrCode() {
    return TestPluginPlatform.instance.scanQrCode();
  }
  
  Future<String?> getPlatformVersion() {
    return TestPluginPlatform.instance.getPlatformVersion();
  }

  Future<bool?> getInstallServiceApk() {
    return TestPluginPlatform.instance.getInstallServiceApk();
  }

  Future<String?> getProperties(String key, String defaultValue) {
    return TestPluginPlatform.instance.getProperties(key, defaultValue);
  }


  void setDisplayControlStatusBarByDemoSDK(bool enable) {
    TestPluginPlatform.instance.setDisplayControlStatusBarByBroadcast(enable);
  }


  void setDisplayControlNavigationBarByDemoSDK(bool enable) {
    TestPluginPlatform.instance.setDisplayControlNavigationBarByBroadcast(enable);
  }


  Future<String?> setDisplayControlStatusBar(bool enable) {
    return TestPluginPlatform.instance.setDisplayControlStatusBar(enable);
  }


  Future<String?> setDisplayControlNavigationBar(bool enable) {
    return TestPluginPlatform.instance.setDisplayControlNavigationBar(enable);
  }


  Future<String?> getMacAddress() {
    return TestPluginPlatform.instance.getMacAddress();
  }


  Future<String?> getSerialNumber() {
    return TestPluginPlatform.instance.getSerialNumber();
  }


  Future<String?> getImei1() {
    return TestPluginPlatform.instance.getImei1();
  }

  Future<String?> getImei2() {
    return TestPluginPlatform.instance.getImei2();
  }

  Future<String?> getInternalModel() {
    return TestPluginPlatform.instance.getInternalModel();
  }

  Future<String?> getPrinterVersion() {
    return TestPluginPlatform.instance.getPrinterVersion();
  }


  Future<String?> getPrinterType() {
    return TestPluginPlatform.instance.getPrinterType();
  }


  Future<String?> checkStatus() {
    return TestPluginPlatform.instance.checkStatus();
  }


  void initPrinter() {
    TestPluginPlatform.instance.initPrinter();
  }

  ///reset
  void reset() {
    TestPluginPlatform.instance.reset();
  }


  ///printLogo
  void printLogo(Uint8List image, String type, String name, bool buffer) {
    TestPluginPlatform.instance.printLogo(image, type, name, buffer);
  }


  ///printQrCode
  void printQrCode(String qrcodeStr, int qrcodeSize, bool buffer) {
    TestPluginPlatform.instance.printQrCode(qrcodeStr, qrcodeSize, buffer);
  }


  ///printBarCode
  void printBarCode(String barcodeStr, int bmpWidth, int bmpHeight, bool buffer) {
    TestPluginPlatform.instance.printBarCode(barcodeStr, bmpWidth, bmpHeight, buffer);
  }


  ///paperCut
  void paperCut() {
    TestPluginPlatform.instance.paperCut();
  }


  ///addString
  void addString(String printContent) {
    TestPluginPlatform.instance.addString(printContent);

  }

  ///printString
  Future<String?> printString() {
    return TestPluginPlatform.instance.printString();
  }

  ///setLeftIndent
  void setLeftIndent(int leftDistance) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    TestPluginPlatform.instance.setLeftIndent(leftDistance);

  }

  ///setLineSpace
  void setLineSpace(int lineDistance) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    TestPluginPlatform.instance.setLineSpace(lineDistance);
  }

  ///setTextSize
  void setTextSize(int size) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    TestPluginPlatform.instance.setTextSize(size);
  }


  ///setGray
  void setGray(int gray) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    TestPluginPlatform.instance.setGray(gray);
  }


  ///walkPaper
  void walkPaper(int line) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    TestPluginPlatform.instance.walkPaper(line);
  }

  ///setAlign
  void setAlign(int mode) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    TestPluginPlatform.instance.setAlign(mode);
  }


  ///setBold
  void setBold(bool bold) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    TestPluginPlatform.instance.setBold(bold);
  }


  ///setItalic
  void setItalic(bool italic) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    TestPluginPlatform.instance.setItalic(italic);
  }


  ///setThripleHeight
  void setThripleHeight(bool thripleHeight) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    TestPluginPlatform.instance.setThripleHeight(thripleHeight);
  }


  ///enlargeFontSize
  void enlargeFontSize(bool openingTwoWidth) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    TestPluginPlatform.instance.enlargeFontSize(openingTwoWidth);
  }


  ///setMonoSpace
  void setMonoSpace(bool monoSpace) {
    // _printerChannel.invokeMethod(Constants.printerPrintString);
    TestPluginPlatform.instance.setMonoSpace(monoSpace);
  }
}

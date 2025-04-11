package com.example.test_plugin

import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.app.Activity
import android.content.pm.PackageManager
import android.text.TextUtils
import com.android.common.osapi.OSApi
import com.android.common.osapi.impl.IDeviceInfoControl
import com.common.apiutil.printer.UsbThermalPrinter
import com.common.apiutil.util.SDKUtil
import com.common.apiutil.util.SystemUtil
import com.common.apiutil.system.SystemApiUtil;
import com.google.zxing.BarcodeFormat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import androidx.activity.result.ActivityResultLauncher
import androidx.appcompat.app.AppCompatActivity
import com.android.common.osapi.impl.IDisplayControl
import io.flutter.plugin.common.EventChannel


/** TelpoPlugin */
// https://www.jianshu.com/p/94501cd2e025
// https://segmentfault.com/a/1190000044942297
// https://blog.csdn.net/litz52001/article/details/139348045
class TestPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var eventChannel : EventChannel
  private lateinit var context : Context
  private lateinit var activity: Activity
  private lateinit var binding: ActivityPluginBinding
  private var result: MethodChannel.Result? = null
  var iDeviceInfoControl: IDeviceInfoControl? = null
  var iDisplayControl: IDisplayControl? = null
  var mEventSink: EventChannel.EventSink? = null
  private var mSystemLib : SystemApiUtil? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "test_plugin")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
    SDKUtil.getInstance(context).initSDK()
    val osApi = OSApi(context)
    iDeviceInfoControl = osApi.deviceInfoControl
    iDisplayControl = osApi.displayControl
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "test_plugin/result")
    eventChannel.setStreamHandler(object :  EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
          mEventSink = events
        }

        override fun onCancel(arguments: Any?) {
          mEventSink = null
        }
    })
//    activity = flutterPluginBinding.activity

  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    this.result = result
    when (call.method) {


      Constant.METHOD_SCAN_QRCODE -> {
        scanQrCode()
      }

      Constant.METHOD_DEVICE_INFO_GET_PLATFORM_VERSION -> {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }


      Constant.METHOD_DEVICE_INFO_GET_INSTALL_SERVICE_APK -> {
        result.success(SystemUtil.isInstallServiceApk())
      }


      Constant.METHOD_DEVICE_INFO_GET_PROPERTIES -> {
        val key: String = (call.arguments as ArrayList<String>)[0]
        val defaultValue: String = (call.arguments as ArrayList<String>)[1]

        result.success("${getProperties(key, defaultValue)}")
      }


      Constant.METHOD_DEVICE_INFO_GET_MAC_ADDRESS -> {

        result.success("${iDeviceInfoControl?.wifiMac}")
      }


      Constant.METHOD_DEVICE_INFO_GET_SERIAL_NO -> {

        val serialNumber = iDeviceInfoControl?.serialNumber

        result.success("${if (TextUtils.isEmpty(serialNumber)) getProperties("ro.serialno", "serialNumber null") else serialNumber}")
      }


      Constant.METHOD_DEVICE_INFO_GET_IMEI1 -> {

        val imei = iDeviceInfoControl?.getIMEI(0)
        if (imei.isNullOrEmpty()) {
          result.success("${getProperties("persist.sys.imei1", "imei1 null")}")
        } else {
          result.success(imei)
        }
      }


      Constant.METHOD_DEVICE_INFO_GET_IMEI2 -> {

        val imei = iDeviceInfoControl?.getIMEI(1)
        if (imei.isNullOrEmpty()) {
          result.success("${getProperties("persist.sys.imei2", "imei2 null")}")
        } else {
          result.success(imei)
        }
      }


      Constant.METHOD_DEVICE_INFO_GET_INTERNAL_MODEL -> {
        result.success("${SystemUtil.getInternalModel()}")
      }

      Constant.METHOD_PRINTER_GET_VERSION -> {
        result.success("${PrintUtil.getVersion()}")
      }


      Constant.METHOD_PRINTER_GET_TYPE -> {

        if (!SystemUtil.isInstallServiceApk()) {
          result.success("")
        } else {
          val type = SystemUtil.checkPrinter581(context)
          result.success("$type")

        }
      }


      Constant.METHOD_PRINTER_CHECK_STATUS -> {

        try {
          val checkStatus = PrintUtil.checkStatus()
          result.success("$checkStatus")
        } catch (e: Exception) {
          handleException(result, e)
        }
      }

      Constant.METHOD_PRINTER_INIT -> {
        PrintUtil.initPrinter(context.applicationContext)
//        mUsbThermalPrinter!!.reset()

        result.success("")
      }

      Constant.METHOD_PRINTER_RESET -> {
        PrintUtil.reset()
        result.success("")
      }

      Constant.METHOD_PRINTER_ADD_COLUMNS_STRING -> {
      }

      Constant.METHOD_PRINTER_ADD_STRING -> {
        val printContent: String = (call.arguments as ArrayList<String>)[0]
        PrintUtil.addString(printContent)
        result.success("")
      }

      Constant.METHOD_PRINTER_PRINT_STRING -> {

        try {
          val code = PrintUtil.printString()
          result.success("")
        } catch (e: Exception) {
          handleException(result, e)
        }

      }


      Constant.METHOD_PRINTER_PRINT_BAR_CODE -> {

//                FlutterPrinterProvider.instance.printLogo()
        val barcodeStr: String = (call.arguments as ArrayList<String>)[0]
//        val type: String = (call.arguments as ArrayList<String>)[0]
        val bmpWidth: Int = (call.arguments as ArrayList<Int>)[1]
        val bmpHeight: Int = (call.arguments as ArrayList<Int>)[2]
        val buffer: Boolean = (call.arguments as ArrayList<Boolean>)[3]


        val bitmap: Bitmap = PrintUtil.CreateCode(barcodeStr, BarcodeFormat.CODE_128, bmpWidth, bmpHeight)!!
        if (bitmap != null) {
          PrintUtil.printLogo(bitmap, buffer)
        }

      }


      Constant.METHOD_PRINTER_PRINT_QR_CODE -> {

        val qrcodeStr: String? = call.argument("qrcodeStr")
        val qrcodeSize: Int? = call.argument("qrcodeSize")
        val buffer: Boolean? = call.argument("buffer")

        val bitmap: Bitmap = PrintUtil.CreateCode(qrcodeStr, BarcodeFormat.QR_CODE, qrcodeSize!!, qrcodeSize)!!
        if (bitmap != null) {
          PrintUtil.printLogo(bitmap, buffer!!)
        }

      }

      Constant.METHOD_PRINTER_PRINT_LOGO -> {


        val image: ByteArray? = call.argument("image")
        val buffer: Boolean? = call.argument("buffer")
        var bitmap: Bitmap? = PrintUtil.byteToBitmap(image)
        PrintUtil.printLogo(bitmap!!, buffer!!)
      }

      Constant.METHOD_PRINTER_PAPER_CUT -> {

        PrintUtil.paperCut()
        result.success("")
      }

      Constant.METHOD_PRINTER_SEARCH_MARK -> {

//                FlutterPrinterProvider.instance.searchMark()
      }

      Constant.METHOD_PRINTER_WALK_PAPER -> {

//                FlutterPrinterProvider.instance.walkPaper()
        val line: Int = (call.arguments as ArrayList<Int>)[0]
        PrintUtil.walkPaper(line)
        result.success("")
      }


      Constant.METHOD_PRINTER_MEASURE_TEXT -> {

//                FlutterPrinterProvider.instance.measureText()
      }

      Constant.METHOD_PRINTER_SET_TEXT_SIZE -> {

//                FlutterPrinterProvider.instance.setTextSize()
        val size: Int = (call.arguments as ArrayList<Int>)[0]
        PrintUtil.setTextSize(size)
        result.success("")
      }

      Constant.METHOD_PRINTER_SET_GRAY -> {

//                FlutterPrinterProvider.instance.setGray()
        val gray: Int = (call.arguments as ArrayList<Int>)[0]
        PrintUtil.setGray(gray)
        result.success("")
      }

      Constant.METHOD_PRINTER_SET_ALIGN -> {

//                FlutterPrinterProvider.instance.setAlign()
        val mode: Int = (call.arguments as ArrayList<Int>)[0]
        PrintUtil.setAlign(mode)
        result.success("")
      }

      Constant.METHOD_PRINTER_SET_LEFT_INDENT -> {

//                FlutterPrinterProvider.instance.setLeftIndent()
        val leftDistance: Int = (call.arguments as ArrayList<Int>)[0]
        PrintUtil.setLeftIndent(leftDistance)
        result.success("")
      }

      Constant.METHOD_PRINTER_SET_LINE_SPACE -> {

//                FlutterPrinterProvider.instance.setLineSpace()
        val lineDistance: Int = (call.arguments as ArrayList<Int>)[0]
        PrintUtil.setLineSpace(lineDistance)
        result.success("")
      }

      Constant.METHOD_PRINTER_SET_BOLD -> {

//                FlutterPrinterProvider.instance.setBold()
        val bold: Boolean = (call.arguments as ArrayList<Boolean>)[0]
        PrintUtil.setBold(bold)
        result.success("")
      }

      Constant.METHOD_PRINTER_SET_ITALIC -> {

//                FlutterPrinterProvider.instance.setItalic()
        val italic: Boolean = (call.arguments as ArrayList<Boolean>)[0]
        PrintUtil.setItalic(italic)
        result.success("")
      }

      Constant.METHOD_PRINTER_SET_THRIPLE_HEIGHT -> {

//                FlutterPrinterProvider.instance.setThripleHeight()
        val thripleHeight: Boolean = (call.arguments as ArrayList<Boolean>)[0]
        PrintUtil.setThripleHeight(thripleHeight)
        result.success("")
      }

      Constant.METHOD_PRINTER_ENLARGE_FONT_SIZE -> {

//                FlutterPrinterProvider.instance.enlargeFontSize()
        val openingTwoWidth: Boolean = (call.arguments as ArrayList<Boolean>)[0]
        if (openingTwoWidth) {
          PrintUtil.enlargeFontSize(2, 1)
        }
        result.success("")
      }

      Constant.METHOD_PRINTER_SET_MONOSPACE -> {

//                FlutterPrinterProvider.instance.setMonoSpace()
        val monoSpace: Boolean = (call.arguments as ArrayList<Boolean>)[0]
        PrintUtil.setMonoSpace(monoSpace)
        result.success("")
      }


      Constant.METHOD_DISPLAY_CONTROL_STATUS_BAR_BY_BROADCAST -> {

        if (mSystemLib == null) {
          mSystemLib = SystemApiUtil(context)
        }
        val enable: Boolean = (call.arguments as ArrayList<Boolean>)[0]
        if (enable) {
          mSystemLib?.showStatusBar();
        } else {
          mSystemLib?.hideStatusBar();
        }
      }


      Constant.METHOD_DISPLAY_CONTROL_NAVIGATION_BAR_BY_BROADCAST -> {
        if (mSystemLib == null) {
          mSystemLib = SystemApiUtil(context)
        }
        val enable: Boolean = (call.arguments as ArrayList<Boolean>)[0]
        if (enable) {
          mSystemLib?.showNavigationBar();
        } else {
          mSystemLib?.hideNavigationBar();
        }
      }


      Constant.METHOD_DISPLAY_CONTROL_STATUS_BAR -> {

//                FlutterPrinterProvider.instance.setMonoSpace()
        val enable: Boolean = (call.arguments as ArrayList<Boolean>)[0]
//        PrintUtil.setMonoSpace(monoSpace)

        result.success("${iDisplayControl!!.setStatusbarEnable(if (enable) 1 else 0)}")
      }



      Constant.METHOD_DISPLAY_CONTROL_NAVIGATION_BAR -> {

//                FlutterPrinterProvider.instance.setMonoSpace()
        val enable: Boolean = (call.arguments as ArrayList<Boolean>)[0]

//        PrintUtil.setMonoSpace(monoSpace)

        result.success("${iDisplayControl!!.setNavigationBarEnable(if (enable) 1 else 0)}")
      }

      else -> {
        result.notImplemented()

      }
    }

  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  fun handleException(result: Result, e: Exception) {
    val exception = e.toString()
    if (exception.contains("NoPaperException")) {
      result.success("NoPaperException")
    } else if (exception.contains("OverHeatException")) {
      result.success("OverHeatException")
    } else if (exception.contains("LowPowerException")) {
      result.success("LowPowerException")
    } else {
      result.success(exception)
    }
  }


  fun getProperties(key: String?, defaultValue: String?): String? {
    var value: String? = null
    try {
      val c = Class.forName("android.os.SystemProperties")
      val get = c.getMethod("get", String::class.java, String::class.java)
      value = get.invoke(c, key, defaultValue) as String //
    } catch (e: java.lang.Exception) {
      e.printStackTrace()
    }
    return value
  }

  private fun scanQrCode() {


    val intent = Intent()
    intent.setClassName("com.telpo.tps550.api", "com.telpo.tps550.api.barcode.Capture")

// 使用 PackageManager 来检查 Intent 是否可以处理
    val packageManager = activity.packageManager
    val resolveInfo = packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY)

    if (resolveInfo != null) {
      // Intent 可以处理，执行跳转
//      activityResultLauncher.launch(intent)
      activity.startActivityForResult(intent, REQUEST_CODE_SCAN_QR)
    } else {
      // Intent 不可处理，返回相应的结果
      result?.success("Activity not found")
    }



  }

  // Handle the result when the activity finishes
  fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    if (requestCode == REQUEST_CODE_SCAN_QR) {
      if (resultCode == 0) {
        if (data != null) {
          val qrCode = data.getStringExtra("qrCode")
          result!!.success(qrCode) // Return the result to Flutter
        } else {
          result!!.error("ERROR", "No data returned", null)
        }
      } else {
        result!!.error("ERROR", "Scan Failed", null)
      }
    }
  }

  companion object {
    const val REQUEST_CODE_SCAN_QR = 0x124
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.activity = binding.getActivity()
    this.binding = binding
    binding.addActivityResultListener { requestCode, resultCode, data ->
      if (requestCode == REQUEST_CODE_SCAN_QR) {
        if (resultCode == 0 && data != null) {
          // 处理返回的数据
          val scannedResult = data.getStringExtra("qrCode")
//          mEventSink?.success(scannedResult) // 发送结果到Flutter
//            result!!.success(scannedResult)
          result!!.success(scannedResult)
        } else {55
//          mEventSink?.error("ERROR", "Scan canceled or failed", null)
//          result!!.error("ERROR", "Scan canceled or failed", null)
          result!!.success("Scan canceled or failed")
        }
        true // 表示我们处理了这个结果
      } else {
        false // 让其他监听器处理这个结果
      }
    }

  }

  fun convertToAppCompatActivity(activity: Activity): AppCompatActivity? {
    return activity as? AppCompatActivity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.activity = binding.getActivity()
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }
}

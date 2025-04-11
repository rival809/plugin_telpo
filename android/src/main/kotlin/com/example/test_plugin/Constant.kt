package com.example.test_plugin

/**
 * @Description:    常量
 * @Author:         liyufeng
 * @CreateDate:     2022/6/29 9:31 上午
 */

abstract class Constant {
    companion object {
        const val METHOD_SUPPORT_DOUBLE_SCREEN = "supportDoubleScreen" //是否支持多屏
        const val METHOD_CHECK_OVERLAY_PERMISSION = "checkOverlayPermission" //校验overlay权限
        const val METHOD_REQUEST_OVERLAY_PERMISSION = "requestOverlayPermission" //请求overlay权限
        const val METHOD_DOUBLE_SCREEN_SHOW = "doubleScreenShow" //显示副屏
        const val METHOD_DOUBLE_SCREEN_CANCEL = "doubleScreenCancel" //关闭副屏


        const val METHOD_DEVICE_INFO_GET_PLATFORM_VERSION = "getPlatformVersion"
        const val METHOD_DEVICE_INFO_GET_INSTALL_SERVICE_APK = "isInstallServiceApk"
        const val METHOD_DEVICE_INFO_GET_PROPERTIES = "getProperties"
        const val METHOD_DEVICE_INFO_GET_MAC_ADDRESS = "getMacAddress"
        const val METHOD_DEVICE_INFO_GET_SERIAL_NO = "getSerialNumber"
        const val METHOD_DEVICE_INFO_GET_IMEI1 = "getImei1"
        const val METHOD_DEVICE_INFO_GET_IMEI2 = "getImei2"
        const val METHOD_DEVICE_INFO_GET_INTERNAL_MODEL = "getInternalModel"


        const val METHOD_SCAN_QRCODE = "scanQrCode"


        const val METHOD_PRINTER_GET_VERSION = "getVersion"
        const val METHOD_PRINTER_GET_TYPE = "getType"
        const val METHOD_PRINTER_CHECK_STATUS = "checkStatus"
        const val METHOD_PRINTER_INIT = "initPrinter"
        const val METHOD_PRINTER_RESET = "reset"
        const val METHOD_PRINTER_ADD_COLUMNS_STRING = "addColumnsString"
        const val METHOD_PRINTER_ADD_STRING = "addString"
        const val METHOD_PRINTER_PRINT_STRING = "printString"
        const val METHOD_PRINTER_PRINT_LOGO = "printLogo"
        const val METHOD_PRINTER_PRINT_BAR_CODE = "printBarCode"
        const val METHOD_PRINTER_PRINT_QR_CODE = "printQrCode"
        const val METHOD_PRINTER_PAPER_CUT = "paperCut"
        const val METHOD_PRINTER_SEARCH_MARK = "searchMark"
        const val METHOD_PRINTER_WALK_PAPER = "walkPaper"
        const val METHOD_PRINTER_MEASURE_TEXT = "measureText"
        const val METHOD_PRINTER_SET_TEXT_SIZE = "setTextSize"
        const val METHOD_PRINTER_SET_GRAY = "setGray"
        const val METHOD_PRINTER_SET_ALIGN = "setAlign"
        const val METHOD_PRINTER_SET_LEFT_INDENT = "setLeftIndent"
        const val METHOD_PRINTER_SET_LINE_SPACE = "setLineSpace"
        const val METHOD_PRINTER_SET_BOLD = "setBold"
        const val METHOD_PRINTER_SET_ITALIC = "setItalic"
        const val METHOD_PRINTER_SET_THRIPLE_HEIGHT = "setThripleHeight"
        const val METHOD_PRINTER_ENLARGE_FONT_SIZE = "enlargeFontSize"
        const val METHOD_PRINTER_SET_MONOSPACE = "setMonoSpace"
        const val METHOD_DISPLAY_CONTROL_STATUS_BAR_BY_BROADCAST = "setStatusBarEnableByBroadcast"
        const val METHOD_DISPLAY_CONTROL_NAVIGATION_BAR_BY_BROADCAST = "setNavigationBarEnableByBroadcast"
        const val METHOD_DISPLAY_CONTROL_STATUS_BAR = "setStatusBarEnable"
        const val METHOD_DISPLAY_CONTROL_NAVIGATION_BAR = "setNavigationBarEnable"
    }
}
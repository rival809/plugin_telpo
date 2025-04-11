package com.example.test_plugin

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.widget.Toast
import com.common.apiutil.printer.ThermalPrinter
import com.common.apiutil.printer.UsbThermalPrinter
import com.common.apiutil.util.SystemUtil
import com.google.zxing.BarcodeFormat
import com.google.zxing.EncodeHintType
import com.google.zxing.MultiFormatWriter
import com.google.zxing.WriterException
import com.google.zxing.common.BitMatrix
import java.io.ByteArrayInputStream
import java.io.IOException
import java.io.InputStream
import java.lang.ref.SoftReference
import java.util.Hashtable


class PrintUtil {
    companion object {

        private var mUsbThermalPrinter: UsbThermalPrinter? = null
        private var type: Int? = null
        private var installServiceApk: Boolean = false
        @SuppressLint("StaticFieldLeak")
        private var mContext: Context? = null
        private var has80mmUsbPrinter = false


        fun initPrinter(context: Context) {
            if (type == null) {
                installServiceApk = SystemUtil.isInstallServiceApk()
                if (!installServiceApk) {
                    if (mUsbThermalPrinter == null) {
                        mUsbThermalPrinter = UsbThermalPrinter(context)
                        mUsbThermalPrinter!!.reset()
                    }
                } else {
                    type = SystemUtil.checkPrinter581(context)
                    if (type == SystemUtil.PRINTER_PRT_COMMON) {
                        if (mUsbThermalPrinter == null) {
                            mUsbThermalPrinter = UsbThermalPrinter(context)
                            mUsbThermalPrinter!!.reset()
                        }
                    } else {
                        if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581) {
                            if (type == SystemUtil.PRINTER_80MM_USB_COMMON) {
                                SystemUtil.setProperty("persist.printer.interface", "usb")
                                has80mmUsbPrinter = ThermalPrinter.init80mmUsbPrinter(context);

                            } else {
                                SystemUtil.setProperty("persist.printer.interface", "serial")
                                ThermalPrinter.init80mmSerialPrinter();
                                has80mmUsbPrinter = false;
                            }
                        }
                        ThermalPrinter.setPaperWidth(ThermalPrinter.PAPER_80mm);
                        ThermalPrinter.start(context);

                    }
                }
            }
        }
        /*fun getUsbThermalPrinter(context: Context): UsbThermalPrinter {
            if (type == null) {
                if (!SystemUtil.isInstallServiceApk()) {
                    installServiceApk = SystemUtil.isInstallServiceApk()
                } else {
                    type = SystemUtil.checkPrinter581(context)

                    if (type == SystemUtil.PRINTER_PRT_COMMON) {
                        startActivity(Intent(this@MainActivity, UsbPrinterActivity::class.java))
                    } else {
                        if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581) {
                            if (type == SystemUtil.PRINTER_80MM_USB_COMMON) {
                                SystemUtil.setProperty("persist.printer.interface", "usb")
                            } else {
                                SystemUtil.setProperty("persist.printer.interface", "serial")
                            }
                        }
                        startActivity(Intent(this@MainActivity, PrinterActivitySY581::class.java))
                    }
                }
            }
            if (mUsbThermalPrinter == null) {
                mUsbThermalPrinter = UsbThermalPrinter(context)
            }
            return mUsbThermalPrinter!!
        }*/

        fun getVersion(): String {
            if (!installServiceApk || type == SystemUtil.PRINTER_PRT_COMMON) {
                return mUsbThermalPrinter!!.version
            } else if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581){
                return ThermalPrinter.getVersion()
            } else {
                Toast.makeText(mContext, "(getVersion) failed caused can not find printer type", Toast.LENGTH_LONG).show()
                return "getVersion null"
            }
        }

        fun addString(content: String?) {
            if (!installServiceApk || type == SystemUtil.PRINTER_PRT_COMMON) {
                mUsbThermalPrinter!!.addString(content)
            } else if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581){
                ThermalPrinter.addString(content)
            } else {
                Toast.makeText(mContext, "(addString) failed caused can not find printer type", Toast.LENGTH_LONG).show()
            }
        }


        fun printString() {
            if (!installServiceApk || type == SystemUtil.PRINTER_PRT_COMMON) {
                mUsbThermalPrinter!!.printString()
            } else if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581){
                ThermalPrinter.printString()
            } else {
                Toast.makeText(mContext, "(printString) failed caused can not find printer type", Toast.LENGTH_LONG).show()
            }
        }


        fun reset() {
            if (!installServiceApk || type == SystemUtil.PRINTER_PRT_COMMON) {
                mUsbThermalPrinter!!.reset()
            } else if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581){
                ThermalPrinter.reset()
            } else {
                Toast.makeText(mContext, "(reset) failed caused can not find printer type", Toast.LENGTH_LONG).show()
            }
        }


        fun checkStatus(): Int {
            if (!installServiceApk || type == SystemUtil.PRINTER_PRT_COMMON) {
                return mUsbThermalPrinter!!.checkStatus();
            } else if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581) {
                return ThermalPrinter.checkStatus();
            } else {
                Toast.makeText(
                    mContext,
                    "(checkStatus) failed caused can not find printer type",
                    Toast.LENGTH_LONG
                ).show()
                return -1;
            }
        }


        fun printLogo(bitmap: Bitmap, buffer: Boolean) {
            if (!installServiceApk || type == SystemUtil.PRINTER_PRT_COMMON) {
                mUsbThermalPrinter!!.printLogo(bitmap, buffer)
            } else if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581){
                ThermalPrinter.printLogo(bitmap)
            } else {
                Toast.makeText(mContext, "(printLogo) failed caused can not find printer type", Toast.LENGTH_LONG).show()
            }
        }


        fun paperCut() {
            if (!installServiceApk || type == SystemUtil.PRINTER_PRT_COMMON) {
                mUsbThermalPrinter!!.paperCut()
            } else if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581){
                ThermalPrinter.paperCut()
            } else {
                Toast.makeText(mContext, "(paperCut) failed caused can not find printer type", Toast.LENGTH_LONG).show()
            }
        }

        fun walkPaper(line: Int) {
            if (!installServiceApk || type == SystemUtil.PRINTER_PRT_COMMON) {
                mUsbThermalPrinter!!.walkPaper(line)
            } else if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581){
                ThermalPrinter.walkPaper(line)
            } else {
                Toast.makeText(mContext, "(walkPaper) failed caused can not find printer type", Toast.LENGTH_LONG).show()
            }
        }


        fun setTextSize(size: Int) {
            if (!installServiceApk || type == SystemUtil.PRINTER_PRT_COMMON) {
                mUsbThermalPrinter!!.setTextSize(size)
            } else if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581){
                ThermalPrinter.setFontSize(size)
            } else {
                Toast.makeText(mContext, "(setTextSize) failed caused can not find printer type", Toast.LENGTH_LONG).show()
            }
        }


        fun setGray(setGray: Int) {
            if (!installServiceApk || type == SystemUtil.PRINTER_PRT_COMMON) {
                mUsbThermalPrinter!!.setGray(setGray)
            } else if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581){
                ThermalPrinter.setGray(setGray)
            } else {
                Toast.makeText(mContext, "(setGray) failed caused can not find printer type", Toast.LENGTH_LONG).show()
            }
        }


        fun setAlign(mode: Int) {
            if (!installServiceApk || type == SystemUtil.PRINTER_PRT_COMMON) {
                mUsbThermalPrinter!!.setAlgin(mode)
            } else if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581){
                ThermalPrinter.setAlgin(mode)
            } else {
                Toast.makeText(mContext, "(setAlign) failed caused can not find printer type", Toast.LENGTH_LONG).show()
            }
        }


        fun setLeftIndent(leftDistance: Int) {
            if (!installServiceApk || type == SystemUtil.PRINTER_PRT_COMMON) {
                mUsbThermalPrinter!!.setLeftIndent(leftDistance)
            } else if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581){
                ThermalPrinter.setLeftIndent(leftDistance)
            } else {
                Toast.makeText(mContext, "(setLeftIndent) failed caused can not find printer type", Toast.LENGTH_LONG).show()
            }
        }


        fun setLineSpace(lineDistance: Int) {
            if (!installServiceApk || type == SystemUtil.PRINTER_PRT_COMMON) {
                mUsbThermalPrinter!!.setLineSpace(lineDistance)
            } else if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581){
                ThermalPrinter.setLineSpace(lineDistance)
            } else {
                Toast.makeText(mContext, "(setLineSpace) failed caused can not find printer type", Toast.LENGTH_LONG).show()
            }
        }


        fun setBold(bold: Boolean) {
            if (!installServiceApk || type == SystemUtil.PRINTER_PRT_COMMON) {
                mUsbThermalPrinter!!.setBold(bold)
            } else if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581){
                ThermalPrinter.setBold(bold)
            } else {
                Toast.makeText(mContext, "(setBold) failed caused can not find printer type", Toast.LENGTH_LONG).show()
            }
        }


        fun setItalic(italic: Boolean) {
            if (!installServiceApk || type == SystemUtil.PRINTER_PRT_COMMON) {
                mUsbThermalPrinter!!.setItalic(italic)
            } else if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581){
//                ThermalPrinter.setLineSpace(lineDistance)
            } else {
                Toast.makeText(mContext, "(setItalic) failed caused can not find printer type", Toast.LENGTH_LONG).show()
            }
        }


        fun setMonoSpace(monoSpace: Boolean) {
            if (!installServiceApk || type == SystemUtil.PRINTER_PRT_COMMON) {
                mUsbThermalPrinter!!.setMonoSpace(monoSpace)
            } else if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581){
//                ThermalPrinter.setMonoSpace(monoSpace)
            } else {
                Toast.makeText(mContext, "(setMonoSpace) failed caused can not find printer type", Toast.LENGTH_LONG).show()
            }
        }


        fun setThripleHeight(thripleHeight: Boolean) {
            if (!installServiceApk || type == SystemUtil.PRINTER_PRT_COMMON) {
                mUsbThermalPrinter!!.setThripleHeight(thripleHeight)
            } else if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581){
//                ThermalPrinter.setThripleHeight(monoSpace)
            } else {
                Toast.makeText(mContext, "(setThripleHeight) failed caused can not find printer type", Toast.LENGTH_LONG).show()
            }
        }



        fun enlargeFontSize(widthMultiple: Int, heightMultiple: Int) {
            if (!installServiceApk || type == SystemUtil.PRINTER_PRT_COMMON) {
                mUsbThermalPrinter!!.enlargeFontSize(widthMultiple, heightMultiple)
            } else if (type == SystemUtil.PRINTER_80MM_USB_COMMON || type == SystemUtil.PRINTER_SY581){
//                ThermalPrinter.enlargeFontSize(monoSpace)
            } else {
                Toast.makeText(mContext, "(enlargeFontSize) failed caused can not find printer type", Toast.LENGTH_LONG).show()
            }
        }

        @Throws(WriterException::class)
        fun CreateCode(str: String?, type: BarcodeFormat?, bmpWidth: Int, bmpHeight: Int): Bitmap? {
            val mHashtable: Hashtable<EncodeHintType, String> = Hashtable<EncodeHintType, String>()
            mHashtable[EncodeHintType.CHARACTER_SET] = "UTF-8"
            val matrix: BitMatrix =
                MultiFormatWriter().encode(str, type, bmpWidth, bmpHeight, mHashtable)
            val width: Int = matrix.getWidth()
            val height: Int = matrix.getHeight()
            val pixels = IntArray(width * height)
            for (y in 0 until height) {
                for (x in 0 until width) {
                    if (matrix.get(x, y)) {
                        pixels[y * width + x] = -0x1000000
                    } else {
                        pixels[y * width + x] = -0x1
                    }
                }
            }
            val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
            bitmap.setPixels(pixels, 0, width, 0, 0, width, height)
            return bitmap
        }


        fun byteToBitmap(imgByte: ByteArray?): Bitmap? {
            var imgByte = imgByte
            var input: InputStream? = null
            var bitmap: Bitmap? = null
            val options = BitmapFactory.Options()
            options.inSampleSize = 1
            input = ByteArrayInputStream(imgByte)
            val softRef: SoftReference<*> = SoftReference<Any?>(
                BitmapFactory.decodeStream(
                    input, null, options
                )
            ) //�����÷�ֹOOM
            bitmap = softRef.get() as Bitmap?
            if (imgByte != null) {
                imgByte = null
            }
            try {
                if (input != null) {
                    input.close()
                }
            } catch (e: IOException) {
                // �쳣����
                e.printStackTrace()
            }
            return bitmap
        }
    }
}
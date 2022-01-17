package com.example.id_card_reader

import androidx.annotation.NonNull
import android.hardware.usb.*
import java.util.*

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter


import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import com.acs.smartcard.Features;
import com.acs.smartcard.PinModify;
import com.acs.smartcard.PinProperties;
import com.acs.smartcard.PinVerify;
import com.acs.smartcard.ReadKeyOption;
import com.acs.smartcard.Reader;
import com.acs.smartcard.Reader.OnStateChangeListener;
import com.acs.smartcard.TlvProperties;

// import java.nio.ByteBuffer
// import java.nio.CharBuffer
// import java.nio.charset.Charset
// import java.lang.String




private const val ACTION_USB_PERMISSION = "com.example.id_card_reader.USB_PERMISSION"

private fun pendingPermissionIntent(context: Context) = PendingIntent.getBroadcast(context, 0, Intent(ACTION_USB_PERMISSION), 0)



/** IdCardReaderPlugin */
class IdCardReaderPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  // private var eChannel: EventChannel? = null
  private var randomNumberEventChannel: EventChannel? = null
  private var eventSink: EventChannel.EventSink? = null

  private var applicationContext: Context? = null
  private var usbManager: UsbManager? = null

  // acs
   private var mReader: Reader? = null


  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "id_card_reader")
    channel.setMethodCallHandler(this)
    applicationContext = flutterPluginBinding.applicationContext
    usbManager = applicationContext?.getSystemService(Context.USB_SERVICE) as UsbManager
    mReader = Reader(usbManager);

    val randomNumberEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "random_number_channel")
    randomNumberEventChannel.setStreamHandler(RandomNumberStreamHandler())

    val deviceEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "device_stream_channel")
    deviceEventChannel.setStreamHandler(DeviceStreamHandler())
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    usbManager = null
    mReader = null
    applicationContext = null
  }

  private var usbDevice: UsbDevice? = null
  private var usbDeviceConnection: UsbDeviceConnection? = null

  private val receiver = object : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
      context.unregisterReceiver(this)
      val device = intent.getParcelableExtra<UsbDevice>(UsbManager.EXTRA_DEVICE)
      val granted = intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)
      if (!granted) {
        println("Permission denied: ${device?.deviceName}")
      }
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
    "getPlatformVersion" -> {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } 
    "getDeviceList" -> {
      val manager = usbManager ?: return result.error("IllegalState", "usbManager null", null)
      val usbDeviceList = manager.deviceList.entries.map {
        mapOf(
                "identifier" to it.key,
                "vendorId" to it.value.vendorId,
                "productId" to it.value.productId,
                "configurationCount" to it.value.configurationCount
        )
      }

      result.success(usbDeviceList)
    }
    "warm1" -> {
      val reader = mReader?: return result.error("IllegalState", "mReader null", null)
      try {
        val atr: ByteArray = reader.power(0, Reader.CARD_WARM_RESET)
        result.success("warm reset : " + showByteString(atr))
      } catch (e: Exception) {
        result.success(e)
      }
    }
    "protocal1" -> {
      val reader = mReader?: return result.error("IllegalState", "mReader null", null)
      try {
        reader.setProtocol(0, Reader.PROTOCOL_T0 or Reader.PROTOCOL_T1)
        result.success("already set protocal")
      } catch (e: Exception) {
        result.success(e)
      }
    }
        "readCID" -> {
          val reader = mReader?: return result.error("IllegalState", "mReader null", null)
      fun byteArrayOfInts(vararg ints: Int) = ByteArray(ints.size) { pos -> ints[pos].toByte() }
      fun byteArrayOfx(vararg ints: Int) = ByteArray(ints.size) { pos -> pos as Byte }
      val command = byteArrayOfInts(0x80, 0xb0, 0x00, 0x04, 0x02, 0x00, 0xd1)
//            val cid = byteArrayOf(0x00 as Byte, 0xA4 as Byte, 0x04 as Byte, 0x00 as Byte, 0x08 as Byte, 0xA0 as Byte, 0x00 as Byte, 0x00 as Byte, 0x00 as Byte, 0x54 as Byte, 0x48 as Byte, 0x00 as Byte, 0x01 as Byte)
      val info = byteArrayOfInts(0x00 , 0xA4 , 0x04 , 0x00 , 0x08 , 0xA0 , 0x00  , 0x00 , 0x00 , 0x54 , 0x48 , 0x00 , 0x01)
      val cid = byteArrayOf(0x80.toByte(), 0xB0.toByte(), 0x00.toByte(), 0x04.toByte(), 0x02.toByte(), 0x00.toByte(),
              0x0D.toByte())
      val cid_getdata = byteArrayOf(0x00.toByte(), 0xC0.toByte(), 0x00.toByte(), 0x00.toByte(), 0x0D.toByte())
      val response = ByteArray(500)
      val responseLength: Int
      try {
//              reader.transmit(0, cid, cid.size, response, response.size)
//              responseLength = reader.transmit(0, info, info.size, response, response.size)
        reader.transmit(0, cid, cid.size, response, response.size)
        responseLength = reader.transmit(0, cid_getdata, cid_getdata.size, response, response.size)
//              byteArrayToHexString(response, 0, responsLength)
        // result.success("result"+byteArrayToHexString(response, 0, responseLength))
        result.success(response)
      } catch (e: Exception) {
        result.success(e)
      }

    }

    "test1" -> {
      val context = applicationContext ?: return result.error("IllegalState", "applicationContext null", null)
      val manager = usbManager ?: return result.error("IllegalState", "usbManager null", null)
      val reader = mReader?: return result.error("IllegalState", "mReader null", null)
      var dv = manager.deviceList;
      if (dv.isEmpty()) {
        result.success("No Devices Currently Connected")
      } else {
        val usbDeviceList = dv.entries.map {
          mapOf("identifier" to it.key, "vendorId" to it.value.vendorId, "productId" to it.value.productId, "configurationCount" to it.value.configurationCount)
        }

        var identifier = usbDeviceList[0]["identifier"]
        val device = manager.deviceList[identifier]

        if (!manager.hasPermission(device)) {
          context.registerReceiver(receiver, IntentFilter(ACTION_USB_PERMISSION))
          manager.requestPermission(device, pendingPermissionIntent(context))
        } else {
          val xa = reader.open(device)
          if (reader.isSupported(device)) {
            result.success(reader.getDevice())
//          val devicex: UsbDevice = intent
//                  .getParcelableExtra(UsbManager.EXTRA_DEVICE) as UsbDevice
            reader.open(device)
            val xx = reader.getReaderName()
            val numSlots: Int = reader.getNumSlots()

//            result.success(numSlots)

            // try {
            //   val atr: ByteArray = reader.power(0, Reader.CARD_WARM_RESET)
            // } catch (e: Exception) {
            //   result.success(e)
            // }

            // try {
            //   reader.setProtocol(0, Reader.PROTOCOL_T0 or Reader.PROTOCOL_T1)
            // } catch (e: Exception) {
            //   result.success(e)
            // }


            // fun byteArrayOfInts(vararg ints: Int) = ByteArray(ints.size) { pos -> ints[pos].toByte() }
            // fun byteArrayOfx(vararg ints: Int) = ByteArray(ints.size) { pos -> pos as Byte }
//            val command = byteArrayOfInts(0x00, 0x84, 0x00, 0x00, 0x08)
//             val command = byteArrayOfInts(0x80, 0xb0, 0x00, 0x04, 0x02, 0x00, 0xd1)
// //            val cid = byteArrayOf(0x00 as Byte, 0xA4 as Byte, 0x04 as Byte, 0x00 as Byte, 0x08 as Byte, 0xA0 as Byte, 0x00 as Byte, 0x00 as Byte, 0x00 as Byte, 0x54 as Byte, 0x48 as Byte, 0x00 as Byte, 0x01 as Byte)
//             val info = byteArrayOfInts(0x00 , 0xA4 , 0x04 , 0x00 , 0x08 , 0xA0 , 0x00  , 0x00 , 0x00 , 0x54 , 0x48 , 0x00 , 0x01)
//             val cid = byteArrayOf(0x80.toByte(), 0xB0.toByte(), 0x00.toByte(), 0x04.toByte(), 0x02.toByte(), 0x00.toByte(),
//                     0x0D.toByte())
//             val cid_getdata = byteArrayOf(0x00.toByte(), 0xC0.toByte(), 0x00.toByte(), 0x00.toByte(), 0x0D.toByte())
//             val response = ByteArray(500)
//             val responseLength: Int
//             val resx: Int

//             try {
// //              reader.transmit(0, cid, cid.size, response, response.size)
// //              responseLength = reader.transmit(0, info, info.size, response, response.size)
//               reader.transmit(0, cid, cid.size, response, response.size)
//               responseLength = reader.transmit(0, cid_getdata, cid_getdata.size, response, response.size)
// //              byteArrayToHexString(response, 0, responsLength)
//               // result.success("result"+byteArrayToHexString(response, 0, responseLength))
//               result.success(response)
//             } catch (e: Exception) {
//               result.success(e)
//             }
          }
        }
//
//        result.success(device)
      }
//      val firstKey: Optional<String> = dv.keySet().stream().findFirst()
//      var dx = ArrayList(dv.values)
//      for (dev in manager.deviceList)
//      {
//        // returns hashmap<String, UsbDevice>
////        Log.i("TAG", dev.key + " " + dev.value)
//        // now ask for permission
//        manager.requestPermission(manager.deviceList.value, pendingPermissionIntent(context))
//      }
//      result.success(dv)
    }
    "requestPermission" -> {
      val context = applicationContext ?: return result.error("IllegalState", "applicationContext null", null)
      val manager = usbManager ?: return result.error("IllegalState", "usbManager null", null)
      val identifier = call.argument<String>("identifier")
      val device = manager.deviceList[identifier]
      if (!manager.hasPermission(device)) {
        context.registerReceiver(receiver, IntentFilter(ACTION_USB_PERMISSION))
        manager.requestPermission(device, pendingPermissionIntent(context))
      }
      result.success(null)
    }

    // "getData" -> {
    //   // val identifier = call.argument<String>("identifier")
    //   val context = applicationContext ?: return result.error("IllegalState", "applicationContext null", null)
    //   val manager = usbManager ?: return result.error("IllegalState", "usbManager null", null)
    //   val reader = mReader ?: return result.error("IllegalState", "mReader null", null)
    //   val device = manager.deviceList.first
    //   if (!manager.hasPermission(device)) {
    //     context.registerReceiver(receiver, IntentFilter(ACTION_USB_PERMISSION))
    //     manager.requestPermission(device, pendingPermissionIntent(context))
    //   }
    //   val xa = reader.open(manager[0])
    //   result.success(null)
    // }
    
      
    else -> result.notImplemented()
    }
  }

  //  private fun getData() {
  //   val batteryLevel: Int
  //   if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
  //     val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
  //     batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
  //   } else {
  //     val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
  //     batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
  //   }

  //   return batteryLevel
  // }

  fun byteArrayToHexString(input: ByteArray, index: Int, length: Int): String? {
    var length = length
    if (length + index > input.size) {
      length = input.size - index
    }
    val selectBytes: ByteArray = ByteArray(length)
    System.arraycopy(input, index, selectBytes, 0, length - 2)
    return showByteString(selectBytes)
  }

  fun showByteString(input: ByteArray?): String? {
    val output: StringBuilder = StringBuilder()
    for (b in input!!) {
      output.append(String.format("%02x", b))
    }
    var result: String? = null
    // result = String(input)
//     try {

      result = "AA" + String(input, charset("TIS620"))
// //      val tis620charset = Charset.forName("TIS620").encode("๕ค 9 ๖ต 0 ๗จ - ๘ข = ๙ช q ๐ๆ w ","ไ e ฎำ r ฑพ t ธะ y ํั u ๊ี i ณร o ฯน p ญย [ ฐบ ] ,ล ⏎ ⇥ a ฤฟ s ฆห d ฏก f โด g ฌเ h ็้ j ๋่ k ษา l ศส ; ซ").array()
//       // result = String(input, Charset.forName("TIS620").encode("๕ค 9 ๖ต 0 ๗จ - ๘ข = ๙ช q ๐ๆ w ","ไ e ฎำ r ฑพ t ธะ y ํั u ๊ี i ณร o ฯน p ญย [ ฐบ ] ,ล ⏎ ⇥ a ฤฟ s ฆห d ฏก f โด g ฌเ h ็้ j ๋่ k ษา l ศส ; ซ").array())
// //      result = String(input, tis620charset)
//       result = String(input)
//       // return result
//     } catch (e: Exception) {
//       e.printStackTrace()
//     }
    return result
  }


}

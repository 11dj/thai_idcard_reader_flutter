package com.example.thai_idcard_reader_flutter

import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.os.Handler
import android.os.Looper
import com.acs.smartcard.Reader
import com.acs.smartcard.Reader.OnStateChangeListener
import io.flutter.plugin.common.EventChannel
import java.util.*

class ReaderStream : EventChannel.StreamHandler {
    var sink: EventChannel.EventSink? = null
    var handler: Handler? = null

    private var usbManager: UsbManager? = null

    // acs
    private var mReader: Reader? = null
    private var device: UsbDevice? = null

    private val stateStrings =
            arrayOf(
                    "Unknown",
                    "Absent",
                    "Present",
                    "Swallowed",
                    "Powered",
                    "Negotiable",
                    "Specific"
            )

    // private val runnable = Runnable { sendNewRandomNumber() }

    fun setReader(reader: Reader) {
        mReader = reader

        if (mReader == null) {
            Handler(Looper.getMainLooper()).post { sink?.success("READER is NuLL") }
        } else {
            mReader?.setOnStateChangeListener(
                    OnStateChangeListener { _, prevState, currState ->
                        var prevState = prevState
                        var currState = currState
                        if (prevState < Reader.CARD_UNKNOWN || prevState > Reader.CARD_SPECIFIC) {
                            prevState = Reader.CARD_UNKNOWN
                        }
                        if (currState < Reader.CARD_UNKNOWN || currState > Reader.CARD_SPECIFIC) {
                            currState = Reader.CARD_UNKNOWN
                        }
                        Handler(Looper.getMainLooper()).post { sink?.success(serializeReader(currState, prevState)) }
                    }
            )
        }
    }

    private fun serializeReader(currState: Int, prevState: Int): HashMap<String, Any?> {
        val data: HashMap<String, Any?> = HashMap()
        if (currState == 0 && prevState == 0) {
            data["status"] = "Cancel"
        } else {
            data["status"] = stateStrings[currState]
        }
        data["currentState"] = currState
        data["previousState"] = prevState
        return data
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
        // handler = Handler()
        // handler?.post(runnable)
    }

    override fun onCancel(arguments: Any?) {
        Handler(Looper.getMainLooper()).post { sink?.success(serializeReader(0, 0)) }
        sink = null
        mReader = null
    }
}

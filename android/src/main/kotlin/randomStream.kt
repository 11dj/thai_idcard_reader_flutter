package com.example.id_card_reader

import android.os.Handler
import io.flutter.plugin.common.EventChannel
import java.util.*

class RandomNumberStreamHandler: EventChannel.StreamHandler {
    var sink: EventChannel.EventSink? = null
    var handler: Handler? = null

    private val runnable = Runnable {
        sendNewRandomNumber()
    }

    fun sendNewRandomNumber() {
        val randomNumber = Random().nextInt(9)
        sink?.success(randomNumber)
        handler?.postDelayed(runnable, 1000)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
        handler = Handler()
        handler?.post(runnable)
    }

    override fun onCancel(arguments: Any?) {
        sink = null
        handler?.removeCallbacks(runnable)
    }
}
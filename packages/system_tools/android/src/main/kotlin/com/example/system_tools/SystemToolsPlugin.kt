package com.example.system_tools

import android.content.Context
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.text.format.DateFormat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class SystemToolsPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var context: Context
    private lateinit var channel: MethodChannel
    private var hasEarpiece: Boolean? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "system_tools")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.getApplicationContext();
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "is24hoursTimeFormat" -> result.success(DateFormat.is24HourFormat(context))
            "hasEarpiece" -> result.success(hasEarpiece())
            else -> result.notImplemented()
        }
    }

    fun hasEarpiece(): Boolean {
        if (hasEarpiece != null) return hasEarpiece as Boolean;

        val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
            val devices = audioManager.availableCommunicationDevices
            for (device in devices) {
                if (device.type == AudioDeviceInfo.TYPE_BUILTIN_EARPIECE) {
                    hasEarpiece = true
                    break
                }
            }
            if (hasEarpiece == null) {
                val currDevice = audioManager.communicationDevice
                hasEarpiece = currDevice != null &&
                        currDevice.type == AudioDeviceInfo.TYPE_BUILTIN_EARPIECE
            }
        } else {
            hasEarpiece = true
        }
        return hasEarpiece as Boolean
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}

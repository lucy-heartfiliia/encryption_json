package com.mugiwara.no.kaizoku.nativeSecurity

import android.content.Intent
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class NativeSecurityPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
  private lateinit var channel: MethodChannel
  private var context: android.content.Context? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "native_security_demo")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    when (call.method) {
      "playDemo" -> {
        val videoId = call.argument<String>("videoId")
        if (videoId != null) {
          playDemo(videoId)
          result.success(null)
        } else {
          result.error("INVALID_ARGUMENT", "videoId is null", null)
        }
      }
      else -> result.notImplemented()
    }
  }

  private fun playDemo(videoId: String) {
    val intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.youtube.com/watch?v=$videoId"))
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    try {
      context?.startActivity(intent)
    } catch (e: Exception) {
      Log.e("NativeSecurityDemo", "Failed to launch YouTube: ${e.localizedMessage}")
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    context = null
  }
}

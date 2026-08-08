package com.yourcompany.securechat_x  // غيّر هذا إلى اسم الحزمة الخاص بك

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        // يمكنك إضافة أي تهيئة إضافية للـ plugins هنا إذا لزم الأمر
    }
}
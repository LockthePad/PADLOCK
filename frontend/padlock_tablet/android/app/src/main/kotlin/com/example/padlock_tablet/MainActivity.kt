package com.example.padlock_tablet

import android.app.AppOpsManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Process
import android.util.Log
import android.widget.Toast
import android.content.ComponentName
import android.app.AlertDialog
import android.graphics.drawable.BitmapDrawable
import android.graphics.Bitmap
import android.util.Base64
import java.io.ByteArrayOutputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app_lock_channel"
    private val ICON_CHANNEL = "com.example.padlock_tablet/app_icons" // 아이콘 채널 추가
    private val TAG = "MainActivity_DEBUG"
    private val PREFS_NAME = "AppLockPrefs"
    private val KEY_IS_LOCKED = "isLocked"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.i(TAG, "Configuring Flutter Engine")

        // 기존 채널
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "checkAccessibilityPermission" -> {
                        val hasPermission = checkAccessibilityPermission()
                        result.success(hasPermission)
                    }
                    "requestAccessibilityPermission" -> {
                        requestAccessibilityPermission()
                        result.success(null)
                    }
                    "toggleLock" -> {
                        val newLockState = !getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                            .getBoolean(KEY_IS_LOCKED, false)
                        
                        getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                            .edit()
                            .putBoolean(KEY_IS_LOCKED, newLockState)
                            .apply()

                        if (newLockState) {
                            if (!checkAccessibilityPermission()) {
                                requestAccessibilityPermission()
                            }
                            Toast.makeText(this, "앱 잠금 활성화", Toast.LENGTH_SHORT).show()
                        } else {
                            Toast.makeText(this, "앱 잠금 비활성화", Toast.LENGTH_SHORT).show()
                        }
                        result.success(newLockState)
                    }
                    "getLockState" -> {
                        val isLocked = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                            .getBoolean(KEY_IS_LOCKED, false)
                        result.success(isLocked)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error in method call: ${e.message}", e)
                result.error("ERROR", e.message, null)
            }
        }

        // 새로운 아이콘 채널 추가
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ICON_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getAppIcon") {
                val packageName = call.argument<String>("packageName")
                if (packageName != null) {
                    val icon = getAppIcon(packageName)
                    result.success(icon)
                } else {
                    result.error("INVALID_PACKAGE", "Invalid package name", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    // 앱 아이콘을 가져와서 Base64 인코딩하는 메서드
    private fun getAppIcon(packageName: String): String? {
        return try {
            val drawable = packageManager.getApplicationIcon(packageName) as BitmapDrawable
            val bitmap = drawable.bitmap
            val stream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
            val byteArray = stream.toByteArray()
            Base64.encodeToString(byteArray, Base64.DEFAULT)
        } catch (e: Exception) {
            Log.e(TAG, "Error fetching icon for package $packageName: ${e.message}")
            null
        }
    }

    private fun checkAccessibilityPermission(): Boolean {
        try {
            val accessibilityEnabled = Settings.Secure.getInt(
                contentResolver,
                Settings.Secure.ACCESSIBILITY_ENABLED, 0
            )

            if (accessibilityEnabled == 0) {
                return false
            }

            val serviceName = "$packageName/${AppLockAccessibilityService::class.java.canonicalName}"
            val enabledServices = Settings.Secure.getString(
                contentResolver,
                Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
            ) ?: ""

            if (enabledServices.isEmpty()) {
                return false
            }

            val colonSplitter = enabledServices.split(":")
            for (name in colonSplitter) {
                val componentName = ComponentName.unflattenFromString(name)
                if (componentName != null && componentName.packageName == packageName) {
                    return true
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error checking accessibility permission: ${e.message}")
        }
        return false
    }

    private fun requestAccessibilityPermission() {
        try {
            val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            val message = "앱 잠금 기능을 사용하기 위해서는 접근성 권한이 필요합니다.\n" +
                    "1. 설치된 서비스에서 '앱 잠금 서비스'를 찾아주세요.\n" +
                    "2. 서비스를 켜주세요.\n" +
                    "3. 확인 버튼을 눌러주세요."

            AlertDialog.Builder(this)
                .setTitle("접근성 권한 필요")
                .setMessage(message)
                .setPositiveButton("설정으로 이동") { _, _ ->
                    startActivity(intent)
                }
                .setNegativeButton("취소", null)
                .show()
        } catch (e: Exception) {
            Log.e(TAG, "Error requesting accessibility permission: ${e.message}")
            Toast.makeText(this, "접근성 설정을 열 수 없습니다.", Toast.LENGTH_LONG).show()
        }
    }
}

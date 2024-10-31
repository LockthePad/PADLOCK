package com.example.padlock_tablet

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.Intent
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import android.widget.Toast
import android.app.ActivityManager
import android.content.Context
import android.view.WindowManager
import android.graphics.PixelFormat
import android.view.Gravity
import android.view.ViewGroup
import android.widget.FrameLayout
import android.graphics.Color

class AppLockAccessibilityService : AccessibilityService() {
    private val TAG = "AppLock_Accessibility"
    private var lastBlockedPackage = ""
    private var overlayView: FrameLayout? = null
    private lateinit var windowManager: WindowManager
    private val PREFS_NAME = "AppLockPrefs"
    private val KEY_IS_LOCKED = "isLocked"

    // 허용할 앱 패키지명 리스트
    // private val ALLOWED_PACKAGES = setOf(
    //     "com.example.padlock_tablet",    // 우리 앱
    //     "com.android.systemui",          // 시스템 UI
    //     "com.google.android.apps.nexuslauncher",  // Pixel 런처
    //     "com.android.launcher3",         // 기본 런처
    //     "com.android.settings",          // 설정
    //     "com.android.permissioncontroller", // 권한 컨트롤러
    //     "android",                       // 안드로이드 시스템
    //     "com.google.android.permissioncontroller", // Google 권한 컨트롤러
    //     "com.android.chrome",
    //     "com.sec.android.app.launcher",
    // )
    
    private val ALLOWED_PACKAGES = setOf(
   "com.example.padlock_tablet",    // 우리 앱
   "com.android.systemui",          // 시스템 UI
   "com.google.android.apps.nexuslauncher",  // Pixel 런처
   "com.android.launcher3",         // 기본 런처
   "com.sec.android.app.launcher",  // 삼성 OneUI 런처
   "com.samsung.android.app.settings", // 삼성 설정
   "com.android.settings",          // 설정
   "com.android.permissioncontroller", // 권한 컨트롤러
   "com.samsung.android.permissioncontroller", // 삼성 권한 컨트롤러
   "android",                       // 안드로이드 시스템
   "com.google.android.permissioncontroller", // Google 권한 컨트롤러
   "com.samsung.android.lool",      // 삼성 디바이스 케어
   "com.samsung.android.oneui.taskmanager", // OneUI 태스크 매니저
   "com.sec.android.app.quicktool", // 삼성 퀵 패널
   "com.samsung.android.incallui",  // 전화 앱
   "com.samsung.android.honeyboard", // 삼성 키보드
   "com.sec.android.app.launcher",  // 삼성 홈 런처
   "com.samsung.android.app.smartcapture", // 삼성 스크린샷
   "com.sec.android.provider.badge", // 삼성 배지 프로바이더
   "com.android.chrome"
)

    override fun onServiceConnected() {
        val info = AccessibilityServiceInfo()
        info.apply {
            eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED
            feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
            flags = AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS
            notificationTimeout = 100L
        }
        serviceInfo = info
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        Log.i(TAG, "Accessibility Service Connected")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent) {
        val isLocked = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .getBoolean(KEY_IS_LOCKED, false)
        
        if (!isLocked) {
            hideBlockingOverlay()
            lastBlockedPackage = ""
            return
        }

        if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            val packageName = event.packageName?.toString()
            
            if (packageName != null && !ALLOWED_PACKAGES.contains(packageName)) {
                if (packageName != lastBlockedPackage) {
                    Log.i(TAG, "Blocking unauthorized app: $packageName")
                    lastBlockedPackage = packageName

                    // 앱 이름 가져오기
                    val appName = try {
                        val packageManager = packageManager
                        val applicationInfo = packageManager.getApplicationInfo(packageName, 0)
                        packageManager.getApplicationLabel(applicationInfo).toString()
                    } catch (e: Exception) {
                        packageName
                    }

                    // 차단 화면 표시
                    showBlockingOverlay()
                    
                    // 홈 화면으로 강제 이동
                    val homeIntent = Intent(Intent.ACTION_MAIN).apply {
                        addCategory(Intent.CATEGORY_HOME)
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    }
                    startActivity(homeIntent)

                    Toast.makeText(this, "'$appName' 앱이 차단되었습니다", Toast.LENGTH_SHORT).show()
                }
            } else {
                lastBlockedPackage = ""
                hideBlockingOverlay()
            }
        }
    }

    private fun showBlockingOverlay() {
        try {
            if (overlayView == null) {
                overlayView = FrameLayout(this).apply {
                    setBackgroundColor(Color.argb(250, 0, 0, 0))
                }

                val params = WindowManager.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY,
                    WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                            WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE or
                            WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
                    PixelFormat.TRANSLUCENT
                ).apply {
                    gravity = Gravity.FILL
                }

                windowManager.addView(overlayView, params)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error showing overlay: ${e.message}")
        }
    }

    private fun hideBlockingOverlay() {
        try {
            overlayView?.let {
                windowManager.removeView(it)
                overlayView = null
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error hiding overlay: ${e.message}")
        }
    }

    override fun onInterrupt() {
        Log.i(TAG, "Accessibility Service Interrupted")
        hideBlockingOverlay()
    }

    override fun onDestroy() {
        super.onDestroy()
        hideBlockingOverlay()
    }
}
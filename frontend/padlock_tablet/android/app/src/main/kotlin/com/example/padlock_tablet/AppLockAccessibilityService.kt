package com.example.padlock_tablet

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.Intent
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import android.widget.Toast
import android.content.Context
import android.view.WindowManager
import android.graphics.PixelFormat
import android.view.Gravity
import android.view.ViewGroup
import android.widget.FrameLayout
import android.graphics.Color
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import okhttp3.OkHttpClient
import okhttp3.Request
import org.json.JSONArray
import java.util.concurrent.CopyOnWriteArraySet
import android.os.Handler
import android.os.Looper

class AppLockAccessibilityService : AccessibilityService() {
    private val TAG = "AppLock_Accessibility"
    private var lastBlockedPackage = ""
    private var overlayView: FrameLayout? = null
    private lateinit var windowManager: WindowManager
    private val coroutineScope = CoroutineScope(Dispatchers.Main + Job())
    private val mainHandler = Handler(Looper.getMainLooper())
    private var updateJob: Job? = null

    // 기본 허용 패키지 목록
    private val DEFAULT_ALLOWED_PACKAGES = setOf(
        "com.example.padlock_tablet",
        "com.android.systemui",
        "com.google.android.apps.nexuslauncher",
        "com.android.launcher3",
        "com.sec.android.app.launcher",
        "com.samsung.android.app.settings",
        "com.android.settings",
        "com.android.permissioncontroller",
        "com.samsung.android.permissioncontroller",
        "android",
        "com.google.android.permissioncontroller",
        "com.samsung.android.lool",
        "com.samsung.android.oneui.taskmanager",
        "com.sec.android.app.quicktool",
        "com.samsung.android.incallui",
        "com.samsung.android.honeyboard",
        "com.samsung.android.app.smartcapture",
        "com.sec.android.provider.badge"
    )

    // Thread-safe한 동적 패키지 목록
    private val dynamicAllowedPackages = CopyOnWriteArraySet<String>().apply {
        addAll(DEFAULT_ALLOWED_PACKAGES)
    }

    private fun startPeriodicUpdates() {
        updateJob = coroutineScope.launch {
            while (isActive) {
                try {
                    fetchAllowedApps()
                    delay(5000)
                } catch (e: Exception) {
                    Log.e(TAG, "Error in periodic update: ${e.message}")
                }
            }
        }
    }

    private fun stopPeriodicUpdates() {
        updateJob?.cancel()
        updateJob = null
    }

    private fun fetchAllowedApps() {
        coroutineScope.launch {
            try {
                val apiUrl = "http://k11b208.p.ssafy.io:8080/app?classroomId=9"
                Log.d(TAG, "Fetching allowed apps from: $apiUrl")
                
                val response = makeRequest(apiUrl)
                Log.d(TAG, "Raw API Response: $response")

                val jsonArray = JSONArray(response)
                Log.d(TAG, "Number of apps in response: ${jsonArray.length()}")

                // 임시 Set을 생성하여 새로운 허용 앱 목록 저장
                val newAllowedPackages = CopyOnWriteArraySet<String>()
                newAllowedPackages.addAll(DEFAULT_ALLOWED_PACKAGES)

                for (i in 0 until jsonArray.length()) {
                    val app = jsonArray.getJSONObject(i)
                    val packageName = app.getString("packageName")
                    val appName = app.getString("appName")
                    
                    // 패키지명 매핑
                    val actualPackageName = when(packageName) {
                        "com.android.youtube" -> "com.google.android.youtube"
                        else -> packageName
                    }
                    
                    Log.d(TAG, "Adding app to allowed list - Name: $appName, Original Package: $packageName, Actual Package: $actualPackageName")
                    newAllowedPackages.add(actualPackageName)
                }

                // 기존 목록과 새로운 목록 비교
                val added = newAllowedPackages.minus(dynamicAllowedPackages)
                val removed = dynamicAllowedPackages.minus(newAllowedPackages)

                if (added.isNotEmpty() || removed.isNotEmpty()) {
                    Log.d(TAG, "Changes in allowed apps - Added: $added, Removed: $removed")
                    // 전체 목록 업데이트
                    dynamicAllowedPackages.clear()
                    dynamicAllowedPackages.addAll(newAllowedPackages)
                }

                Log.d(TAG, "Current dynamicAllowedPackages: $dynamicAllowedPackages")
                
            } catch (e: Exception) {
                Log.e(TAG, "Error fetching allowed apps: ${e.message}")
                e.printStackTrace()
            }
        }
    }

    private suspend fun makeRequest(url: String): String = withContext(Dispatchers.IO) {
        val client = OkHttpClient()
        val request = Request.Builder()
            .url(url)
            .build()

        client.newCall(request).execute().use { response ->
            response.body?.string() ?: ""
        }
    }

    override fun onServiceConnected() {
        val info = AccessibilityServiceInfo().apply {
            eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED
            feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
            flags = AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS
            notificationTimeout = 100L
        }
        serviceInfo = info
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        fetchAllowedApps()
        startPeriodicUpdates()
        Log.i(TAG, "Accessibility Service Connected")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent) {
        if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            val packageName = event.packageName?.toString()
            
            // 패키지 이름 로깅
            Log.d(TAG, "Current package attempt: $packageName")
            Log.d(TAG, "Is package allowed: ${dynamicAllowedPackages.contains(packageName)}")
            
            if (packageName != null && !dynamicAllowedPackages.contains(packageName)) {
                if (packageName != lastBlockedPackage) {
                    lastBlockedPackage = packageName
                    
                    val appName = try {
                        val packageManager = packageManager
                        val applicationInfo = packageManager.getApplicationInfo(packageName, 0)
                        packageManager.getApplicationLabel(applicationInfo).toString()
                    } catch (e: Exception) {
                        packageName
                    }
    
                    Log.d(TAG, "Blocking app - Name: $appName, Package: $packageName")
                    showBlockingOverlay()
                    
                    mainHandler.post {
                        val homeIntent = Intent(Intent.ACTION_MAIN).apply {
                            addCategory(Intent.CATEGORY_HOME)
                            flags = Intent.FLAG_ACTIVITY_NEW_TASK
                        }
                        startActivity(homeIntent)
                        Toast.makeText(this, "'$appName' 앱이 차단되었습니다", Toast.LENGTH_SHORT).show()
                    }
                }
            } else {
                lastBlockedPackage = ""
                hideBlockingOverlay()
            }
        }
    }

    private fun showBlockingOverlay() {
        mainHandler.post {
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
    }

    private fun hideBlockingOverlay() {
        mainHandler.post {
            try {
                overlayView?.let {
                    windowManager.removeView(it)
                    overlayView = null
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error hiding overlay: ${e.message}")
            }
        }
    }

    override fun onInterrupt() {
        Log.i(TAG, "Accessibility Service Interrupted")
        hideBlockingOverlay()
        stopPeriodicUpdates()
    }

    override fun onDestroy() {
        super.onDestroy()
        stopPeriodicUpdates()
        hideBlockingOverlay()
        coroutineScope.launch {
            // cleanup
        }
    }
}
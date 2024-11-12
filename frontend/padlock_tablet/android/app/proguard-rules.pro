# OkHttp
-keepattributes Signature
-keepattributes *Annotation*
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**

# Keep Conscrypt
-keep class org.conscrypt.** { *; }
-keep class org.bouncycastle.** { *; }
-keep class org.openjsse.** { *; }

# General
-keepattributes SourceFile,LineNumberTable
-keep class * extends java.util.ListResourceBundle {
    protected Object[][] getContents();
}
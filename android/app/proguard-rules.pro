# R8 rules for release (ported from snake-classic). SDKs ship their own
# consumer rules; only rules with a documented reason are kept here.

# Play Core (deferred components) is referenced by the Flutter embedding but
# not shipped.
-dontwarn com.google.android.play.core.**

# Readable stack traces.
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# flutter_local_notifications uses Gson for scheduled notifications; R8 full
# mode strips generic signatures without these (the plugin README's rules).
-keep class com.dexterous.** { *; }
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Play Billing + flutter_inapp_purchase (OpenIAP). Kept explicitly per the
# migration playbook: R8 full mode stripped OpenIAP's reflective bridge.
-keep class dev.hyo.** { *; }
-keep class io.github.hyochan.** { *; }
-keep class com.android.vending.billing.**
-keep class com.android.billingclient.** { *; }
-dontwarn dev.hyo.**
-dontwarn io.github.hyochan.**

# WorkManager (pulled in by plugins) opens its Room database reflectively:
# Room looks up the generated `<Database>_Impl` class and its no-arg
# constructor. R8 stripped androidx.work.impl.WorkDatabase_Impl, so release
# builds crashed at launch in WorkManagerInitializer ("Failed to create an
# instance of androidx.work.impl.WorkDatabase").
-keep class * extends androidx.room.RoomDatabase { <init>(); }
-keep class androidx.work.impl.WorkDatabase_Impl { *; }
-dontwarn androidx.room.paging.**

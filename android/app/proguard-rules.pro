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

# Play Billing + flutter_inapp_purchase (OpenIAP) ship consumer rules;
# silence optional references only.
-dontwarn dev.hyo.**
-dontwarn io.github.hyochan.**

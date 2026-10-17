import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing from android/key.properties (gitignored). A release build
// without a usable key fails loudly (see the taskGraph check below): a
// debug-signed bundle would be rejected by Play, so never fall back silently.
// Debug builds never need the key.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasReleaseKey = keystorePropertiesFile.exists()
if (hasReleaseKey) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

/** Why release signing can't work, or null when it can. */
fun releaseSigningProblem(): String? {
    if (!hasReleaseKey) {
        return "android/key.properties is missing."
    }
    val missing = listOf("storeFile", "storePassword", "keyAlias", "keyPassword")
        .filter { keystoreProperties.getProperty(it).isNullOrBlank() }
    if (missing.isNotEmpty()) {
        return "android/key.properties has no value for: ${missing.joinToString()}."
    }
    val store = file(keystoreProperties.getProperty("storeFile"))
    if (!store.exists()) {
        return "The keystore in android/key.properties does not exist: ${store.path}"
    }
    return null
}

gradle.taskGraph.whenReady {
    val releaseTask = allTasks.firstOrNull { it.name.contains("Release") }
    val problem = releaseSigningProblem()
    if (releaseTask != null && problem != null) {
        throw GradleException(
            """
            |
            |Release signing is not set up, so this release build was stopped.
            |  $problem
            |Create android/key.properties (it is gitignored) with:
            |  storeFile=C:/android-keys/screw-out/upload-keystore.jks
            |  storePassword=...
            |  keyAlias=upload
            |  keyPassword=...
            |The upload key and its passwords live in C:/android-keys/screw-out/.
            """.trimMargin(),
        )
    }
}

android {
    namespace = "com.pranta.screwout"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // flutter_local_notifications needs core library desugaring.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.pranta.screwout"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
        // flutter_inapp_purchase (OpenIAP) ships one Android module per store.
        missingDimensionStrategy("platform", "play")
    }

    signingConfigs {
        if (hasReleaseKey) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = keystoreProperties["storeFile"]?.let { file(it) }
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Without a key this stays unset; the taskGraph check stops the build first.
            if (hasReleaseKey) signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    // WindowCompat.enableEdgeToEdge(Window) (MainActivity) needs core 1.16+.
    implementation("androidx.core:core:1.18.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}

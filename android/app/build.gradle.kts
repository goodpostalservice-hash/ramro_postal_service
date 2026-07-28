 import java.util.Properties
 import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}
 val keystoreProperties = Properties()
 val keystorePropertiesFile = rootProject.file("key.properties")
 if (keystorePropertiesFile.exists()) {
     keystoreProperties.load(FileInputStream(keystorePropertiesFile))
 }

val dotenvProperties = Properties()
val dotenvFile = rootProject.file("../.env")
if (dotenvFile.exists()) {
    dotenvFile.inputStream().use(dotenvProperties::load)
}

val googleMapsApiKey = dotenvProperties.getProperty("GOOGLE_MAP_API_KEY")
    ?: error("GOOGLE_MAP_API_KEY is missing from the project .env file")

val mapboxKey = dotenvProperties.getProperty("MAPBOX_KEY")
    ?: error("MAPBOX_KEY is missing from the project .env file")

android {
    namespace = "com.gps.ramro_postal_service"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
    packaging {
        jniLibs {
            useLegacyPackaging = true
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.gps.ramro_postal_service"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["googleMapsApiKey"] = googleMapsApiKey
        resValue("string", "mapbox_access_token", mapboxKey)
    }
    signingConfigs {
         create("release") {
             storeFile = file(keystoreProperties["storeFile"] as String)
             storePassword = keystoreProperties["storePassword"] as String
             keyAlias = keystoreProperties["keyAlias"] as String
             keyPassword = keystoreProperties["keyPassword"] as String
         }
     }
    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
           // signingConfig = signingConfigs.getByName("debug")
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

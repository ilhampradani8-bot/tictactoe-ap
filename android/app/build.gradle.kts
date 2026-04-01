import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// --- BAGIAN PENAMBAHAN UNTUK BACA KEYSTORE ---
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.projectDir.resolve("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
// ---------------------------------------------

android {
    namespace = "com.ilham.tictactoe"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // --- KONFIGURASI TANDA TANGAN (SIGNING) ---
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { rootProject.projectDir.resolve(it as String) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    // ------------------------------------------

    defaultConfig {
        applicationId = "com.ilham.tictactoe"
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // UBAH DARI "debug" MENJADI "release"
            signingConfig = signingConfigs.getByName("release")
            
            minifyEnabled = false
            shrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// 1. Load file key.properties dengan cara yang lebih pasti
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.projectDir.resolve("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    println("BERHASIL: File key.properties ditemukan di: ${keystorePropertiesFile.absolutePath}")
} else {
    println("PERINGATAN: File key.properties TIDAK DITEMUKAN di: ${keystorePropertiesFile.absolutePath}")
}

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

    // 2. Konfigurasi signing yang lebih aman
    signingConfigs {
        create("release") {
            // Kita pakai "?: """ supaya kalau null dia jadi teks kosong, bukan error NullPointer
            keyAlias = keystoreProperties.getProperty("keyAlias") ?: ""
            keyPassword = keystoreProperties.getProperty("keyPassword") ?: ""
            storePassword = keystoreProperties.getProperty("storePassword") ?: ""
            
            val storeFileName = keystoreProperties.getProperty("storeFile")
            if (storeFileName != null) {
                storeFile = rootProject.projectDir.resolve(storeFileName)
            }
        }
    }

    defaultConfig {
        applicationId = "com.ilham.tictactoe"
        minSdk = 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Gunakan signing release HANYA JIKA datanya lengkap
            if (keystoreProperties.containsKey("keyAlias")) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                signingConfig = signingConfigs.getByName("debug")
            }
            
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

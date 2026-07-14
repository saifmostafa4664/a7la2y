plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.kanan.a7la2y"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.kanan.a7la2y"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // تحسينات الأداء
        multiDexEnabled = true
        
        // تحسين استخدام الذاكرة
        vectorDrawables {
            useSupportLibrary = true
        }
    }

    buildTypes {
        release {
            // تحسينات للإصدار النهائي
            minifyEnabled = true
            shrinkResources = true
            
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            
            signingConfig = signingConfigs.getByName("debug")
        }
        
        debug {
            // تحسينات للتطوير
            minifyEnabled = false
            shrinkResources = false
        }
    }
    
    // تحسين سرعة البناء
    buildFeatures {
        buildConfig = true
    }
}

flutter {
    source = "../.."
}

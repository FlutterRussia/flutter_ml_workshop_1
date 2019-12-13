package com.example.flutter_ml_workshop_1

import android.os.Bundle
import com.google.firebase.FirebaseApp

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    FirebaseApp.initializeApp(this)

    MlkitPlugin.registerWith(this.registrarFor(MlkitPlugin::class.java.canonicalName))
  }
}

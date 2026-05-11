package pt.up.fe.ni.uni

import android.annotation.SuppressLint
import io.flutter.embedding.android.FlutterActivity
import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import android.appwidget.AppWidgetProviderInfo
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.launch
import pt.up.fe.ni.uni.receivers.ScheduleWidgetReceiver
import pt.up.fe.ni.uni.receivers.ScheduleWidgetWideReceiver

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Disable the Android splash screen fade out animation to avoid
            // a flicker before the similar frame is drawn in Flutter.
            splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
        }

        super.onCreate(savedInstanceState)
        setWidgetPreviews()
    }

    @SuppressLint("CheckResult")
    private fun setWidgetPreviews() {
        if (Build.VERSION.SDK_INT >= 35) { // Android 15
            val glanceAppWidgetManager = GlanceAppWidgetManager(this)

            lifecycleScope.launch {
                // Small Widget Preview
                glanceAppWidgetManager.setWidgetPreviews(ScheduleWidgetReceiver::class)

                // Wide Widget Preview
                glanceAppWidgetManager.setWidgetPreviews(ScheduleWidgetWideReceiver::class)
            }
        }
    }
}

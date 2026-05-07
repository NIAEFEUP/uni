package pt.up.fe.ni.uni

import io.flutter.embedding.android.FlutterActivity
import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProviderInfo
import android.content.ComponentName
import android.widget.RemoteViews
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

    private fun setWidgetPreviews() {
        if (Build.VERSION.SDK_INT >= 35) { // Android 15
            val appWidgetManager = AppWidgetManager.getInstance(this)

            // Small Widget Preview
            appWidgetManager.setWidgetPreview(
                ComponentName(this, ScheduleWidgetReceiver::class.java),
                AppWidgetProviderInfo.WIDGET_CATEGORY_HOME_SCREEN,
                RemoteViews(packageName, R.layout.schedule_widget_preview)
            )

            // Wide Widget Preview
            appWidgetManager.setWidgetPreview(
                ComponentName(this, ScheduleWidgetWideReceiver::class.java),
                AppWidgetProviderInfo.WIDGET_CATEGORY_HOME_SCREEN,
                RemoteViews(packageName, R.layout.schedule_widget_wide_preview)
            )
        }
    }
}

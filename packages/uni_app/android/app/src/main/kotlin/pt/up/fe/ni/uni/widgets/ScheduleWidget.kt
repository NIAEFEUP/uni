package pt.up.fe.ni.uni.widgets

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.glance.GlanceId
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.text.Text
import androidx.glance.layout.*
import androidx.glance.GlanceModifier

class ScheduleWidget : GlanceAppWidget() {
    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            WidgetUI()
        }
    }

    @Composable
    fun WidgetUI() {
        Column(modifier = GlanceModifier.fillMaxSize()) {
            Text(text = "Hello from Flutter!")
        }
    }
}
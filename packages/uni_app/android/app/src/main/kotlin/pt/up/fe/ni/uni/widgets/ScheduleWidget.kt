package pt.up.fe.ni.uni.widgets

import android.annotation.SuppressLint
import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import pt.up.fe.ni.uni.R
import androidx.glance.layout.*
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import androidx.glance.layout.Alignment

class ScheduleWidget : GlanceAppWidget() {
    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            WidgetUI()
        }
    }

    @SuppressLint("RestrictedApi")
    @Composable
    fun WidgetUI() {
        val primaryTextColor = ColorProvider(Color(0xFF000000))
        val secondaryTextColor = ColorProvider(Color(0xFF888888))

        Box(
            modifier = GlanceModifier
                .fillMaxSize()
                .background(ImageProvider(R.drawable.widget_background))
                .padding(16.dp),
            contentAlignment = Alignment.TopStart
        ) {
            Column(modifier = GlanceModifier.fillMaxSize()) {
                // Top Row: Time and Badge
                Row(
                    modifier = GlanceModifier.fillMaxWidth(),
                    horizontalAlignment = Alignment.Start,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "8:30",
                        style = TextStyle(
                            fontSize = 24.sp,
                            fontWeight = FontWeight.Bold,
                            color = primaryTextColor
                        )
                    )
                    Spacer(modifier = GlanceModifier.defaultWeight())
                    Box(
                        modifier = GlanceModifier
                            .background(ImageProvider(R.drawable.badge_background))
                            .padding(horizontal = 12.dp, vertical = 4.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = "TP",
                            style = TextStyle(
                                fontSize = 14.sp,
                                fontWeight = FontWeight.Medium,
                                color = ColorProvider(Color.White)
                            )
                        )
                    }
                }

                Spacer(modifier = GlanceModifier.height(16.dp))

                // Middle Section: Course Acronym and Name
                Text(
                    text = "C",
                    style = TextStyle(
                        fontSize = 32.sp,
                        fontWeight = FontWeight.Bold,
                        color = primaryTextColor
                    )
                )
                Text(
                    text = "Compiladores",
                    style = TextStyle(
                        fontSize = 18.sp,
                        color = secondaryTextColor
                    )
                )

                Spacer(modifier = GlanceModifier.defaultWeight())

                // Bottom Section: Location
                Row(
                    modifier = GlanceModifier.fillMaxWidth(),
                    horizontalAlignment = Alignment.End,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Box(
                        modifier = GlanceModifier
                            .size(32.dp)
                            .background(ImageProvider(R.drawable.icon_background)),
                        contentAlignment = Alignment.Center
                    ) {
                        Image(
                            provider = ImageProvider(R.drawable.ic_pin),
                            contentDescription = "Location",
                            modifier = GlanceModifier.size(16.dp)
                        )
                    }
                    Spacer(modifier = GlanceModifier.width(8.dp))
                    Text(
                        text = "B310",
                        style = TextStyle(
                            fontSize = 20.sp,
                            fontWeight = FontWeight.Bold,
                            color = primaryTextColor
                        )
                    )
                }
            }
        }
    }
}
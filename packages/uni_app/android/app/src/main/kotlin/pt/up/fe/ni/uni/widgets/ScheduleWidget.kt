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
import androidx.glance.appwidget.appWidgetBackground
import androidx.glance.appwidget.cornerRadius
import androidx.glance.background
import pt.up.fe.ni.uni.R
import androidx.glance.layout.*
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import androidx.glance.LocalContext
import androidx.glance.layout.Alignment
import androidx.glance.state.GlanceStateDefinition
import es.antonborri.home_widget.HomeWidgetGlanceState
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition
import androidx.glance.currentState
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

class ScheduleWidget : GlanceAppWidget() {
    override val stateDefinition: GlanceStateDefinition<*> = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            val state = currentState<HomeWidgetGlanceState>()
            val prefs = state.preferences
            val scheduleDataJson = prefs.getString("schedule_data", null)

            val lectures = if (scheduleDataJson != null) {
                try {
                    val type = object : TypeToken<List<Map<String, Any>>>() {}.type
                    Gson().fromJson<List<Map<String, Any>>>(scheduleDataJson, type)
                } catch (e: Exception) {
                    emptyList()
                }
            } else {
                emptyList()
            }

            val nextLecture = lectures.firstOrNull()

            val acronym = nextLecture?.let { it["acronym"] as? String }
            val subject = nextLecture?.let { it["subject"] as? String }
            val typeClass = nextLecture?.let { it["typeClass"] as? String }
            val room = nextLecture?.let { it["room"] as? String }
            val startTimeStr = nextLecture?.let { it["startTime"] as? String }

            WidgetUI(acronym, subject, typeClass, room, startTimeStr)
        }
    }

    @SuppressLint("RestrictedApi")
    @Composable
    fun WidgetUI(
        acronym: String?,
        subject: String?,
        typeClass: String?,
        room: String?,
        startTimeStr: String?
    ) {
        val backgroundColor = Color(0xFFF8E8E3)
        val primaryTextColor = ColorProvider(Color(0xFF000000))
        val secondaryTextColor = ColorProvider(Color(0xFF888888))
        val tColor = Color(0xFFFBC11F)
        val tpColor = Color(0xFFD3944C)
        val badgeColor = if (typeClass == "T") tColor else tpColor
        val iconContainerColor = Color(0xFF6B1B1B)

        val context = LocalContext.current
        val displayTime = try {
            if (startTimeStr != null) {
                // Dart format: 2023-10-27 08:30:00.000
                val timePart = startTimeStr.split(" ")[1] // get "08:30:00.000"
                val parts = timePart.split(":")
                val hour = parts[0].toInt().toString() // remove leading zero from hour
                val minute = parts[1]
                "$hour:$minute"
            } else {
                "--:--"
            }
        } catch (e: Exception) {
            "--:--"
        }

        Box(
            modifier = GlanceModifier
                .fillMaxSize()
                .appWidgetBackground()
                .background(backgroundColor)
                .cornerRadius(R.dimen.widget_radius)
                .padding(16.dp),
            contentAlignment = Alignment.TopStart
        ) {
            if (acronym == null) {
                Box(modifier = GlanceModifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Text(text = "No upcoming classes", style = TextStyle(color = secondaryTextColor))
                }
            } else {
                Column(modifier = GlanceModifier.fillMaxSize()) {
                    // Top Row: Time and Badge
                    Row(
                        modifier = GlanceModifier.fillMaxWidth(),
                        horizontalAlignment = Alignment.Start,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = displayTime,
                            style = TextStyle(
                                fontSize = 22.sp,
                                fontWeight = FontWeight.Bold,
                                color = primaryTextColor
                            )
                        )
                        Spacer(modifier = GlanceModifier.defaultWeight())
                        Box(
                            modifier = GlanceModifier
                                .background(badgeColor)
                                .cornerRadius(100.dp)
                                .padding(horizontal = 12.dp, vertical = 4.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(
                                text = typeClass ?: "",
                                style = TextStyle(
                                    fontSize = 12.sp,
                                    fontWeight = FontWeight.Medium,
                                    color = ColorProvider(Color.White)
                                )
                            )
                        }
                    }

                    Spacer(modifier = GlanceModifier.height(16.dp))

                    // Middle Section: Course Acronym and Name
                    Text(
                        text = acronym,
                        style = TextStyle(
                            fontSize = 32.sp,
                            fontWeight = FontWeight.Bold,
                            color = primaryTextColor
                        )
                    )
                    Text(
                        text = subject ?: "",
                        style = TextStyle(
                            fontSize = 16.sp,
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
                                .size(30.dp)
                                .background(iconContainerColor)
                                .cornerRadius(16.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            Image(
                                provider = ImageProvider(R.drawable.ic_pin),
                                contentDescription = "Location",
                                modifier = GlanceModifier.size(14.dp)
                            )
                        }
                        Spacer(modifier = GlanceModifier.width(8.dp))
                        Text(
                            text = room ?: "",
                            style = TextStyle(
                                fontSize = 18.sp,
                                fontWeight = FontWeight.Bold,
                                color = primaryTextColor
                            )
                        )
                    }
                }
            }
        }
    }
}

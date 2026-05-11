package pt.up.fe.ni.uni.widgets

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.LocalContext
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.PreviewSizeMode
import androidx.glance.appwidget.action.actionStartActivity
import androidx.glance.appwidget.appWidgetBackground
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.*
import androidx.glance.state.GlanceStateDefinition
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.color.ColorProvider
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import es.antonborri.home_widget.HomeWidgetGlanceState
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition
import pt.up.fe.ni.uni.MainActivity
import pt.up.fe.ni.uni.R
import java.time.LocalDateTime

class ScheduleWideWidget : GlanceAppWidget() {
    override val stateDefinition: GlanceStateDefinition<*> = HomeWidgetGlanceStateDefinition()

    override val sizeMode: SizeMode = SizeMode.Single

    override val previewSizeMode: PreviewSizeMode = SizeMode.Single

    override suspend fun providePreview(context: Context, widgetCategory: Int) {
        val sampleLectures = listOf(
            mapOf(
                "acronym" to "C",
                "subject" to "Compiladores",
                "typeClass" to "TP",
                "room" to "B102",
                "startTime" to "2024-05-11 09:00:00.000",
                "endTime" to "2024-05-11 11:00:00.000"
            ),
            mapOf(
                "acronym" to "IA",
                "subject" to "Inteligencia Artificial",
                "typeClass" to "PL",
                "room" to "B203",
                "startTime" to "2024-05-11 11:30:00.000",
                "endTime" to "2024-05-11 13:30:00.000"
            )
        )

        provideContent {
            WideWidgetUI(sampleLectures)
        }
    }

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            val state = currentState<HomeWidgetGlanceState>()
            val prefs = state.preferences
            val scheduleDataJson = prefs.getString("schedule_data", null)

            val allLectures = if (scheduleDataJson != null) {
                try {
                    val type = object : TypeToken<List<Map<String, Any>>>() {}.type
                    Gson().fromJson<List<Map<String, Any>>>(scheduleDataJson, type)
                } catch (e: Exception) {
                    emptyList()
                }
            } else {
                emptyList()
            }

            // Filter lectures based on current time
            val now = LocalDateTime.now()
            val scheduleWidget = ScheduleWidget()
            val lectures = allLectures.filter { lecture ->
                val endTimeStr = lecture["endTime"] as? String
                val endTime = scheduleWidget.parseDateTime(endTimeStr)
                endTime?.isAfter(now) ?: false
            }

            WideWidgetUI(lectures)
        }
    }

    @SuppressLint("RestrictedApi")
    @Composable
    fun WideWidgetUI(lectures: List<Map<String, Any>>) {
        val context = LocalContext.current
        val scheduleWidget = ScheduleWidget()

        Box(
            modifier = GlanceModifier
                .fillMaxSize()
                .appWidgetBackground()
                .background(WidgetTheme.Background)
                .cornerRadius(R.dimen.widget_radius)
                .padding(horizontal = 12.dp, vertical = 12.dp)
                .clickable(actionStartActivity(Intent(context, MainActivity::class.java))),
            contentAlignment = Alignment.TopStart
        ) {
            if (lectures.isEmpty()) {
                Box(modifier = GlanceModifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Text(text = "No upcoming classes", style = TextStyle(color = WidgetTheme.SecondaryText))
                }
            } else {
                Column(modifier = GlanceModifier.fillMaxSize()) {
                    lectures.take(2).forEachIndexed { index, lecture ->
                        Row(
                            modifier = GlanceModifier.fillMaxWidth().defaultWeight(),
                            verticalAlignment = Alignment.Top
                        ) {
                            // Timeline Item for this lecture
                            val startTimeStr = lecture["startTime"] as? String
                            val displayTime = scheduleWidget.formatTime(startTimeStr)

                            // Time Text Column
                            Column(
                                modifier = GlanceModifier.width(50.dp).fillMaxHeight(),
                                horizontalAlignment = Alignment.End
                            ) {
                                Box(
                                    modifier = GlanceModifier.fillMaxWidth().height(24.dp),
                                    contentAlignment = Alignment.CenterEnd
                                ) {
                                    Text(
                                        text = displayTime,
                                        style = TextStyle(
                                            fontSize = 16.sp,
                                            fontWeight = FontWeight.Bold,
                                            color = WidgetTheme.Accent
                                        )
                                    )
                                }
                            }

                            Spacer(modifier = GlanceModifier.width(10.dp))

                            // Dot + Line Column (Guarantees connection)
                            Box(
                                modifier = GlanceModifier.fillMaxHeight().width(22.dp),
                                contentAlignment = Alignment.TopCenter
                            ) {
                                // Line (behind)
                                Column(
                                    modifier = GlanceModifier.fillMaxSize(),
                                    horizontalAlignment = Alignment.CenterHorizontally
                                ) {
                                    Spacer(modifier = GlanceModifier.height(12.dp)) // To the center of the 24dp dot box
                                    Box(
                                        modifier = GlanceModifier
                                            .width(3.dp)
                                            .defaultWeight()
                                            .background(WidgetTheme.Accent)
                                    ) {}
                                }

                                // Dot (front)
                                Box(
                                    modifier = GlanceModifier.fillMaxWidth().height(24.dp),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Box(
                                        modifier = GlanceModifier
                                            .size(17.dp)
                                            .background(WidgetTheme.Accent)
                                            .cornerRadius(8.dp),
                                        contentAlignment = Alignment.Center
                                    ) {
                                        Box(
                                            modifier = GlanceModifier
                                                .size(10.dp)
                                                .background(WidgetTheme.Background)
                                                .cornerRadius(5.dp)
                                        ) {}
                                    }
                                }
                            }

                            Spacer(modifier = GlanceModifier.width(8.dp))

                            // Lecture Card
                            Box(modifier = GlanceModifier.defaultWeight()) {
                                LectureCard(lecture)
                            }
                        }

                        if (index == 0 && lectures.size > 1) {
                            Spacer(modifier = GlanceModifier.height(12.dp))
                        }
                    }
                }
            }
        }
    }

    @Composable
    private fun LectureCard(
        lecture: Map<String, Any>
    ) {
        val acronym = lecture["acronym"] as? String ?: ""
        val subject = lecture["subject"] as? String ?: ""
        val typeClass = lecture["typeClass"] as? String ?: ""
        val room = lecture["room"] as? String ?: ""
        val badgeColor = WidgetTheme.getBadgeColor(typeClass)

        Box(
            modifier = GlanceModifier
                .fillMaxWidth()
                .background(WidgetTheme.CardBackground)
                .cornerRadius(24.dp)
                .padding(horizontal = 16.dp, vertical = 16.dp)
        ) {
            Column(modifier = GlanceModifier.fillMaxWidth()) {
                Row(
                    modifier = GlanceModifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = acronym,
                        style = TextStyle(
                            fontSize = 24.sp,
                            fontWeight = FontWeight.Bold,
                            color = WidgetTheme.PrimaryText
                        )
                    )
                    Spacer(modifier = GlanceModifier.width(10.dp))
                    Box(
                        modifier = GlanceModifier
                            .background(badgeColor)
                            .cornerRadius(100.dp)
                            .padding(horizontal = 10.dp, vertical = 3.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = typeClass,
                            style = TextStyle(
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Medium,
                                color = ColorProvider(day = Color.White, night = Color.White)
                            )
                        )
                    }
                    Spacer(modifier = GlanceModifier.defaultWeight())
                    // Location
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Box(
                            modifier = GlanceModifier
                                .size(24.dp)
                                .background(WidgetTheme.Accent)
                                .cornerRadius(12.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            Image(
                                provider = ImageProvider(R.drawable.ic_pin),
                                contentDescription = "Location",
                                modifier = GlanceModifier.size(14.dp)
                            )
                        }
                        Spacer(modifier = GlanceModifier.width(6.dp))
                        Text(
                            text = room,
                            style = TextStyle(
                                fontSize = 18.sp,
                                fontWeight = FontWeight.Bold,
                                color = WidgetTheme.PrimaryText
                            )
                        )
                    }
                }
                Spacer(modifier = GlanceModifier.height(4.dp))
                Text(
                    text = subject,
                    style = TextStyle(
                        fontSize = 14.sp,
                        color = WidgetTheme.SecondaryText
                    ),
                    maxLines = 1
                )
            }
        }
    }
}

package pt.up.fe.ni.uni.widgets

import android.annotation.SuppressLint
import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.DpSize
import androidx.glance.appwidget.SizeMode
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.appwidget.appWidgetBackground
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.action.actionStartActivity
import android.content.Intent
import androidx.glance.action.clickable
import androidx.glance.background
import pt.up.fe.ni.uni.MainActivity
import pt.up.fe.ni.uni.R
import androidx.glance.layout.*
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import androidx.glance.color.ColorProvider
import androidx.glance.LocalContext
import androidx.glance.layout.Alignment
import androidx.glance.state.GlanceStateDefinition
import es.antonborri.home_widget.HomeWidgetGlanceState
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition
import androidx.glance.currentState
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

private object WidgetTheme {
    val Background = ColorProvider(day = Color(0xFFFFF5F3), night = Color(0xFF2F0A0C))
    val PrimaryText = ColorProvider(day = Color(0xFF000000), night = Color(0xFFFFFFFF))
    val SecondaryText = ColorProvider(day = Color(0xFF888888), night = Color(0xFFE5C8C7))
    val Accent = ColorProvider(day = Color(0xFF6B1B1B), night = Color(0xFFE5C8C7))
    val CardBackground = ColorProvider(day = Color(0xFFF2E9E7), night = Color(0xFF4E3636))

    fun getBadgeColor(typeClass: String?): Color {
        return if (typeClass == "TP") Color(0xFFD3944C) else Color(0xFFFBC11F)
    }
}

class ScheduleWidget : GlanceAppWidget() {
    override val stateDefinition: GlanceStateDefinition<*> = HomeWidgetGlanceStateDefinition()

    override val sizeMode: SizeMode = SizeMode.Responsive(
        setOf(
            DpSize(110.dp, 110.dp), // Small (2x2)
            DpSize(250.dp, 110.dp)  // Wide (4x2)
        )
    )

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
            val lectures = allLectures.filter { lecture ->
                val endTimeStr = lecture["endTime"] as? String
                val endTime = parseDateTime(endTimeStr)
                endTime?.isAfter(now) ?: false
            }

            val size = androidx.glance.LocalSize.current
            if (size.width >= 200.dp) {
                WideWidgetUI(lectures)
            } else {
                val nextLecture = lectures.firstOrNull()
                val acronym = nextLecture?.let { it["acronym"] as? String }
                val subject = nextLecture?.let { it["subject"] as? String }
                val typeClass = nextLecture?.let { it["typeClass"] as? String }
                val room = nextLecture?.let { it["room"] as? String }
                val startTimeStr = nextLecture?.let { it["startTime"] as? String }
                WidgetUI(acronym, subject, typeClass, room, startTimeStr)
            }
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
        val badgeColor = WidgetTheme.getBadgeColor(typeClass)

        val context = LocalContext.current
        val displayTime = formatTime(startTimeStr)

        Box(
            modifier = GlanceModifier
                .fillMaxSize()
                .appWidgetBackground()
                .background(WidgetTheme.Background)
                .cornerRadius(R.dimen.widget_radius)
                .padding(12.dp)
                .clickable(actionStartActivity(Intent(context, MainActivity::class.java))),
            contentAlignment = Alignment.TopStart
        ) {
            if (acronym == null) {
                Box(modifier = GlanceModifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Text(text = "No upcoming classes", style = TextStyle(color = WidgetTheme.SecondaryText))
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
                                fontSize = 20.sp,
                                fontWeight = FontWeight.Bold,
                                color = WidgetTheme.PrimaryText
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
                            fontSize = 28.sp,
                            fontWeight = FontWeight.Bold,
                            color = WidgetTheme.PrimaryText
                        )
                    )
                    Text(
                        text = subject ?: "",
                        style = TextStyle(
                            fontSize = 15.sp,
                            color = WidgetTheme.SecondaryText
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
                                .background(WidgetTheme.Accent)
                                .cornerRadius(16.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            Image(
                                provider = ImageProvider(R.drawable.ic_pin),
                                contentDescription = "Location",
                                modifier = GlanceModifier.size(18.dp)
                            )
                        }
                        Spacer(modifier = GlanceModifier.width(8.dp))
                        Text(
                            text = room ?: "",
                            style = TextStyle(
                                fontSize = 18.sp,
                                fontWeight = FontWeight.Bold,
                                color = WidgetTheme.PrimaryText
                            )
                        )
                    }
                }
            }
        }
    }

    @SuppressLint("RestrictedApi")
    @Composable
    fun WideWidgetUI(lectures: List<Map<String, Any>>) {
        val context = LocalContext.current

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
                            val displayTime = formatTime(startTimeStr)

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

    private fun parseDateTime(dateTimeStr: String?): LocalDateTime? {
        if (dateTimeStr == null) return null
        return try {
            // Flutter's DateTime.toString() returns "YYYY-MM-DD HH:MM:SS.mmm"
            // LocalDateTime.parse expects ISO format "YYYY-MM-DDTHH:MM:SS"
            val cleanStr = dateTimeStr.replace(" ", "T")
            LocalDateTime.parse(cleanStr)
        } catch (e: Exception) {
            null
        }
    }

    private fun formatTime(startTimeStr: String?): String {
        return try {
            if (startTimeStr != null) {
                val timePart = startTimeStr.split(" ")[1]
                val parts = timePart.split(":")
                val hour = parts[0].toInt().toString().padStart(2, '0')
                val minute = parts[1]
                "$hour:$minute"
            } else {
                "--:--"
            }
        } catch (e: Exception) {
            "--:--"
        }
    }
}

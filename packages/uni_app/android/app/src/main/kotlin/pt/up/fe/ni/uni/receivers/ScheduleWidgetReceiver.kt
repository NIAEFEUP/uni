package pt.up.fe.ni.uni.receivers

import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver
import pt.up.fe.ni.uni.widgets.ScheduleWidget

class ScheduleWidgetReceiver : HomeWidgetGlanceWidgetReceiver<ScheduleWidget>() {
    override val glanceAppWidget = ScheduleWidget()
}
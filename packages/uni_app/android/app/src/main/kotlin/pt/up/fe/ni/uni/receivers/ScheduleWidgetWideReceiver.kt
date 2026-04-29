package pt.up.fe.ni.uni.receivers

import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver
import pt.up.fe.ni.uni.widgets.ScheduleWidget

class ScheduleWidgetWideReceiver : HomeWidgetGlanceWidgetReceiver<ScheduleWidget>() {
    override val glanceAppWidget = ScheduleWidget()
}

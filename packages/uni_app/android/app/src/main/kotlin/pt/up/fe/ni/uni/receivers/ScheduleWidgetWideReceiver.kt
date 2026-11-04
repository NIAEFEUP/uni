package pt.up.fe.ni.uni.receivers

import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver
import pt.up.fe.ni.uni.widgets.ScheduleWideWidget

class ScheduleWidgetWideReceiver : HomeWidgetGlanceWidgetReceiver<ScheduleWideWidget>() {
    override val glanceAppWidget = ScheduleWideWidget()
}

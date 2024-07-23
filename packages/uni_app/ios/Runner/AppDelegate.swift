import UIKit
import Flutter
import workmanager
import flutter_local_notifications
import app_links

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
    // Notifications
    WorkmanagerPlugin.registerTask(withIdentifier:"pt.up.fe.ni.uni.notificationworker")
    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*15))
    //in case we have a notification with actions 
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
      
    // Custom url schemes & retrieve the link from parameters
    if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
        // We have a link, propagate it to your Flutter app
        AppLinks.shared.handleLink(url: url)
        return true // Returning true will stop the propagation to other packages
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

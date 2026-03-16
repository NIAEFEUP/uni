import UIKit
import Flutter

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)
        
        let controller = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        
        // Attach the native Launch Screen to hide the black screen transition
        if let storyboardName = Bundle.main.object(forInfoDictionaryKey: "UILaunchStoryboardName") as? String,
           let launchScreen = UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController()?.view {
            launchScreen.frame = UIScreen.main.bounds
            controller.splashScreenView = launchScreen
        }
        
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
}
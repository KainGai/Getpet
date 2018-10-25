import UIKit
import PetAdoptionTransportKit
import Fabric
import Crashlytics
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		self.applyDefaultAppStyles()
        Fabric.with([Crashlytics.self])
        if #available(iOS 10.0, *){
            let entiity = JPUSHRegisterEntity()
            entiity.types = Int(UNAuthorizationOptions.alert.rawValue |
                UNAuthorizationOptions.badge.rawValue |
                UNAuthorizationOptions.sound.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entiity, delegate: self)
        } else if #available(iOS 8.0, *) {
            let types = UIUserNotificationType.badge.rawValue |
                UIUserNotificationType.sound.rawValue |
                UIUserNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: types, categories: nil)
        }else {
            let type = UIRemoteNotificationType.badge.rawValue |
                UIRemoteNotificationType.sound.rawValue |
                UIRemoteNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: type, categories: nil)
        }
        JPUSHService.setup(withOption: launchOptions,
                           appKey: "90edaa27e94deee6bb26f124",
                           channel: "PetsGet",
                           apsForProduction: false)
		return true
	}
	func applicationWillResignActive(_ application: UIApplication) {
	}
	func applicationDidEnterBackground(_ application: UIApplication) {
	}
	func applicationWillEnterForeground(_ application: UIApplication) {
	}
	func applicationDidBecomeActive(_ application: UIApplication) {
	}
	func applicationWillTerminate(_ application: UIApplication) {
	}
	private func applyDefaultAppStyles() {
		let navBar = UINavigationBar.appearance()
		navBar.barTintColor = UIColor.themePrimaryColor()
		navBar.tintColor = UIColor.themeTintColor()
		navBar.titleTextAttributes = [
			NSAttributedStringKey.foregroundColor : UIColor.themeNavBarTitleColor(),
			NSAttributedStringKey.font: UIFont.themeNormalFont(ofSize: 17.0)]
		navBar.barStyle = .black
		UIButton.appearance().tintColor = UIColor.themeTintColor()
		UIBarButtonItem.appearance().tintColor = UIColor.themeTintColor()
		UITabBar.appearance().tintColor = UIColor.themePrimaryColor()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font:UIFont.themeNormalFont(ofSize: 10.0)], for: UIControlState.normal)
	}
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(.newData)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }
}
extension AppDelegate : JPUSHRegisterDelegate{
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNAuthorizationOptions.alert.rawValue))
    }
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
}

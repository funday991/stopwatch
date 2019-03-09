import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        calculateBackgroundTime()

        return true
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    
    func applicationDidEnterBackground(_ application: UIApplication) {
        guard
            let window = window,
            let viewController = window.rootViewController as? ViewController,
            let stopwatch = viewController.stopwatch
        else { return }
        
        let stopwatchIsRunning = stopwatch.state == .running

        UserDefaults.standard.set(
            stopwatchIsRunning ? Int(Date().timeIntervalSince1970 * 100) : 0,
            forKey: "timeAfterEnteringBackground"
        )
        
        UserDefaults.standard.set(stopwatch.centisecondsCounter, forKey: "suspendedStopwatchValue")
        UserDefaults.standard.set(stopwatchIsRunning, forKey: "stopwatchIsRunning")
    }

    
    func applicationWillEnterForeground(_ application: UIApplication) {
        calculateBackgroundTime()
    }
    

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    
    func applicationWillTerminate(_ application: UIApplication) {
    
    }
    
    
    func calculateBackgroundTime() {
        let timeAfterEnteringBackground = UserDefaults.standard.integer(forKey: "timeAfterEnteringBackground")
        let timeAfterBecomingActive = timeAfterEnteringBackground > 0 ? Int(Date().timeIntervalSince1970 * 100) : 0
        
        UserDefaults.standard.set(timeAfterBecomingActive - timeAfterEnteringBackground, forKey: "backgroundStopwatchValue")
    }
    
}


import Cocoa

let args = CommandLine.arguments.dropFirst()
var except = false
var blockedApps = args
if (args.first! == "except") { 
    except = true; 
    print(blockedApps)
    blockedApps = args.dropFirst()
}

// For a manual command line utility (entering one by one)
// if (blockedApps == []) {
//     var newApp = "Finder"
//     blockedApps = ["Finder"]

//     while (newApp != "") {
//         print("Enter first app (blank to continue):")
//         newApp = readLine()!
//         blockedApps.append(newApp)
//         print(blockedApps)
//     }

//     blockedApps.remove(at: 0)
//     print(blockedApps)
// }

func isBlocked() -> Bool {
    return true;
}

NSWorkspace.shared.notificationCenter.addObserver(
    forName: NSWorkspace.didLaunchApplicationNotification,
    object: nil,
    queue: .main
) { notification in
    if let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication {
        if except {
            if (!blockedApps.contains(app.localizedName ?? "") && isBlocked()) {
                print(app.localizedName)
                app.forceTerminate()
            }
        } else {
            if blockedApps.contains(app.localizedName ?? "") && isBlocked() {
                print(app.localizedName)
                app.forceTerminate()
            }
        }
    }
}

RunLoop.main.run()


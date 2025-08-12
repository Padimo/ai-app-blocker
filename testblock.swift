import Cocoa

var blockedApps = CommandLine.arguments.dropFirst()

if (blockedApps == []) {
    var newApp = "Finder"
    blockedApps = ["Finder"]

    while (newApp != "") {
        print("Enter first app (blank to continue):")
        newApp = readLine()!
        blockedApps.append(newApp)
        print(blockedApps)
    }

    blockedApps.remove(at: 0)
    print(blockedApps)
}

func isBlocked() -> Bool {
    return true;
}

NSWorkspace.shared.notificationCenter.addObserver(
    forName: NSWorkspace.didLaunchApplicationNotification,
    object: nil,
    queue: .main
) { notification in
    if let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication {
        if blockedApps.contains(app.localizedName ?? "") && isBlocked() {
            print(app.localizedName)
            app.forceTerminate()
        }
    }
}

RunLoop.main.run()


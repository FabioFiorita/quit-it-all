import AppKit

enum AppQuitter {
    static func runningApps() -> [NSRunningApplication] {
        let myPID = ProcessInfo.processInfo.processIdentifier

        return NSWorkspace.shared.runningApplications
            .filter { $0.activationPolicy == .regular }
            .filter { $0.bundleIdentifier != "com.apple.finder" }
            .filter { $0.processIdentifier != myPID }
            .sorted { ($0.localizedName ?? "") < ($1.localizedName ?? "") }
    }

    static func quitAll(force: Bool) {
        for app in runningApps() {
            if force {
                app.forceTerminate()
            } else {
                app.terminate()
            }
        }
    }
}

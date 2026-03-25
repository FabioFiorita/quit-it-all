import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "xmark.circle", accessibilityDescription: "Quit It All")
        }

        let menu = NSMenu()
        menu.delegate = self
        statusItem.menu = menu
    }

    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.removeAllItems()

        let quitAllItem = NSMenuItem(title: "Quit All Apps", action: #selector(quitAllApps), keyEquivalent: "q")
        quitAllItem.target = self
        menu.addItem(quitAllItem)

        let forceQuitAllItem = NSMenuItem(title: "Force Quit All Apps", action: #selector(forceQuitAllApps), keyEquivalent: "")
        forceQuitAllItem.target = self
        menu.addItem(forceQuitAllItem)

        menu.addItem(NSMenuItem.separator())

        let headerItem = NSMenuItem(title: "Running Apps:", action: nil, keyEquivalent: "")
        headerItem.isEnabled = false
        menu.addItem(headerItem)

        let runningApps = AppQuitter.runningApps()
        if runningApps.isEmpty {
            let noneItem = NSMenuItem(title: "  No apps running", action: nil, keyEquivalent: "")
            noneItem.isEnabled = false
            menu.addItem(noneItem)
        } else {
            for app in runningApps {
                let name = app.localizedName ?? "Unknown"
                let item = NSMenuItem(title: "  \(name)", action: nil, keyEquivalent: "")
                item.isEnabled = false
                if let icon = app.icon {
                    icon.size = NSSize(width: 16, height: 16)
                    item.image = icon
                }
                menu.addItem(item)
            }
        }

        menu.addItem(NSMenuItem.separator())

        let quitSelfItem = NSMenuItem(title: "Close This App", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "")
        menu.addItem(quitSelfItem)
    }

    @objc private func quitAllApps() {
        AppQuitter.quitAll(force: false)
    }

    @objc private func forceQuitAllApps() {
        AppQuitter.quitAll(force: true)
    }
}

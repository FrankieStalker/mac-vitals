import SwiftUI

import Cocoa
import ServiceManagement

@main
struct MacVitalsApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        enableLaunchAtLogin()
    }
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }

    func enableLaunchAtLogin() {
        let service = SMAppService.mainApp
        do {
            try service.register()
            print("App registered for launch at login")
        } catch {
            print("Failed to register app for launch at login: \(error)")
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create a menu bar icon
        popover = NSPopover()
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "chart.bar", accessibilityDescription: "System Stats")
            button.action = #selector(togglePopover)
        }

        // Setup popover content
        popover.contentViewController = NSHostingController(rootView: StatsView())
    }

    @MainActor @objc func togglePopover() {
        if popover.isShown {
            popover.performClose(nil)
        } else if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
}

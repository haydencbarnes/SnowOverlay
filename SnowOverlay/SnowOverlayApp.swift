import SwiftUI
import AppKit

@main
class SnowOverlayApp: NSObject, NSApplicationDelegate {
    var overlayPanel: NSPanel?
    var statusItem: NSStatusItem?
    var snowView: NSHostingView<SnowView>?
    
    static func main() {
        let app = NSApplication.shared
        let delegate = SnowOverlayApp()
        app.delegate = delegate
        app.run()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide dock icon
        NSApp.setActivationPolicy(.accessory)
        
        if let screen = NSScreen.main {
            // Create overlay panel
            overlayPanel = NSPanel(
                contentRect: NSRect(x: 0, y: 0, width: screen.frame.width, height: screen.frame.height),
                styleMask: [.nonactivatingPanel, .fullSizeContentView],
                backing: .buffered,
                defer: false
            )
            
            if let overlayPanel = overlayPanel {
                // Configure panel
                overlayPanel.isFloatingPanel = true
                overlayPanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.maximumWindow)))
                overlayPanel.backgroundColor = .clear
                overlayPanel.isOpaque = false
                overlayPanel.hasShadow = false
                overlayPanel.ignoresMouseEvents = true
                overlayPanel.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
                overlayPanel.alphaValue = 1.0
                overlayPanel.isReleasedWhenClosed = false
                overlayPanel.hidesOnDeactivate = false
                
                // Set the panel to cover the entire screen
                overlayPanel.setFrame(screen.frame, display: true)
                
                // Configure the hosting view with the modified SnowView
                let snowViewInstance = SnowView { [weak self] in
                    // This closure will be called when all snowflakes are off screen
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Small delay to ensure smooth exit
                        NSApp.terminate(nil)
                    }
                }
                
                snowView = NSHostingView(rootView: snowViewInstance)
                if let snowView = snowView {
                    snowView.frame = overlayPanel.contentView?.bounds ?? .zero
                    snowView.autoresizingMask = [.width, .height]
                    overlayPanel.contentView?.addSubview(snowView)
                }
                
                // Make sure the panel is visible and in front
                overlayPanel.orderFront(nil)
                overlayPanel.makeKey()
                
                // Keep the panel on top
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                    self?.overlayPanel?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.maximumWindow)))
                    self?.overlayPanel?.orderFront(nil)
                }
            }
        }
        
        // Create a status item to keep the app running
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem?.button?.title = "❄️"
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Clean up
        overlayPanel?.close()
        overlayPanel = nil
        statusItem = nil
    }
}

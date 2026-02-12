import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
      let macOSFrame = NSSize(width: 1400, height: 900)
      self.setContentSize(macOSFrame)
      self.center()
//      self.setFrame(macOSFrame, display: true)

    self.contentViewController = flutterViewController
    RegisterGeneratedPlugins(registry: flutterViewController)

    NSApp.activate(ignoringOtherApps: true)
    self.makeKeyAndOrderFront(nil)

    super.awakeFromNib()

      //NSApp.activate(ignoringOtherApps: true)
  }
}

import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
      let macOSFrame = NSRect(
          x: 0,
          y: 0,
          width: 1800,
          height: 900
      )
      self.setFrame(macOSFrame, display: true)
    self.contentViewController = flutterViewController
    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}

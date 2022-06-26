import Foundation

public struct MyProduct {
    public private(set) var text = NSLocalizedString("Hello, World!", bundle: .module, comment: "A welcome message for StringGenPlugin!")

    public init() {
    }
}

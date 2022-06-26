public struct IconsLibrary {
    public private(set) var text = "Hello, World!"

    public init() {
    }
}

import SwiftUI

struct ContentView: View {
    @available(iOS 13.0, *)
    var body: some View {
        Image.photoCamera
    }
}

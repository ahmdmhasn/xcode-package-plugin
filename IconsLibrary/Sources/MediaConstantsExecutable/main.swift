import Foundation

let arguments = ProcessInfo().arguments
if arguments.count < 3 {
    print("❌ Missing arguments")
}

let (input, output) = (arguments[1], arguments[2])

struct Contents: Decodable {
    let images: [ImageContent]
    
    struct ImageContent: Decodable {
        let filename: String?
    }
}


var generatedCode = """
    import Foundation
    import SwiftUI
    
    @available(iOS 13.0, *)
    extension Image {\n
    """

try FileManager.default.contentsOfDirectory(atPath: input).forEach { dirent in
    guard dirent.hasSuffix("imageset") else {
        return
    }
    
    let contentsJsonURL = URL(fileURLWithPath: "\(input)/\(dirent)/Contents.json")
    let jsonData = try Data(contentsOf: contentsJsonURL)
    let contentObject = try JSONDecoder().decode(Contents.self, from: jsonData)
    let hasImage = contentObject.images.filter { $0.filename != nil }.isEmpty == false
    
    if hasImage {
        let baseName = contentsJsonURL
            .deletingLastPathComponent()
            .deletingPathExtension()
            .lastPathComponent
        generatedCode.append("\tpublic static var \(baseName): Image { Image(\"\(baseName)\", bundle: .module) }\n")
    }
}

generatedCode.append("}")

print("MediaConstants", output)
try generatedCode.write(to: URL(fileURLWithPath: output), atomically: true, encoding: .utf8)

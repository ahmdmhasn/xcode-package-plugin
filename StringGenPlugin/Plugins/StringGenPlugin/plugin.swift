//
//  File.swift
//  
//
//  Created by Ahmed M. Hassan on 26/06/2022.
//

import Foundation
import PackagePlugin

@main
struct StringGenPlugin: BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        guard let target = target as? SourceModuleTarget else {
            return []
        }
        
        let resourcesDirectoryPath = context.pluginWorkDirectory
            .appending(subpath: target.name)
            .appending(subpath: "Resources")
        let localizationDirectoryPath = resourcesDirectoryPath
            .appending(subpath: "Base.lproj")
        
        try FileManager.default.createDirectory(atPath: localizationDirectoryPath.string,
                                                withIntermediateDirectories: true)
        
        let swiftResourceFiles = target.sourceFiles(withSuffix: ".swift")
        let inputFiles = swiftResourceFiles.map(\.path)
        
        return [
            .prebuildCommand(
                displayName: "Generating localized strings from source files",
                executable: Path("/usr/bin/xcrun"),
                arguments: [
                    "genstrings",
                    "-SwiftUI",
                    "-o",
                    localizationDirectoryPath
                ] + inputFiles,
                outputFilesDirectory: localizationDirectoryPath
            )
        ]
    }
}

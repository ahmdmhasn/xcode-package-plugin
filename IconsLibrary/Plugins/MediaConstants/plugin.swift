//
//  File.swift
//  
//
//  Created by Ahmed M. Hassan on 26/06/2022.
//

import Foundation
import PackagePlugin

@main
struct MediaConstants: BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        guard let target = target as? SourceModuleTarget else {
            return []
        }
        
        return try target.sourceFiles(withSuffix: "xcassets").map { assetCatalog in
            let base = assetCatalog.path.stem
            let input = assetCatalog.path
            let output = context.pluginWorkDirectory.appending(["\(base).swift"])
            
            return .buildCommand(displayName: "Generating media constants for \(base)",
                                 executable: try context.tool(named: "MediaConstantsExecutable").path,
                                 arguments: [input.string, output.string],
                                 inputFiles: [input],
                                 outputFiles: [output])
        }
    }
}

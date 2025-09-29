import Foundation

extension MustacheLibrary {
    /// Load templates from a folder
    static func loadTemplates(from directory: String, withExtension extension: String = "mustache") throws -> [String: MustacheTemplate] {
        var directory = directory
        if !directory.hasSuffix("/") {
            directory += "/"
        }
        let extWithDot = ".\(`extension`)"
        let fs = FileManager()
        guard let enumerator = fs.enumerator(atPath: directory) else { return [:] }
        var templates: [String: MustacheTemplate] = [:]
        for case let path as String in enumerator {
            guard path.hasSuffix(extWithDot) else { continue }
            do {
                guard let template = try MustacheTemplate(filename: directory + path) else { continue }
                // drop ".mustache" from path to get name
                let name = String(path.dropLast(extWithDot.count))
                #if os(Windows)
                templates[name.replacingOccurrences(of: "\\", with: "/")] = template
                #else
                templates[name] = template
                #endif
            } catch let error as MustacheTemplate.ParserError {
                throw ParserError(filename: path, context: error.context, error: error.error)
            }
        }
        return templates
    }
}

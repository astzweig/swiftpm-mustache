import Foundation

extension MustacheTemplate {
    /// Internal function to load a template from a file
    /// - Parameters
    ///   - string: Template text
    ///   - filename: File template was loaded from
    /// - Throws: MustacheTemplate.Error
    init?(filename: String) throws {
        let fs = FileManager()
        guard let data = fs.contents(atPath: filename) else { return nil }
        let string = String(decoding: data, as: Unicode.UTF8.self)
        let template = try Self.parse(string)
        self.tokens = template.tokens
        self.text = string
        self.filename = filename
    }
}

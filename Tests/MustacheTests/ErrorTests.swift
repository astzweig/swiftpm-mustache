import Mustache
import XCTest

final class ErrorTests: XCTestCase {
    func testSectionCloseNameIncorrect() {
        XCTAssertThrowsError(
            try MustacheTemplate(
                string: """
                    {{#test}}
                    {{.}}
                    {{/test2}}
                    """
            )
        ) { error in
            switch error {
            case let error as MustacheTemplate.ParserError:
                XCTAssertEqual(error.error as? MustacheTemplate.Error, .sectionCloseNameIncorrect)
                XCTAssertEqual(error.context.line, "{{/test2}}")
                XCTAssertEqual(error.context.lineNumber, 3)
                XCTAssertEqual(error.context.columnNumber, 4)

            default:
                XCTFail("\(error)")
            }
        }
    }

    func testUnfinishedName() {
        XCTAssertThrowsError(
            try MustacheTemplate(
                string: """
                    {{#test}}
                    {{name}
                    {{/test2}}
                    """
            )
        ) { error in
            switch error {
            case let error as MustacheTemplate.ParserError:
                XCTAssertEqual(error.error as? MustacheTemplate.Error, .unfinishedName)
                XCTAssertEqual(error.context.line, "{{name}")
                XCTAssertEqual(error.context.lineNumber, 2)
                XCTAssertEqual(error.context.columnNumber, 7)

            default:
                XCTFail("\(error)")
            }
        }
    }

    func testExpectedSectionEnd() {
        XCTAssertThrowsError(
            try MustacheTemplate(
                string: """
                    {{#test}}
                    {{.}}
                    """
            )
        ) { error in
            switch error {
            case let error as MustacheTemplate.ParserError:
                XCTAssertEqual(error.error as? MustacheTemplate.Error, .expectedSectionEnd)
                XCTAssertEqual(error.context.line, "{{.}}")
                XCTAssertEqual(error.context.lineNumber, 2)
                XCTAssertEqual(error.context.columnNumber, 6)

            default:
                XCTFail("\(error)")
            }
        }
    }

    func testInvalidSetDelimiter() {
        XCTAssertThrowsError(
            try MustacheTemplate(
                string: """
                    {{=<% %>=}}
                    <%.%>
                    <%={{}}=%>
                    """
            )
        ) { error in
            switch error {
            case let error as MustacheTemplate.ParserError:
                XCTAssertEqual(error.error as? MustacheTemplate.Error, .invalidSetDelimiter)
                XCTAssertEqual(error.context.line, "<%={{}}=%>")
                XCTAssertEqual(error.context.lineNumber, 3)
                XCTAssertEqual(error.context.columnNumber, 4)

            default:
                XCTFail("\(error)")
            }
        }
    }
}

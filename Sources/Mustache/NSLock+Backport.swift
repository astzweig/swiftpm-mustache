#if compiler(<6.0)
import Foundation

extension NSLock {
    func withLock<Value>(_ operation: () throws -> Value) rethrows -> Value {
        self.lock()
        defer {
            self.unlock()
        }
        return try operation()
    }
}
#endif

import Darwin
import Foundation
import Testing
@testable import OpenHand

@Suite struct LogLocatorTests {
    @Test func launchdGatewayLogPathEnsuresTmpDirExists() {
        let fm = FileManager()
        let baseDir = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let logDir = baseDir.appendingPathComponent("openhand-tests-\(UUID().uuidString)")

        setenv("OPENHAND_LOG_DIR", logDir.path, 1)
        defer {
            unsetenv("OPENHAND_LOG_DIR")
            try? fm.removeItem(at: logDir)
        }

        _ = LogLocator.launchdGatewayLogPath

        var isDir: ObjCBool = false
        #expect(fm.fileExists(atPath: logDir.path, isDirectory: &isDir))
        #expect(isDir.boolValue == true)
    }
}

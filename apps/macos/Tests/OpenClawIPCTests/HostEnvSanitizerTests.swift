import Testing
@testable import OpenHand

struct HostEnvSanitizerTests {
    @Test func sanitizeBlocksShellTraceVariables() {
        let env = HostEnvSanitizer.sanitize(overrides: [
            "SHELLOPTS": "xtrace",
            "PS4": "$(touch /tmp/pwned)",
            "OPENHAND_TEST": "1",
        ])
        #expect(env["SHELLOPTS"] == nil)
        #expect(env["PS4"] == nil)
        #expect(env["OPENHAND_TEST"] == "1")
    }

    @Test func sanitizeShellWrapperAllowsOnlyExplicitOverrideKeys() {
        let env = HostEnvSanitizer.sanitize(
            overrides: [
                "LANG": "C",
                "LC_ALL": "C",
                "OPENHAND_TOKEN": "secret",
                "PS4": "$(touch /tmp/pwned)",
            ],
            shellWrapper: true)

        #expect(env["LANG"] == "C")
        #expect(env["LC_ALL"] == "C")
        #expect(env["OPENHAND_TOKEN"] == nil)
        #expect(env["PS4"] == nil)
    }

    @Test func sanitizeNonShellWrapperKeepsRegularOverrides() {
        let env = HostEnvSanitizer.sanitize(overrides: ["OPENHAND_TOKEN": "secret"])
        #expect(env["OPENHAND_TOKEN"] == "secret")
    }
}

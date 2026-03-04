import Darwin
import Foundation
import Testing
@testable import OpenHand

@Suite(.serialized) struct CommandResolverTests {
    private func makeDefaults() -> UserDefaults {
        // Use a unique suite to avoid cross-suite concurrency on UserDefaults.standard.
        UserDefaults(suiteName: "CommandResolverTests.\(UUID().uuidString)")!
    }

    private func makeLocalDefaults() -> UserDefaults {
        let defaults = self.makeDefaults()
        defaults.set(AppState.ConnectionMode.local.rawValue, forKey: connectionModeKey)
        return defaults
    }

    private func makeProjectRootWithPnpm() throws -> (tmp: URL, pnpmPath: URL) {
        let tmp = try makeTempDirForTests()
        CommandResolver.setProjectRoot(tmp.path)
        let pnpmPath = tmp.appendingPathComponent("node_modules/.bin/pnpm")
        try makeExecutableForTests(at: pnpmPath)
        return (tmp, pnpmPath)
    }

    @Test func prefersOpenHandBinary() throws {
        let defaults = self.makeLocalDefaults()

        let tmp = try makeTempDirForTests()
        CommandResolver.setProjectRoot(tmp.path)

        let openhandPath = tmp.appendingPathComponent("node_modules/.bin/openhand")
        try makeExecutableForTests(at: openhandPath)

        let cmd = CommandResolver.openhandCommand(subcommand: "gateway", defaults: defaults, configRoot: [:])
        #expect(cmd.prefix(2).elementsEqual([openhandPath.path, "gateway"]))
    }

    @Test func fallsBackToNodeAndScript() throws {
        let defaults = self.makeLocalDefaults()

        let tmp = try makeTempDirForTests()
        CommandResolver.setProjectRoot(tmp.path)

        let nodePath = tmp.appendingPathComponent("node_modules/.bin/node")
        let scriptPath = tmp.appendingPathComponent("bin/openhand.js")
        try makeExecutableForTests(at: nodePath)
        try "#!/bin/sh\necho v22.0.0\n".write(to: nodePath, atomically: true, encoding: .utf8)
        try FileManager().setAttributes([.posixPermissions: 0o755], ofItemAtPath: nodePath.path)
        try makeExecutableForTests(at: scriptPath)

        let cmd = CommandResolver.openhandCommand(
            subcommand: "rpc",
            defaults: defaults,
            configRoot: [:],
            searchPaths: [tmp.appendingPathComponent("node_modules/.bin").path])

        #expect(cmd.count >= 3)
        if cmd.count >= 3 {
            #expect(cmd[0] == nodePath.path)
            #expect(cmd[1] == scriptPath.path)
            #expect(cmd[2] == "rpc")
        }
    }

    @Test func prefersOpenHandBinaryOverPnpm() throws {
        let defaults = self.makeLocalDefaults()

        let tmp = try makeTempDirForTests()
        CommandResolver.setProjectRoot(tmp.path)

        let binDir = tmp.appendingPathComponent("bin")
        let openhandPath = binDir.appendingPathComponent("openhand")
        let pnpmPath = binDir.appendingPathComponent("pnpm")
        try makeExecutableForTests(at: openhandPath)
        try makeExecutableForTests(at: pnpmPath)

        let cmd = CommandResolver.openhandCommand(
            subcommand: "rpc",
            defaults: defaults,
            configRoot: [:],
            searchPaths: [binDir.path])

        #expect(cmd.prefix(2).elementsEqual([openhandPath.path, "rpc"]))
    }

    @Test func usesOpenHandBinaryWithoutNodeRuntime() throws {
        let defaults = self.makeLocalDefaults()

        let tmp = try makeTempDirForTests()
        CommandResolver.setProjectRoot(tmp.path)

        let binDir = tmp.appendingPathComponent("bin")
        let openhandPath = binDir.appendingPathComponent("openhand")
        try makeExecutableForTests(at: openhandPath)

        let cmd = CommandResolver.openhandCommand(
            subcommand: "gateway",
            defaults: defaults,
            configRoot: [:],
            searchPaths: [binDir.path])

        #expect(cmd.prefix(2).elementsEqual([openhandPath.path, "gateway"]))
    }

    @Test func fallsBackToPnpm() throws {
        let defaults = self.makeLocalDefaults()
        let (tmp, pnpmPath) = try self.makeProjectRootWithPnpm()

        let cmd = CommandResolver.openhandCommand(
            subcommand: "rpc",
            defaults: defaults,
            configRoot: [:],
            searchPaths: [tmp.appendingPathComponent("node_modules/.bin").path])

        #expect(cmd.prefix(4).elementsEqual([pnpmPath.path, "--silent", "openhand", "rpc"]))
    }

    @Test func pnpmKeepsExtraArgsAfterSubcommand() throws {
        let defaults = self.makeLocalDefaults()
        let (tmp, pnpmPath) = try self.makeProjectRootWithPnpm()

        let cmd = CommandResolver.openhandCommand(
            subcommand: "health",
            extraArgs: ["--json", "--timeout", "5"],
            defaults: defaults,
            configRoot: [:],
            searchPaths: [tmp.appendingPathComponent("node_modules/.bin").path])

        #expect(cmd.prefix(5).elementsEqual([pnpmPath.path, "--silent", "openhand", "health", "--json"]))
        #expect(cmd.suffix(2).elementsEqual(["--timeout", "5"]))
    }

    @Test func preferredPathsStartWithProjectNodeBins() throws {
        let tmp = try makeTempDirForTests()
        CommandResolver.setProjectRoot(tmp.path)

        let first = CommandResolver.preferredPaths().first
        #expect(first == tmp.appendingPathComponent("node_modules/.bin").path)
    }

    @Test func buildsSSHCommandForRemoteMode() {
        let defaults = self.makeDefaults()
        defaults.set(AppState.ConnectionMode.remote.rawValue, forKey: connectionModeKey)
        defaults.set("openhand@example.com:2222", forKey: remoteTargetKey)
        defaults.set("/tmp/id_ed25519", forKey: remoteIdentityKey)
        defaults.set("/srv/openhand", forKey: remoteProjectRootKey)

        let cmd = CommandResolver.openhandCommand(
            subcommand: "status",
            extraArgs: ["--json"],
            defaults: defaults,
            configRoot: [:])

        #expect(cmd.first == "/usr/bin/ssh")
        if let marker = cmd.firstIndex(of: "--") {
            #expect(cmd[marker + 1] == "openhand@example.com")
        } else {
            #expect(Bool(false))
        }
        #expect(cmd.contains("-i"))
        #expect(cmd.contains("/tmp/id_ed25519"))
        if let script = cmd.last {
            #expect(script.contains("PRJ='/srv/openhand'"))
            #expect(script.contains("cd \"$PRJ\""))
            #expect(script.contains("openhand"))
            #expect(script.contains("status"))
            #expect(script.contains("--json"))
            #expect(script.contains("CLI="))
        }
    }

    @Test func rejectsUnsafeSSHTargets() {
        #expect(CommandResolver.parseSSHTarget("-oProxyCommand=calc") == nil)
        #expect(CommandResolver.parseSSHTarget("host:-oProxyCommand=calc") == nil)
        #expect(CommandResolver.parseSSHTarget("user@host:2222")?.port == 2222)
    }

    @Test func configRootLocalOverridesRemoteDefaults() throws {
        let defaults = self.makeDefaults()
        defaults.set(AppState.ConnectionMode.remote.rawValue, forKey: connectionModeKey)
        defaults.set("openhand@example.com:2222", forKey: remoteTargetKey)

        let tmp = try makeTempDirForTests()
        CommandResolver.setProjectRoot(tmp.path)

        let openhandPath = tmp.appendingPathComponent("node_modules/.bin/openhand")
        try makeExecutableForTests(at: openhandPath)

        let cmd = CommandResolver.openhandCommand(
            subcommand: "daemon",
            defaults: defaults,
            configRoot: ["gateway": ["mode": "local"]])

        #expect(cmd.first == openhandPath.path)
        #expect(cmd.count >= 2)
        if cmd.count >= 2 {
            #expect(cmd[1] == "daemon")
        }
    }
}

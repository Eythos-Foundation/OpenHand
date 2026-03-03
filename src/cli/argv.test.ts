import { describe, expect, it } from "vitest";
import {
  buildParseArgv,
  getFlagValue,
  getCommandPath,
  getCommandPositionalsWithRootOptions,
  getCommandPathWithRootOptions,
  getPrimaryCommand,
  getPositiveIntFlagValue,
  getVerboseFlag,
  hasHelpOrVersion,
  hasFlag,
  isRootHelpInvocation,
  isRootVersionInvocation,
  shouldMigrateState,
  shouldMigrateStateFromPath,
} from "./argv.js";

describe("argv helpers", () => {
  it.each([
    {
      name: "help flag",
      argv: ["node", "openhand", "--help"],
      expected: true,
    },
    {
      name: "version flag",
      argv: ["node", "openhand", "-V"],
      expected: true,
    },
    {
      name: "normal command",
      argv: ["node", "openhand", "status"],
      expected: false,
    },
    {
      name: "root -v alias",
      argv: ["node", "openhand", "-v"],
      expected: true,
    },
    {
      name: "root -v alias with profile",
      argv: ["node", "openhand", "--profile", "work", "-v"],
      expected: true,
    },
    {
      name: "root -v alias with log-level",
      argv: ["node", "openhand", "--log-level", "debug", "-v"],
      expected: true,
    },
    {
      name: "subcommand -v should not be treated as version",
      argv: ["node", "openhand", "acp", "-v"],
      expected: false,
    },
    {
      name: "root -v alias with equals profile",
      argv: ["node", "openhand", "--profile=work", "-v"],
      expected: true,
    },
    {
      name: "subcommand path after global root flags should not be treated as version",
      argv: ["node", "openhand", "--dev", "skills", "list", "-v"],
      expected: false,
    },
  ])("detects help/version flags: $name", ({ argv, expected }) => {
    expect(hasHelpOrVersion(argv)).toBe(expected);
  });

  it.each([
    {
      name: "root --version",
      argv: ["node", "openhand", "--version"],
      expected: true,
    },
    {
      name: "root -V",
      argv: ["node", "openhand", "-V"],
      expected: true,
    },
    {
      name: "root -v alias with profile",
      argv: ["node", "openhand", "--profile", "work", "-v"],
      expected: true,
    },
    {
      name: "subcommand version flag",
      argv: ["node", "openhand", "status", "--version"],
      expected: false,
    },
    {
      name: "unknown root flag with version",
      argv: ["node", "openhand", "--unknown", "--version"],
      expected: false,
    },
  ])("detects root-only version invocations: $name", ({ argv, expected }) => {
    expect(isRootVersionInvocation(argv)).toBe(expected);
  });

  it.each([
    {
      name: "root --help",
      argv: ["node", "openhand", "--help"],
      expected: true,
    },
    {
      name: "root -h",
      argv: ["node", "openhand", "-h"],
      expected: true,
    },
    {
      name: "root --help with profile",
      argv: ["node", "openhand", "--profile", "work", "--help"],
      expected: true,
    },
    {
      name: "subcommand --help",
      argv: ["node", "openhand", "status", "--help"],
      expected: false,
    },
    {
      name: "help before subcommand token",
      argv: ["node", "openhand", "--help", "status"],
      expected: false,
    },
    {
      name: "help after -- terminator",
      argv: ["node", "openhand", "nodes", "run", "--", "git", "--help"],
      expected: false,
    },
    {
      name: "unknown root flag before help",
      argv: ["node", "openhand", "--unknown", "--help"],
      expected: false,
    },
    {
      name: "unknown root flag after help",
      argv: ["node", "openhand", "--help", "--unknown"],
      expected: false,
    },
  ])("detects root-only help invocations: $name", ({ argv, expected }) => {
    expect(isRootHelpInvocation(argv)).toBe(expected);
  });

  it.each([
    {
      name: "single command with trailing flag",
      argv: ["node", "openhand", "status", "--json"],
      expected: ["status"],
    },
    {
      name: "two-part command",
      argv: ["node", "openhand", "agents", "list"],
      expected: ["agents", "list"],
    },
    {
      name: "terminator cuts parsing",
      argv: ["node", "openhand", "status", "--", "ignored"],
      expected: ["status"],
    },
  ])("extracts command path: $name", ({ argv, expected }) => {
    expect(getCommandPath(argv, 2)).toEqual(expected);
  });

  it("extracts command path while skipping known root option values", () => {
    expect(
      getCommandPathWithRootOptions(
        ["node", "openhand", "--profile", "work", "--no-color", "config", "validate"],
        2,
      ),
    ).toEqual(["config", "validate"]);
  });

  it("extracts routed config get positionals with interleaved root options", () => {
    expect(
      getCommandPositionalsWithRootOptions(
        ["node", "openhand", "config", "get", "--log-level", "debug", "update.channel", "--json"],
        {
          commandPath: ["config", "get"],
          booleanFlags: ["--json"],
        },
      ),
    ).toEqual(["update.channel"]);
  });

  it("extracts routed config unset positionals with interleaved root options", () => {
    expect(
      getCommandPositionalsWithRootOptions(
        ["node", "openhand", "config", "unset", "--profile", "work", "update.channel"],
        {
          commandPath: ["config", "unset"],
        },
      ),
    ).toEqual(["update.channel"]);
  });

  it("returns null when routed command sees unknown options", () => {
    expect(
      getCommandPositionalsWithRootOptions(
        ["node", "openhand", "config", "get", "--mystery", "value", "update.channel"],
        {
          commandPath: ["config", "get"],
          booleanFlags: ["--json"],
        },
      ),
    ).toBeNull();
  });

  it.each([
    {
      name: "returns first command token",
      argv: ["node", "openhand", "agents", "list"],
      expected: "agents",
    },
    {
      name: "returns null when no command exists",
      argv: ["node", "openhand"],
      expected: null,
    },
    {
      name: "skips known root option values",
      argv: ["node", "openhand", "--log-level", "debug", "status"],
      expected: "status",
    },
  ])("returns primary command: $name", ({ argv, expected }) => {
    expect(getPrimaryCommand(argv)).toBe(expected);
  });

  it.each([
    {
      name: "detects flag before terminator",
      argv: ["node", "openhand", "status", "--json"],
      flag: "--json",
      expected: true,
    },
    {
      name: "ignores flag after terminator",
      argv: ["node", "openhand", "--", "--json"],
      flag: "--json",
      expected: false,
    },
  ])("parses boolean flags: $name", ({ argv, flag, expected }) => {
    expect(hasFlag(argv, flag)).toBe(expected);
  });

  it.each([
    {
      name: "value in next token",
      argv: ["node", "openhand", "status", "--timeout", "5000"],
      expected: "5000",
    },
    {
      name: "value in equals form",
      argv: ["node", "openhand", "status", "--timeout=2500"],
      expected: "2500",
    },
    {
      name: "missing value",
      argv: ["node", "openhand", "status", "--timeout"],
      expected: null,
    },
    {
      name: "next token is another flag",
      argv: ["node", "openhand", "status", "--timeout", "--json"],
      expected: null,
    },
    {
      name: "flag appears after terminator",
      argv: ["node", "openhand", "--", "--timeout=99"],
      expected: undefined,
    },
  ])("extracts flag values: $name", ({ argv, expected }) => {
    expect(getFlagValue(argv, "--timeout")).toBe(expected);
  });

  it("parses verbose flags", () => {
    expect(getVerboseFlag(["node", "openhand", "status", "--verbose"])).toBe(true);
    expect(getVerboseFlag(["node", "openhand", "status", "--debug"])).toBe(false);
    expect(getVerboseFlag(["node", "openhand", "status", "--debug"], { includeDebug: true })).toBe(
      true,
    );
  });

  it.each([
    {
      name: "missing flag",
      argv: ["node", "openhand", "status"],
      expected: undefined,
    },
    {
      name: "missing value",
      argv: ["node", "openhand", "status", "--timeout"],
      expected: null,
    },
    {
      name: "valid positive integer",
      argv: ["node", "openhand", "status", "--timeout", "5000"],
      expected: 5000,
    },
    {
      name: "invalid integer",
      argv: ["node", "openhand", "status", "--timeout", "nope"],
      expected: undefined,
    },
  ])("parses positive integer flag values: $name", ({ argv, expected }) => {
    expect(getPositiveIntFlagValue(argv, "--timeout")).toBe(expected);
  });

  it("builds parse argv from raw args", () => {
    const cases = [
      {
        rawArgs: ["node", "openhand", "status"],
        expected: ["node", "openhand", "status"],
      },
      {
        rawArgs: ["node-22", "openhand", "status"],
        expected: ["node-22", "openhand", "status"],
      },
      {
        rawArgs: ["node-22.2.0.exe", "openhand", "status"],
        expected: ["node-22.2.0.exe", "openhand", "status"],
      },
      {
        rawArgs: ["node-22.2", "openhand", "status"],
        expected: ["node-22.2", "openhand", "status"],
      },
      {
        rawArgs: ["node-22.2.exe", "openhand", "status"],
        expected: ["node-22.2.exe", "openhand", "status"],
      },
      {
        rawArgs: ["/usr/bin/node-22.2.0", "openhand", "status"],
        expected: ["/usr/bin/node-22.2.0", "openhand", "status"],
      },
      {
        rawArgs: ["node24", "openhand", "status"],
        expected: ["node24", "openhand", "status"],
      },
      {
        rawArgs: ["/usr/bin/node24", "openhand", "status"],
        expected: ["/usr/bin/node24", "openhand", "status"],
      },
      {
        rawArgs: ["node24.exe", "openhand", "status"],
        expected: ["node24.exe", "openhand", "status"],
      },
      {
        rawArgs: ["nodejs", "openhand", "status"],
        expected: ["nodejs", "openhand", "status"],
      },
      {
        rawArgs: ["node-dev", "openhand", "status"],
        expected: ["node", "openhand", "node-dev", "openhand", "status"],
      },
      {
        rawArgs: ["openhand", "status"],
        expected: ["node", "openhand", "status"],
      },
      {
        rawArgs: ["bun", "src/entry.ts", "status"],
        expected: ["bun", "src/entry.ts", "status"],
      },
    ] as const;

    for (const testCase of cases) {
      const parsed = buildParseArgv({
        programName: "openhand",
        rawArgs: [...testCase.rawArgs],
      });
      expect(parsed).toEqual([...testCase.expected]);
    }
  });

  it("builds parse argv from fallback args", () => {
    const fallbackArgv = buildParseArgv({
      programName: "openhand",
      fallbackArgv: ["status"],
    });
    expect(fallbackArgv).toEqual(["node", "openhand", "status"]);
  });

  it("decides when to migrate state", () => {
    const nonMutatingArgv = [
      ["node", "openhand", "status"],
      ["node", "openhand", "health"],
      ["node", "openhand", "sessions"],
      ["node", "openhand", "config", "get", "update"],
      ["node", "openhand", "config", "unset", "update"],
      ["node", "openhand", "models", "list"],
      ["node", "openhand", "models", "status"],
      ["node", "openhand", "memory", "status"],
      ["node", "openhand", "agent", "--message", "hi"],
    ] as const;
    const mutatingArgv = [
      ["node", "openhand", "agents", "list"],
      ["node", "openhand", "message", "send"],
    ] as const;

    for (const argv of nonMutatingArgv) {
      expect(shouldMigrateState([...argv])).toBe(false);
    }
    for (const argv of mutatingArgv) {
      expect(shouldMigrateState([...argv])).toBe(true);
    }
  });

  it.each([
    { path: ["status"], expected: false },
    { path: ["config", "get"], expected: false },
    { path: ["models", "status"], expected: false },
    { path: ["agents", "list"], expected: true },
  ])("reuses command path for migrate state decisions: $path", ({ path, expected }) => {
    expect(shouldMigrateStateFromPath(path)).toBe(expected);
  });
});

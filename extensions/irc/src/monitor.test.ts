import { describe, expect, it } from "vitest";
import { resolveIrcInboundTarget } from "./monitor.js";

describe("irc monitor inbound target", () => {
  it("keeps channel target for group messages", () => {
    expect(
      resolveIrcInboundTarget({
        target: "#openhand",
        senderNick: "alice",
      }),
    ).toEqual({
      isGroup: true,
      target: "#openhand",
      rawTarget: "#openhand",
    });
  });

  it("maps DM target to sender nick and preserves raw target", () => {
    expect(
      resolveIrcInboundTarget({
        target: "openhand-bot",
        senderNick: "alice",
      }),
    ).toEqual({
      isGroup: false,
      target: "alice",
      rawTarget: "openhand-bot",
    });
  });

  it("falls back to raw target when sender nick is empty", () => {
    expect(
      resolveIrcInboundTarget({
        target: "openhand-bot",
        senderNick: " ",
      }),
    ).toEqual({
      isGroup: false,
      target: "openhand-bot",
      rawTarget: "openhand-bot",
    });
  });
});

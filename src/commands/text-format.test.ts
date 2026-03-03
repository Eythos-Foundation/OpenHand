import { describe, expect, it } from "vitest";
import { shortenText } from "./text-format.js";

describe("shortenText", () => {
  it("returns original text when it fits", () => {
    expect(shortenText("openhand", 16)).toBe("openhand");
  });

  it("truncates and appends ellipsis when over limit", () => {
    expect(shortenText("openhand-status-output", 10)).toBe("openhand-…");
  });

  it("counts multi-byte characters correctly", () => {
    expect(shortenText("hello🙂world", 7)).toBe("hello🙂…");
  });
});

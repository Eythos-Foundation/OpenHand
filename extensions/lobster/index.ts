import type {
  AnyAgentTool,
  OpenHandPluginApi,
  OpenHandPluginToolFactory,
} from "../../src/plugins/types.js";
import { createLobsterTool } from "./src/lobster-tool.js";

export default function register(api: OpenHandPluginApi) {
  api.registerTool(
    ((ctx) => {
      if (ctx.sandboxed) {
        return null;
      }
      return createLobsterTool(api) as AnyAgentTool;
    }) as OpenHandPluginToolFactory,
    { optional: true },
  );
}

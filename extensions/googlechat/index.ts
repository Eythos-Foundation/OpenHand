import type { OpenHandPluginApi } from "openhand/plugin-sdk";
import { emptyPluginConfigSchema } from "openhand/plugin-sdk";
import { googlechatDock, googlechatPlugin } from "./src/channel.js";
import { setGoogleChatRuntime } from "./src/runtime.js";

const plugin = {
  id: "googlechat",
  name: "Google Chat",
  description: "OpenHand Google Chat channel plugin",
  configSchema: emptyPluginConfigSchema(),
  register(api: OpenHandPluginApi) {
    setGoogleChatRuntime(api.runtime);
    api.registerChannel({ plugin: googlechatPlugin, dock: googlechatDock });
  },
};

export default plugin;

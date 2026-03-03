import type { OpenHandPluginApi } from "openhand/plugin-sdk";
import { emptyPluginConfigSchema } from "openhand/plugin-sdk";
import { createDiagnosticsOtelService } from "./src/service.js";

const plugin = {
  id: "diagnostics-otel",
  name: "Diagnostics OpenTelemetry",
  description: "Export diagnostics events to OpenTelemetry",
  configSchema: emptyPluginConfigSchema(),
  register(api: OpenHandPluginApi) {
    api.registerService(createDiagnosticsOtelService());
  },
};

export default plugin;

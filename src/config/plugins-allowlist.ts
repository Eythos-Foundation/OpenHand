import type { OpenHandConfig } from "./config.js";

export function ensurePluginAllowlisted(cfg: OpenHandConfig, pluginId: string): OpenHandConfig {
  const allow = cfg.plugins?.allow;
  if (!Array.isArray(allow) || allow.includes(pluginId)) {
    return cfg;
  }
  return {
    ...cfg,
    plugins: {
      ...cfg.plugins,
      allow: [...allow, pluginId],
    },
  };
}

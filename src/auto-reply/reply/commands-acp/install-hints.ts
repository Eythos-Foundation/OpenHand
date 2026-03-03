import { existsSync } from "node:fs";
import path from "node:path";
import type { OpenHandConfig } from "../../../config/config.js";

export function resolveConfiguredAcpBackendId(cfg: OpenHandConfig): string {
  return cfg.acp?.backend?.trim() || "acpx";
}

export function resolveAcpInstallCommandHint(cfg: OpenHandConfig): string {
  const configured = cfg.acp?.runtime?.installCommand?.trim();
  if (configured) {
    return configured;
  }
  const backendId = resolveConfiguredAcpBackendId(cfg).toLowerCase();
  if (backendId === "acpx") {
    const localPath = path.resolve(process.cwd(), "extensions/acpx");
    if (existsSync(localPath)) {
      return `openhand plugins install ${localPath}`;
    }
    return "openhand plugins install acpx";
  }
  return `Install and enable the plugin that provides ACP backend "${backendId}".`;
}

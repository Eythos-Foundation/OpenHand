import Foundation

// Stable identifier used for both the macOS LaunchAgent label and Nix-managed defaults suite.
// nix-openhand writes app defaults into this suite to survive app bundle identifier churn.
let launchdLabel = "ai.openhand.mac"
let gatewayLaunchdLabel = "ai.openhand.gateway"
let onboardingVersionKey = "openhand.onboardingVersion"
let onboardingSeenKey = "openhand.onboardingSeen"
let currentOnboardingVersion = 7
let pauseDefaultsKey = "openhand.pauseEnabled"
let iconAnimationsEnabledKey = "openhand.iconAnimationsEnabled"
let swabbleEnabledKey = "openhand.swabbleEnabled"
let swabbleTriggersKey = "openhand.swabbleTriggers"
let voiceWakeTriggerChimeKey = "openhand.voiceWakeTriggerChime"
let voiceWakeSendChimeKey = "openhand.voiceWakeSendChime"
let showDockIconKey = "openhand.showDockIcon"
let defaultVoiceWakeTriggers = ["openhand"]
let voiceWakeMaxWords = 32
let voiceWakeMaxWordLength = 64
let voiceWakeMicKey = "openhand.voiceWakeMicID"
let voiceWakeMicNameKey = "openhand.voiceWakeMicName"
let voiceWakeLocaleKey = "openhand.voiceWakeLocaleID"
let voiceWakeAdditionalLocalesKey = "openhand.voiceWakeAdditionalLocaleIDs"
let voicePushToTalkEnabledKey = "openhand.voicePushToTalkEnabled"
let talkEnabledKey = "openhand.talkEnabled"
let iconOverrideKey = "openhand.iconOverride"
let connectionModeKey = "openhand.connectionMode"
let remoteTargetKey = "openhand.remoteTarget"
let remoteIdentityKey = "openhand.remoteIdentity"
let remoteProjectRootKey = "openhand.remoteProjectRoot"
let remoteCliPathKey = "openhand.remoteCliPath"
let canvasEnabledKey = "openhand.canvasEnabled"
let cameraEnabledKey = "openhand.cameraEnabled"
let systemRunPolicyKey = "openhand.systemRunPolicy"
let systemRunAllowlistKey = "openhand.systemRunAllowlist"
let systemRunEnabledKey = "openhand.systemRunEnabled"
let locationModeKey = "openhand.locationMode"
let locationPreciseKey = "openhand.locationPreciseEnabled"
let peekabooBridgeEnabledKey = "openhand.peekabooBridgeEnabled"
let deepLinkKeyKey = "openhand.deepLinkKey"
let modelCatalogPathKey = "openhand.modelCatalogPath"
let modelCatalogReloadKey = "openhand.modelCatalogReload"
let cliInstallPromptedVersionKey = "openhand.cliInstallPromptedVersion"
let heartbeatsEnabledKey = "openhand.heartbeatsEnabled"
let debugPaneEnabledKey = "openhand.debugPaneEnabled"
let debugFileLogEnabledKey = "openhand.debug.fileLogEnabled"
let appLogLevelKey = "openhand.debug.appLogLevel"
let voiceWakeSupported: Bool = ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 26

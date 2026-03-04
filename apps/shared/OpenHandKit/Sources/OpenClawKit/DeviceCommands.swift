import Foundation

public enum OpenHandDeviceCommand: String, Codable, Sendable {
    case status = "device.status"
    case info = "device.info"
}

public enum OpenHandBatteryState: String, Codable, Sendable {
    case unknown
    case unplugged
    case charging
    case full
}

public enum OpenHandThermalState: String, Codable, Sendable {
    case nominal
    case fair
    case serious
    case critical
}

public enum OpenHandNetworkPathStatus: String, Codable, Sendable {
    case satisfied
    case unsatisfied
    case requiresConnection
}

public enum OpenHandNetworkInterfaceType: String, Codable, Sendable {
    case wifi
    case cellular
    case wired
    case other
}

public struct OpenHandBatteryStatusPayload: Codable, Sendable, Equatable {
    public var level: Double?
    public var state: OpenHandBatteryState
    public var lowPowerModeEnabled: Bool

    public init(level: Double?, state: OpenHandBatteryState, lowPowerModeEnabled: Bool) {
        self.level = level
        self.state = state
        self.lowPowerModeEnabled = lowPowerModeEnabled
    }
}

public struct OpenHandThermalStatusPayload: Codable, Sendable, Equatable {
    public var state: OpenHandThermalState

    public init(state: OpenHandThermalState) {
        self.state = state
    }
}

public struct OpenHandStorageStatusPayload: Codable, Sendable, Equatable {
    public var totalBytes: Int64
    public var freeBytes: Int64
    public var usedBytes: Int64

    public init(totalBytes: Int64, freeBytes: Int64, usedBytes: Int64) {
        self.totalBytes = totalBytes
        self.freeBytes = freeBytes
        self.usedBytes = usedBytes
    }
}

public struct OpenHandNetworkStatusPayload: Codable, Sendable, Equatable {
    public var status: OpenHandNetworkPathStatus
    public var isExpensive: Bool
    public var isConstrained: Bool
    public var interfaces: [OpenHandNetworkInterfaceType]

    public init(
        status: OpenHandNetworkPathStatus,
        isExpensive: Bool,
        isConstrained: Bool,
        interfaces: [OpenHandNetworkInterfaceType])
    {
        self.status = status
        self.isExpensive = isExpensive
        self.isConstrained = isConstrained
        self.interfaces = interfaces
    }
}

public struct OpenHandDeviceStatusPayload: Codable, Sendable, Equatable {
    public var battery: OpenHandBatteryStatusPayload
    public var thermal: OpenHandThermalStatusPayload
    public var storage: OpenHandStorageStatusPayload
    public var network: OpenHandNetworkStatusPayload
    public var uptimeSeconds: Double

    public init(
        battery: OpenHandBatteryStatusPayload,
        thermal: OpenHandThermalStatusPayload,
        storage: OpenHandStorageStatusPayload,
        network: OpenHandNetworkStatusPayload,
        uptimeSeconds: Double)
    {
        self.battery = battery
        self.thermal = thermal
        self.storage = storage
        self.network = network
        self.uptimeSeconds = uptimeSeconds
    }
}

public struct OpenHandDeviceInfoPayload: Codable, Sendable, Equatable {
    public var deviceName: String
    public var modelIdentifier: String
    public var systemName: String
    public var systemVersion: String
    public var appVersion: String
    public var appBuild: String
    public var locale: String

    public init(
        deviceName: String,
        modelIdentifier: String,
        systemName: String,
        systemVersion: String,
        appVersion: String,
        appBuild: String,
        locale: String)
    {
        self.deviceName = deviceName
        self.modelIdentifier = modelIdentifier
        self.systemName = systemName
        self.systemVersion = systemVersion
        self.appVersion = appVersion
        self.appBuild = appBuild
        self.locale = locale
    }
}

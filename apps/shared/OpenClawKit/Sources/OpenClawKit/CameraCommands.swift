import Foundation

public enum OpenHandCameraCommand: String, Codable, Sendable {
    case list = "camera.list"
    case snap = "camera.snap"
    case clip = "camera.clip"
}

public enum OpenHandCameraFacing: String, Codable, Sendable {
    case back
    case front
}

public enum OpenHandCameraImageFormat: String, Codable, Sendable {
    case jpg
    case jpeg
}

public enum OpenHandCameraVideoFormat: String, Codable, Sendable {
    case mp4
}

public struct OpenHandCameraSnapParams: Codable, Sendable, Equatable {
    public var facing: OpenHandCameraFacing?
    public var maxWidth: Int?
    public var quality: Double?
    public var format: OpenHandCameraImageFormat?
    public var deviceId: String?
    public var delayMs: Int?

    public init(
        facing: OpenHandCameraFacing? = nil,
        maxWidth: Int? = nil,
        quality: Double? = nil,
        format: OpenHandCameraImageFormat? = nil,
        deviceId: String? = nil,
        delayMs: Int? = nil)
    {
        self.facing = facing
        self.maxWidth = maxWidth
        self.quality = quality
        self.format = format
        self.deviceId = deviceId
        self.delayMs = delayMs
    }
}

public struct OpenHandCameraClipParams: Codable, Sendable, Equatable {
    public var facing: OpenHandCameraFacing?
    public var durationMs: Int?
    public var includeAudio: Bool?
    public var format: OpenHandCameraVideoFormat?
    public var deviceId: String?

    public init(
        facing: OpenHandCameraFacing? = nil,
        durationMs: Int? = nil,
        includeAudio: Bool? = nil,
        format: OpenHandCameraVideoFormat? = nil,
        deviceId: String? = nil)
    {
        self.facing = facing
        self.durationMs = durationMs
        self.includeAudio = includeAudio
        self.format = format
        self.deviceId = deviceId
    }
}

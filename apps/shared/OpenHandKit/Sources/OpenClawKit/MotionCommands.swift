import Foundation

public enum OpenHandMotionCommand: String, Codable, Sendable {
    case activity = "motion.activity"
    case pedometer = "motion.pedometer"
}

public typealias OpenHandMotionActivityParams = OpenHandDateRangeLimitParams

public struct OpenHandMotionActivityEntry: Codable, Sendable, Equatable {
    public var startISO: String
    public var endISO: String
    public var confidence: String
    public var isWalking: Bool
    public var isRunning: Bool
    public var isCycling: Bool
    public var isAutomotive: Bool
    public var isStationary: Bool
    public var isUnknown: Bool

    public init(
        startISO: String,
        endISO: String,
        confidence: String,
        isWalking: Bool,
        isRunning: Bool,
        isCycling: Bool,
        isAutomotive: Bool,
        isStationary: Bool,
        isUnknown: Bool)
    {
        self.startISO = startISO
        self.endISO = endISO
        self.confidence = confidence
        self.isWalking = isWalking
        self.isRunning = isRunning
        self.isCycling = isCycling
        self.isAutomotive = isAutomotive
        self.isStationary = isStationary
        self.isUnknown = isUnknown
    }
}

public struct OpenHandMotionActivityPayload: Codable, Sendable, Equatable {
    public var activities: [OpenHandMotionActivityEntry]

    public init(activities: [OpenHandMotionActivityEntry]) {
        self.activities = activities
    }
}

public struct OpenHandPedometerParams: Codable, Sendable, Equatable {
    public var startISO: String?
    public var endISO: String?

    public init(startISO: String? = nil, endISO: String? = nil) {
        self.startISO = startISO
        self.endISO = endISO
    }
}

public struct OpenHandPedometerPayload: Codable, Sendable, Equatable {
    public var startISO: String
    public var endISO: String
    public var steps: Int?
    public var distanceMeters: Double?
    public var floorsAscended: Int?
    public var floorsDescended: Int?

    public init(
        startISO: String,
        endISO: String,
        steps: Int?,
        distanceMeters: Double?,
        floorsAscended: Int?,
        floorsDescended: Int?)
    {
        self.startISO = startISO
        self.endISO = endISO
        self.steps = steps
        self.distanceMeters = distanceMeters
        self.floorsAscended = floorsAscended
        self.floorsDescended = floorsDescended
    }
}

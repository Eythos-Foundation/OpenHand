import CoreLocation
import Foundation
import OpenHandKit
import UIKit

typealias OpenHandCameraSnapResult = (format: String, base64: String, width: Int, height: Int)
typealias OpenHandCameraClipResult = (format: String, base64: String, durationMs: Int, hasAudio: Bool)

protocol CameraServicing: Sendable {
    func listDevices() async -> [CameraController.CameraDeviceInfo]
    func snap(params: OpenHandCameraSnapParams) async throws -> OpenHandCameraSnapResult
    func clip(params: OpenHandCameraClipParams) async throws -> OpenHandCameraClipResult
}

protocol ScreenRecordingServicing: Sendable {
    func record(
        screenIndex: Int?,
        durationMs: Int?,
        fps: Double?,
        includeAudio: Bool?,
        outPath: String?) async throws -> String
}

@MainActor
protocol LocationServicing: Sendable {
    func authorizationStatus() -> CLAuthorizationStatus
    func accuracyAuthorization() -> CLAccuracyAuthorization
    func ensureAuthorization(mode: OpenHandLocationMode) async -> CLAuthorizationStatus
    func currentLocation(
        params: OpenHandLocationGetParams,
        desiredAccuracy: OpenHandLocationAccuracy,
        maxAgeMs: Int?,
        timeoutMs: Int?) async throws -> CLLocation
    func startLocationUpdates(
        desiredAccuracy: OpenHandLocationAccuracy,
        significantChangesOnly: Bool) -> AsyncStream<CLLocation>
    func stopLocationUpdates()
    func startMonitoringSignificantLocationChanges(onUpdate: @escaping @Sendable (CLLocation) -> Void)
    func stopMonitoringSignificantLocationChanges()
}

@MainActor
protocol DeviceStatusServicing: Sendable {
    func status() async throws -> OpenHandDeviceStatusPayload
    func info() -> OpenHandDeviceInfoPayload
}

protocol PhotosServicing: Sendable {
    func latest(params: OpenHandPhotosLatestParams) async throws -> OpenHandPhotosLatestPayload
}

protocol ContactsServicing: Sendable {
    func search(params: OpenHandContactsSearchParams) async throws -> OpenHandContactsSearchPayload
    func add(params: OpenHandContactsAddParams) async throws -> OpenHandContactsAddPayload
}

protocol CalendarServicing: Sendable {
    func events(params: OpenHandCalendarEventsParams) async throws -> OpenHandCalendarEventsPayload
    func add(params: OpenHandCalendarAddParams) async throws -> OpenHandCalendarAddPayload
}

protocol RemindersServicing: Sendable {
    func list(params: OpenHandRemindersListParams) async throws -> OpenHandRemindersListPayload
    func add(params: OpenHandRemindersAddParams) async throws -> OpenHandRemindersAddPayload
}

protocol MotionServicing: Sendable {
    func activities(params: OpenHandMotionActivityParams) async throws -> OpenHandMotionActivityPayload
    func pedometer(params: OpenHandPedometerParams) async throws -> OpenHandPedometerPayload
}

struct WatchMessagingStatus: Sendable, Equatable {
    var supported: Bool
    var paired: Bool
    var appInstalled: Bool
    var reachable: Bool
    var activationState: String
}

struct WatchQuickReplyEvent: Sendable, Equatable {
    var replyId: String
    var promptId: String
    var actionId: String
    var actionLabel: String?
    var sessionKey: String?
    var note: String?
    var sentAtMs: Int?
    var transport: String
}

struct WatchNotificationSendResult: Sendable, Equatable {
    var deliveredImmediately: Bool
    var queuedForDelivery: Bool
    var transport: String
}

protocol WatchMessagingServicing: AnyObject, Sendable {
    func status() async -> WatchMessagingStatus
    func setReplyHandler(_ handler: (@Sendable (WatchQuickReplyEvent) -> Void)?)
    func sendNotification(
        id: String,
        params: OpenHandWatchNotifyParams) async throws -> WatchNotificationSendResult
}

extension CameraController: CameraServicing {}
extension ScreenRecordService: ScreenRecordingServicing {}
extension LocationService: LocationServicing {}

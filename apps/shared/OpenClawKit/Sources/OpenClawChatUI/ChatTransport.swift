import Foundation

public enum OpenHandChatTransportEvent: Sendable {
    case health(ok: Bool)
    case tick
    case chat(OpenHandChatEventPayload)
    case agent(OpenHandAgentEventPayload)
    case seqGap
}

public protocol OpenHandChatTransport: Sendable {
    func requestHistory(sessionKey: String) async throws -> OpenHandChatHistoryPayload
    func sendMessage(
        sessionKey: String,
        message: String,
        thinking: String,
        idempotencyKey: String,
        attachments: [OpenHandChatAttachmentPayload]) async throws -> OpenHandChatSendResponse

    func abortRun(sessionKey: String, runId: String) async throws
    func listSessions(limit: Int?) async throws -> OpenHandChatSessionsListResponse

    func requestHealth(timeoutMs: Int) async throws -> Bool
    func events() -> AsyncStream<OpenHandChatTransportEvent>

    func setActiveSessionKey(_ sessionKey: String) async throws
}

extension OpenHandChatTransport {
    public func setActiveSessionKey(_: String) async throws {}

    public func abortRun(sessionKey _: String, runId _: String) async throws {
        throw NSError(
            domain: "OpenHandChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "chat.abort not supported by this transport"])
    }

    public func listSessions(limit _: Int?) async throws -> OpenHandChatSessionsListResponse {
        throw NSError(
            domain: "OpenHandChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "sessions.list not supported by this transport"])
    }
}

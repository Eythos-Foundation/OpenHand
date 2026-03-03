import Foundation

public enum OpenHandRemindersCommand: String, Codable, Sendable {
    case list = "reminders.list"
    case add = "reminders.add"
}

public enum OpenHandReminderStatusFilter: String, Codable, Sendable {
    case incomplete
    case completed
    case all
}

public struct OpenHandRemindersListParams: Codable, Sendable, Equatable {
    public var status: OpenHandReminderStatusFilter?
    public var limit: Int?

    public init(status: OpenHandReminderStatusFilter? = nil, limit: Int? = nil) {
        self.status = status
        self.limit = limit
    }
}

public struct OpenHandRemindersAddParams: Codable, Sendable, Equatable {
    public var title: String
    public var dueISO: String?
    public var notes: String?
    public var listId: String?
    public var listName: String?

    public init(
        title: String,
        dueISO: String? = nil,
        notes: String? = nil,
        listId: String? = nil,
        listName: String? = nil)
    {
        self.title = title
        self.dueISO = dueISO
        self.notes = notes
        self.listId = listId
        self.listName = listName
    }
}

public struct OpenHandReminderPayload: Codable, Sendable, Equatable {
    public var identifier: String
    public var title: String
    public var dueISO: String?
    public var completed: Bool
    public var listName: String?

    public init(
        identifier: String,
        title: String,
        dueISO: String? = nil,
        completed: Bool,
        listName: String? = nil)
    {
        self.identifier = identifier
        self.title = title
        self.dueISO = dueISO
        self.completed = completed
        self.listName = listName
    }
}

public struct OpenHandRemindersListPayload: Codable, Sendable, Equatable {
    public var reminders: [OpenHandReminderPayload]

    public init(reminders: [OpenHandReminderPayload]) {
        self.reminders = reminders
    }
}

public struct OpenHandRemindersAddPayload: Codable, Sendable, Equatable {
    public var reminder: OpenHandReminderPayload

    public init(reminder: OpenHandReminderPayload) {
        self.reminder = reminder
    }
}

import Foundation

struct TaskItem: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var notes: String?
    var isCompleted: Bool
    var dueDate: Date?
    var createdAt: Date
    var updatedAt: Date

    init(id: UUID = UUID(), title: String, notes: String? = nil, isCompleted: Bool = false, dueDate: Date? = nil, createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    static func sample() -> [TaskItem] {
        [
            TaskItem(title: "Buy groceries", notes: "Milk, eggs, bread"),
            TaskItem(title: "Finish report", dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())),
            TaskItem(title: "Call Alice", isCompleted: true)
        ]
    }
}

import Foundation

protocol TaskPersistence {
    func load() throws -> [TaskItem]
    func save(_ tasks: [TaskItem]) throws
}

struct FileTaskPersistence: TaskPersistence {
    private let fileURL: URL

    init(filename: String = "tasks.json") {
        let fm = FileManager.default
        if let appSupport = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let dir = appSupport.appendingPathComponent("TasksApp", isDirectory: true)
            try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
            self.fileURL = dir.appendingPathComponent(filename)
        } else {
            self.fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        }
    }

    func load() throws -> [TaskItem] {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([TaskItem].self, from: data)
    }

    func save(_ tasks: [TaskItem]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(tasks)
        try data.write(to: fileURL, options: [.atomic])
    }
}

import Foundation
import Combine

final class TaskStore: ObservableObject {
    @Published private(set) var tasks: [TaskItem] = []

    private let persistence: TaskPersistence

    init(persistence: TaskPersistence = FileTaskPersistence()) {
        self.persistence = persistence
        load()
    }

    func add(title: String, notes: String?, dueDate: Date?) {
        var newTask = TaskItem(title: title, notes: notes, dueDate: dueDate)
        newTask.updatedAt = Date()
        tasks.append(newTask)
        save()
    }

    func update(_ task: TaskItem, title: String, notes: String?, dueDate: Date?) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks[index].title = title
        tasks[index].notes = notes
        tasks[index].dueDate = dueDate
        tasks[index].updatedAt = Date()
        save()
    }

    func toggleComplete(_ task: TaskItem) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks[index].isCompleted.toggle()
        tasks[index].updatedAt = Date()
        save()
    }

    func delete(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        save()
    }

    func move(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
        save()
    }

    func load() {
        do {
            tasks = try persistence.load()
        } catch {
            tasks = []
        }
    }

    func save() {
        do {
            try persistence.save(tasks)
        } catch {
            // In a real app, handle errors appropriately
            print("Failed to save tasks: \(error)")
        }
    }
}

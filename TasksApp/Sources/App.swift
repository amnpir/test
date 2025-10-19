import SwiftUI

@main
struct TasksAppApp: App {
    @StateObject private var store = TaskStore()

    var body: some Scene {
        WindowGroup {
            TaskListView()
                .environmentObject(store)
        }
    }
}

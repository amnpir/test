import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var store: TaskStore
    @State private var showAdd: Bool = false
    @State private var showCompleted: Bool = true
    @State private var searchText: String = ""

    var filteredTasks: [TaskItem] {
        store.tasks.filter { task in
            let matchesSearch = searchText.isEmpty || task.title.localizedCaseInsensitiveContains(searchText) || (task.notes?.localizedCaseInsensitiveContains(searchText) ?? false)
            let matchesCompletion = showCompleted || !task.isCompleted
            return matchesSearch && matchesCompletion
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredTasks) { task in
                    TaskRow(task: task) {
                        store.toggleComplete(task)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            if let index = store.tasks.firstIndex(of: task) {
                                store.delete(at: IndexSet(integer: index))
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .onMove(perform: store.move)
            }
            .navigationTitle("Tasks")
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAdd = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Toggle(isOn: $showCompleted) {
                        Text("Show Completed")
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddEditTaskView { title, notes, dueDate in
                    store.add(title: title, notes: notes, dueDate: dueDate)
                }
            }
        }
    }
}

#Preview {
    TaskListView()
        .environmentObject(TaskStore())
}

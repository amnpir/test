import SwiftUI

struct AddEditTaskView: View {
    @Environment(\.dismiss) private var dismiss

    let taskToEdit: TaskItem?
    var onSave: (String, String?, Date?) -> Void

    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var hasDueDate: Bool = false
    @State private var dueDate: Date = Date()

    init(taskToEdit: TaskItem? = nil, onSave: @escaping (String, String?, Date?) -> Void) {
        self.taskToEdit = taskToEdit
        self.onSave = onSave
        _title = State(initialValue: taskToEdit?.title ?? "")
        _notes = State(initialValue: taskToEdit?.notes ?? "")
        if let d = taskToEdit?.dueDate {
            _hasDueDate = State(initialValue: true)
            _dueDate = State(initialValue: d)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Details")) {
                    TextField("Title", text: $title)
                        .textInputAutocapitalization(.sentences)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
                Section(header: Text("Due")) {
                    Toggle("Has due date", isOn: $hasDueDate.animation())
                    if hasDueDate {
                        DatePicker("Due date", selection: $dueDate, displayedComponents: [.date])
                    }
                }
            }
            .navigationTitle(taskToEdit == nil ? "Add Task" : "Edit Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                        onSave(title, notes.isEmpty ? nil : notes, hasDueDate ? dueDate : nil)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddEditTaskView(taskToEdit: nil, onSave: { _,_,_ in })
}

//
//  ContentView.swift
//  TodoListApp
//
//  Created by Dineth Dissanayake on 2023-03-20.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \TaskItem.dueDate, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<TaskItem>
    
    var body: some View {
        NavigationView {
            VStack {
                DateScroller()
                    .padding()
                    .environmentObject(dateHolder)
                ZStack {
                    List {
                        ForEach(dateHolder.taskItems) {
                            taskItem in
                            NavigationLink(destination: TaskEditView(passedTaskItem: taskItem, initialDate: Date()) .environmentObject(dateHolder)) {
                                TaskCell(passedTaskItem: taskItem)
                                    .environmentObject(dateHolder)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                        }
                    }
                    FloatingButton()
                        .environmentObject(dateHolder)
                }
            }.navigationTitle("To Do App")
        }
    }
        
    
    private func deleteItems(offsets: IndexSet) {
            withAnimation {
                offsets.map { dateHolder.taskItems[$0] }.forEach(viewContext.delete)
                
                dateHolder.saveContext(viewContext)
            }
        }
    
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            TaskListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}

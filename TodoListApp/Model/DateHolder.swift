//
//  DateHolder.swift
//  TodoListApp
//
//  Created by Dineth Dissanayake on 2023-03-20.
//

import SwiftUI
import CoreData

class DateHolder: ObservableObject {
    
    @Published var date = Date()
    @Published var taskItems: [TaskItem] = []
    
    let calender: Calendar = Calendar.current
    
    
    func moveData(_ days: Int, _ context: NSManagedObjectContext) {
        date = calender.date(byAdding: .day, value: days, to: date)!
        refreshTaskItems(context)
    }
    
    func refreshTaskItems(_ context: NSManagedObjectContext) {
        taskItems = fetchTaskItems(context)
    }
    
    init(_ context: NSManagedObjectContext) {
        refreshTaskItems(context)
    }
    
    func fetchTaskItems(_ context: NSManagedObjectContext) -> [TaskItem] {
        do {
            return try context.fetch(dailyTasksFetch()) as [TaskItem]
        }
        catch let error {
            fatalError("Unresolved error \(error)")
        }
    }
    
    private func sortOrder() -> [NSSortDescriptor] {
        let completedDataSort = NSSortDescriptor(keyPath: \TaskItem.completedDate, ascending: true)
        let timeSort = NSSortDescriptor(keyPath: \TaskItem.scheduleTime, ascending: true)
        let dueDateSort = NSSortDescriptor(keyPath: \TaskItem.dueDate, ascending: true)
        
        return [completedDataSort, timeSort, dueDateSort]
    }
    
    func dailyTasksFetch() -> NSFetchRequest<TaskItem> {
        let request = TaskItem.fetchRequest()
        
        request.sortDescriptors = sortOrder()
        request.predicate = predicate()
        return request
    }
    
    private func predicate() -> NSPredicate {
        let start = calender.startOfDay(for: date)
        let end = calender.date(byAdding: .day, value: 1, to: start)
        return NSPredicate(format: "dueDate >= %@ AND dueDate < %@", start as NSDate, end! as NSDate)
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            refreshTaskItems(context)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

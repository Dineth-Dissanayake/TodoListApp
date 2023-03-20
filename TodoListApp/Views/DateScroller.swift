//
//  DateScroller.swift
//  TodoListApp
//
//  Created by Dineth Dissanayake on 2023-03-20.
//

import SwiftUI

struct DateScroller: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: moveBack) {
                Image(systemName: "arrow.left")
                    .imageScale(.large)
                    .font(Font.title.weight(.bold))
            }
            Text(dateFormatted())
                .font(.title)
                .bold()
                .animation(.none)
                .frame(maxWidth: .infinity)
            Button(action: moveForward) {
                Image(systemName: "arrow.right")
                    .imageScale(.large)
                    .font(Font.title.weight(.bold))
            }
        }
    }
    
    func dateFormatted() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd LLL yy"
        return dateFormatter.string(from: dateHolder.date)
    }
    
    func moveBack() {
        withAnimation {
            dateHolder.moveData(-1, viewContext)
        }
    }
    
    func moveForward() {
        withAnimation {
            dateHolder.moveData(1, viewContext)
        }
    }
}

struct DateScroller_Previews: PreviewProvider {
    static var previews: some View {
        DateScroller()
    }
}

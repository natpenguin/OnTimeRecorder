//
//  ContentView.swift
//  OnTimeRecorder
//
//  Created by Yuji Taniguchi on 2022/01/04.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Sleep.timestamp, ascending: true)],
        animation: .default)
    private var sleepItems: FetchedResults<Sleep>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Wake.timestamp, ascending: true)],
        animation: .default)
    private var wakeItems: FetchedResults<Wake>

    var body: some View {
        HStack {
            wakeItemsBody
            sleepItemsBody
        }
        .padding(.vertical)
    }
    
    var sleepItemsBody: some View {
        VStack {
            Text("Slept At")
                .font(.title2)
                .bold()
            List {
                ForEach(sleepItems) { item in
                    Text(item.timestamp!, formatter: itemFormatter)
                }
            }
        }
    }
    
    var wakeItemsBody: some View {
        VStack {
            Text("Waked At")
                .font(.title2)
                .bold()
            List {
                ForEach(wakeItems) { item in
                    Text(item.timestamp!, formatter: itemFormatter)
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Wake(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { wakeItems[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
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
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

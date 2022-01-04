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
        sortDescriptors: [NSSortDescriptor(keyPath: \Record.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Record>

    var body: some View {
        itemsBody
            .padding(.vertical)
    }

    var itemsBody: some View {
        List {
            ForEach(items) { item in
                HStack(spacing: 20) {
                    if let wakedAt = item.wakedAt?.timestamp {
                        Text(wakedAt, formatter: itemFormatter)
                    }
                    if let sleptAt = item.sleptAt?.timestamp {
                        Text(sleptAt, formatter: itemFormatter)
                    }
                    if let duration = item.duration {
                        Text("\(duration) seconds")
                    }
                }
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

private extension Record {
    var duration: TimeInterval? {
        guard let wakedTimestamp = wakedAt?.timestamp?.timeIntervalSince1970, let sleptTimestamp = sleptAt?.timestamp?.timeIntervalSince1970 else { return nil }
        return sleptTimestamp - wakedTimestamp
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

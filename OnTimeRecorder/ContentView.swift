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
        VStack(spacing: 40) {
            HStack(spacing: 40) {
                lastMonthHoursBody
                Divider()
                thisMonthHoursBody
            }
            recordsBody
        }
            .padding()
    }

    var lastMonthHoursBody: some View {
        VStack(spacing: 16) {
            Text("Hours of last month")
                .font(.title)
                .bold()
            let rangeOfLastMonth = Calendar(identifier: .gregorian).rangeOfLastMonth
            let reducedSeconds = items.reduce(TimeInterval(0)) { partialResult, record in
                if let wakedAt = record.wakedAt?.timestamp, rangeOfLastMonth.contains(wakedAt) {
                    return partialResult + (record.duration ?? 0)
                } else {
                    return partialResult
                }
            }
            Text(String(format: "%.2f hours", TimeInterval.convertToHours(fromSeconds: reducedSeconds)))
                .font(.title2)
                .bold()
        }
    }

    var thisMonthHoursBody: some View {
        VStack(spacing: 16) {
            Text("Hours of this month")
                .font(.title)
                .bold()
            let rangeOfThisMonth = Calendar(identifier: .gregorian).rangeOfThisMonth
            let reducedSeconds = items.reduce(TimeInterval(0)) { partialResult, record in
                if let wakedAt = record.wakedAt?.timestamp, rangeOfThisMonth.contains(wakedAt) {
                    return partialResult + (record.duration ?? 0)
                } else {
                    return partialResult
                }
            }
            Text(String(format: "%.2f hours", TimeInterval.convertToHours(fromSeconds: reducedSeconds)))
                .font(.title2)
                .bold()
        }
    }

    var recordsBody: some View {
        VStack(spacing: 16) {
            Text("Records")
                .font(.title)
                .bold()
            List(items) { item in
                HStack(spacing: 20) {
                    if let wakedAt = item.wakedAt?.timestamp {
                        Text(wakedAt, formatter: itemFormatter)
                    }
                    if let sleptAt = item.sleptAt?.timestamp {
                        Text(sleptAt, formatter: itemFormatter)
                    }
                    Spacer()
                    if let duration = item.duration {
                        Text(String(format: "%.1f hours", TimeInterval.convertToHours(fromSeconds: duration)))
                            .bold()
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

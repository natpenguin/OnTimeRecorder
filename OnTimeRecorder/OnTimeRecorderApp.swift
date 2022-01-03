//
//  OnTimeRecorderApp.swift
//  OnTimeRecorder
//
//  Created by Yuji Taniguchi on 2022/01/04.
//

import SwiftUI
import Combine

@main
struct OnTimeRecorderApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    private var cancellables: [AnyCancellable] = []
    
    private var targetRecord: Record?
    private let persistenceController = PersistenceController.shared
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let notificationCenter = NSWorkspace.shared.notificationCenter
        notificationCenter.publisher(for: NSWorkspace.willSleepNotification)
            .sink { [weak self] _ in
                self?.recordSleepingToPersistenceStore()
            }
            .store(in: &cancellables)
        notificationCenter.publisher(for: NSWorkspace.willPowerOffNotification)
            .sink { [weak self] _ in
                self?.recordSleepingToPersistenceStore()
            }
            .store(in: &cancellables)
        notificationCenter.publisher(for: NSWorkspace.didWakeNotification)
            .sink { [weak self] _ in
                self?.recordWakingToPersistenceStore()
            }
            .store(in: &cancellables)
        recordWakingToPersistenceStore()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        recordSleepingToPersistenceStore()
    }

    private func recordSleepingToPersistenceStore() {
        guard targetRecord != nil else {
            return
        }
        let viewContext = persistenceController.container.viewContext
        let newSleepItem = Sleep(context: viewContext)
        newSleepItem.timestamp = Date()
        targetRecord?.sleptAt = newSleepItem
        do {
            try viewContext.save()
            targetRecord = nil
        } catch {
            fatalError("Failed to record device sleeping time")
        }
    }
    
    private func recordWakingToPersistenceStore() {
        if let _ = targetRecord {
            recordSleepingToPersistenceStore()
        }
        let viewContext = persistenceController.container.viewContext
        let record = Record(context: viewContext)
        record.timestamp = Date()
        targetRecord = record
    }
}

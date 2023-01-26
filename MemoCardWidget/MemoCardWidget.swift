//
//  MemoCardWidget.swift
//  MemoCardWidget
//
//  Created by Sean Hong on 2023/01/19.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {
    let date = Date()
    
    func placeholder(in context: Context) -> MemoCardEntry {
        MemoCardEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (MemoCardEntry) -> ()) {
        let entry = MemoCardEntry(date: Date())
        completion(entry)
    }
    
    // After requesting the initial snapshot, WidgetKit calls getTimeline to request a regular timeline from the provider.
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [MemoCardEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = MemoCardEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct MemoCardEntry: TimelineEntry {
    let date: Date
    let card: Card = CardMock().card
}

struct MemoCardWidgetEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemMedium:
            VStack {
                Text(entry.date, style: .time)
                Text(entry.card.name)
                Text(entry.card.email)
                Text(entry.card.company)
                Text(entry.card.phone)
                Image(systemName: "person")
            }
        case .systemLarge:
            VStack {
                Text(entry.date, style: .time)
                Text(entry.card.name)
                Text(entry.card.email)
                Text(entry.card.company)
                Text(entry.card.phone)
                Image(systemName: "person")
            }
        default:
            VStack {
                Text(entry.date, style: .time)
                Text(entry.card.name)
                Text(entry.card.email)
                Text(entry.card.company)
                Text(entry.card.phone)
                Image(systemName: "person")
            }
        }
    }
}

struct MemoCardWidget: Widget {
    let kind: String = "MemoCardWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MemoCardWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("MemoCard")
        .description("This is a widget used for MemoCard.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct MemoCardWidget_Previews: PreviewProvider {
    static var previews: some View {
        MemoCardWidgetEntryView(entry: MemoCardEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

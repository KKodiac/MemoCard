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
        let entry = MemoCardEntry(
            date: Date(),
            cards: [SnapCard.mock()]
        )
        
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [MemoCardEntry] = []
        let currentDate = Date()
        let allCards = CoreDataService.shared.fetchCards()
        let cards = allCards.prefix(upTo: allCards.count < 4 ? allCards.count : 4).map { $0 }
        let entry = MemoCardEntry(date: currentDate, cards: cards)
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct MemoCardEntry: TimelineEntry {
    let date: Date
    let cards: [SnapCard]
    init(date: Date, cards: [SnapCard] = [SnapCard.mock()]) {
        self.date = date
        self.cards = cards
    }
}

struct MemoCardWidgetEntryView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemMedium:
            mediumCardView
        default:
            Text(entry.cards.first!.name)
        }
    }
    
    @ViewBuilder
    var mediumCardView: some View {
        ZStack {
            HStack {
                ForEach(0..<entry.cards.count) { index in
                    Link(destination: URL(string: "\(index)")!) {
                        Circle()
                            .fill(.cyan.shadow(.inner(color: .sapphire, radius: 5)))
                            .opacity(0.6)
                            .shadow(radius: 50, x: 5, y: 5)
                            .overlay {
                                Text(entry.cards[index].name).foregroundColor(.white).bold()
                            }
                    }
                }
            }
        }
        .padding()
    }
}

struct MemoCardWidget: Widget {
    let kind: String = "MemoCardWidget"
    

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MemoCardWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("WidgetBackground"))
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

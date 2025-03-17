//
//  KabinettWidget.swift
//  KabinettWidget
//
//  Created by JIHYE SEOK on 1/15/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }
    
    // 위젯 표기 시 미리보기로 보이는 화면
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }
    // 정의한 타임라인에 맞게 업데이트해서 보여질 내용
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct KabinettWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            ForEach(Array(WidgetLetterStub.sampleLetters3.reversed().enumerated()), id: \.element.id) { index, letter in
                let (xOffset, yOffset, rotation) = LayoutHelper.calculateWidgetOffsetAndRotation(for: index, totalCount: WidgetLetterStub.sampleLetters3.count)
                
                WidgetEnvelopeView()
                    .offset(x: xOffset, y: yOffset)
                    .rotationEffect(.degrees(rotation))
                    .zIndex(Double(-index))
            }
            RedSticker()
        }
    }
}

struct KabinettWidget: Widget {
    let kind: String = "KabinettWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                KabinettWidgetEntryView(entry: entry)
                    .containerBackground(Color.widgetBackground, for: .widget)
            } else {
                KabinettWidgetEntryView(entry: entry)
                    .padding()
                    .background(Color.widgetBackground)
            }
        }
        .configurationDisplayName("편지 확인")
        .description("새로 온 편지를 확인할 수 있어요.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    KabinettWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}

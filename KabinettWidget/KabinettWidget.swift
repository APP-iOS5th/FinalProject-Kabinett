//
//  KabinettWidget.swift
//  KabinettWidget
//
//  Created by JIHYE SEOK on 1/15/25.
//

import WidgetKit
import SwiftUI

struct WidgetLetterProvider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetLetterEntry {
        WidgetLetterEntry(date: Date(), letters: [])
    }
    
    // 위젯 표기 시 미리보기로 보이는 화면
    func getSnapshot(in context: Context, completion: @escaping (WidgetLetterEntry) -> ()) {
        let letters = WidgetLetterStorage.shared.loadWidgetLetters()
        let entry = WidgetLetterEntry(date: Date(), letters: letters)
        completion(entry)
    }
    // 정의한 타임라인에 맞게 업데이트해서 보여질 내용
    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetLetterEntry>) -> ()) {
        let letters = WidgetLetterStorage.shared.loadWidgetLetters()
        let entry = WidgetLetterEntry(date: Date(), letters: letters)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct WidgetLetterEntry: TimelineEntry {
    let date: Date
    let letters: [WidgetLetter]
}

struct KabinettWidgetEntryView : View {
    var entry: WidgetLetterProvider.Entry

    var body: some View {
        ZStack {
            ForEach(Array(entry.letters.reversed().enumerated()), id: \.element.id) { index, letter in
                let (xOffset, yOffset, rotation) = LayoutHelper.calculateWidgetOffsetAndRotation(for: index, totalCount: entry.letters.count)
                
                if let letter = entry.letters.first {
                    WidgetEnvelopeView(letter: letter)
                        .offset(x: xOffset, y: yOffset)
                        .rotationEffect(.degrees(rotation))
                        .zIndex(Double(-index))
                }
            }
            RedSticker()
        }
//        VStack(alignment: .leading) {
//                    ForEach(entry.letters.prefix(3), id: \.id) { letter in
//                        Text("\(letter.fromUserName): \(letter.postScript)")
//                            .font(.caption)
//                    }
//                }
//                .padding()
    }
}

struct KabinettWidget: Widget {
    let kind: String = "KabinettWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WidgetLetterProvider()) { entry in
            if #available(iOS 17.0, *) {
                KabinettWidgetEntryView(entry: entry)
                    .containerBackground(Color.widgetBackground, for: .widget)
            }
            else {
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

//#Preview(as: .systemMedium) {
//    KabinettWidget()
//} timeline: {
//    WidgetLetterEntry(date: .now, emoji: "😀")
//    WidgetLetterEntry(date: .now, emoji: "🤩")
//}

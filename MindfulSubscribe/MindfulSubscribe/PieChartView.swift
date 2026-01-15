//
//  PieChartView.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 20/11/2568 BE.
//

import SwiftUI
import Charts

struct PieChartView: View {
    let subscriptions: [Subscription]
    
    var data: [(category: String, amount: Double)] {
        let grouped = Dictionary(grouping: subscriptions) { $0.category }
        return grouped.map { key, value in
            (category: key.rawValue, amount: value.reduce(0) { $0 + $1.cost })
        }
    }
    
    var total: Double {
        data.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        Chart(data, id: \.category) { item in
            SectorMark(
                angle: .value("Amount", item.amount),
                innerRadius: .ratio(0.5),
                angularInset: 1.5
            )
            .foregroundStyle(by: .value("Category", item.category))
        }
        .chartLegend(.hidden) // Hide legend to save space on card
    }
}

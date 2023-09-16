import SwiftUI
import Charts

struct ChartsView: View {
    var barChart: some View {
        Chart {
            ForEach(data) {
                BarMark(x: .value("Day", $0.day), y: .value("Value", $0.value))
            }
        }
    }
    
    var lineChart: some View {
        Chart {
            ForEach(data) { item in
                LineMark(x: .value("Day", item.day), y: .value("Value", item.value),
                         series: .value("Year", "2022"))
                .interpolationMethod(.catmullRom)
                .foregroundStyle(by: .value("Year", "2022"))
                .symbol(by: .value("Year", "2022"))
            }
            ForEach(data2) { item in
                LineMark(x: .value("Day", item.day), y: .value("Value", item.value),
                         series: .value("Year", "2021"))
                .interpolationMethod(.catmullRom)
                .foregroundStyle(by: .value("Year", "2021"))
                .symbol(by: .value("Year", "2021"))
            }
        }
    }

    var body: some View {
        lineChart
            .foregroundStyle(.linearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .padding(20)
    }
}

#Preview {
    ChartsView()
}

struct ChartValue: Identifiable {
    var id = UUID()
    var day: String
    var value: Double
}

let data = [
    ChartValue(day: "May 1", value: 200),
    ChartValue(day: "Jun 2", value: 96),
    ChartValue(day: "Jul 3", value: 312),
    ChartValue(day: "Aug 4", value: 256),
    ChartValue(day: "Sep 5", value: 505),
]

let data2 = [
    ChartValue(day: "May 1", value: 151),
    ChartValue(day: "Jun 2", value: 192),
    ChartValue(day: "Jul 3", value: 176),
    ChartValue(day: "Aug 4", value: 158),
    ChartValue(day: "Sep 5", value: 401),
]

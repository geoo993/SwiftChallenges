import SwiftUI

struct DatePickerView: View {
    @State var date: Date = .now
    
    var body: some View {
        VStack {
            DatePicker("Select a date", selection: $date)
                .datePickerStyle(.graphical)
            DatePicker("Select a date 2", selection: $date, in: Date()..., displayedComponents: .date)
                .font(.title3)
            DatePicker("Select a date 3", selection: $date, in: ...Date(), displayedComponents: .date)
                .font(.title3)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    DatePickerView()
}

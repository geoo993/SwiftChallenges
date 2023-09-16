import SwiftUI

enum Fruit: String, CaseIterable, Identifiable {
    case orange = "Orange"
    case banana = "Banana"
    case apple = "Apple"
    
    var id: String { rawValue }
    var name: String { rawValue }
    
    var details: String {
        switch self {
        case .orange:
            return "Its usually Orange and juicy"
        case .banana:
            return "Its curved and yellow color"
        case .apple:
            return "Apple is like the big tech company"
        }
    }
}

struct WheelPicker: View {
    @State private var number = 1
    @State private var selectedFruit = Fruit.apple
    @State private var disableNumber = false
    
    var body: some View {
        VStack {
            Text(disableNumber ? "Cant change number" : "Can change number")
            VStack {
                Text("Picker")
                Picker("My Age", selection: $number) {
                    ForEach(1...100, id: \.self) {
                        Text("\($0)")
                    }
                }
                .if($disableNumber) { view in
                    view.disabled(true)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.orange)
            )
            .padding()
            
            Button {
                disableNumber.toggle()
            } label: {
                Text("Toggle Number")
            }
            
            VStack {
                Text("Fruits")
                Picker("My Age", selection: $selectedFruit) {
                    ForEach(Fruit.allCases) {
                        Text("\($0.rawValue)")
                            .tag($0)
                    }
                }
                .pickerStyle(.segmented)
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
            .padding()
        }
    }
}

#Preview {
    WheelPicker()
}

import SwiftUI

struct ComponentsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Jupiter")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Jupiter is more than twice as massive than the other planets of our solar system combined. The giant planet's Great Red Spot is a centuries-old storm bigger than Earth.")
            JupiterButtpnView(title: "Open")
            Spacer()
        }
        .padding()
    }
}

struct JupiterButtpnView: View {
    @State var title = ""
    var body: some View {
        Link(destination: URL(string: "https://solarsystem.nasa.gov/planets/jupiter/overview/")!
        , label: {
            Text(title)
                .bold()
        })
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(12)
    }
}

#Preview {
    ComponentsView()
}

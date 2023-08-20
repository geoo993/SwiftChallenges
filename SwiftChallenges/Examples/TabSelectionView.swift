import SwiftUI

struct TabSelectionView: View {
    @State var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TabViewOne(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "externaldrive.fill.badge.minus")
                    Text("One")
                }
                .tag(1)
            TabViewTwo(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "figure.wave.circle.fill")
                    Text("Two")
                }
                .tag(2)
        }
        .tint(Color.orange)
    }
}

struct TabViewOne: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 1, green: 0.09282856435, blue: 0.197771579, alpha: 1))
                .ignoresSafeArea(edges: .top)
            Text("Tap to Screen Two")
                .onTapGesture {
                    selectedTab = 2
                }
        }
    }
}

struct TabViewTwo: View {
    @Binding var selectedTab: Int

    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.3580556512, green: 1, blue: 0.5553144813, alpha: 1))
                .ignoresSafeArea(edges: .top)
            Text("Tap to Screen One")
                .onTapGesture {
                    selectedTab = 1
                }
        }
    }
}

#Preview {
    TabSelectionView()
}

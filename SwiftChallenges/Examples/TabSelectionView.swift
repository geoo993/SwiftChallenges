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
            TabViewThree(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "arrow.right")
                    Text("Three")
                }
                .tag(3)
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

struct TabViewThree: View {
    @Binding var selectedTab: Int
    @State private var isPresentWebView = false

    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1705656052, green: 0.3003894389, blue: 1, alpha: 1))
                .ignoresSafeArea(edges: .top)
            Text("Show Web")
                .padding()
                .foregroundStyle(Color.white)
                .onTapGesture {
                    isPresentWebView.toggle()
                }
                .fullScreenCover(isPresented: $isPresentWebView) {
                    SafariWebView(url: URL(string: "https://google.com")!)
                        .ignoresSafeArea()

                }
        }
    }
}

#Preview {
    TabSelectionView()
}

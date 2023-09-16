import SwiftUI

struct ScrollToTopView: View {
    @State private var tabSelection = 1
    @State private var tappedTwice = false
    @State private var main = UUID()
    @State private var courses = UUID()

    var body: some View {
        var handler: Binding<Int> {
            Binding {
                tabSelection
            } set: {
                if $0 == tabSelection {
                    tappedTwice = true
                }
                tabSelection = $0
            }
        }
        return ScrollViewReader { proxy in
            TabView(selection: handler) {
                NavigationView {
                    CoursesView(id: 1, title: "Main", image: "illustration2", colors: [Color(#colorLiteral(red: 1, green: 0.2751207352, blue: 0.4340645075, alpha: 1)), Color(#colorLiteral(red: 1, green: 0, blue: 0.9680435061, alpha: 1))])
                        .id(main)
                        .onChange(of: tappedTwice) { _, tapped in
                            guard tapped else { return }
                            withAnimation {
                                proxy.scrollTo(1)
                            }
                            main = UUID()
                            tappedTwice = false
                        }
                }
                .tabItem {
                    Image(systemName: "house")
                    Text("New")
                }
                .tag(1)
                
                NavigationView {
                    CoursesView(id: 2, title: "Courses", image: "illustration3", colors: [Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))])
                        .id(courses)
                        .onChange(of: tappedTwice) { _,tapped in
                            guard tapped else { return }
                            withAnimation {
                                proxy.scrollTo(2)
                            }
                            courses = UUID()
                            tappedTwice = false
                        }
                }
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Courses")
                }
                .tag(2)
            }
        }
    }
}

#Preview {
    ScrollToTopView()
}

extension ScrollToTopView {
    struct CoursesView: View {
        let id: Int
        let title: String
        let image: String
        let colors: [Color]
        private var columns = [GridItem(.adaptive(minimum: 159), spacing: 16)]
        
        init(id: Int, title: String, image: String, colors: [Color]) {
            self.id = id
            self.title = title
            self.image = image
            self.colors = colors
        }
        
        var body: some View {
            ScrollView {
                Text(title)
                    .font(.largeTitle).bold()
                    .padding(.horizontal, 20)
                    .padding(.top, 17)
                    .id(id)
                
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(0..<20) { number in
                        NavigationLink(destination: Text("SwiftUI for designers \(number)").font(.title)) {
                            CourseCardView(course: .init(name: "SwiftUI for designers"), image: image, hours: "23 sections - 4 hours", colors: colors, logo: "swift-logo")
                        }
                    }
                }
                .padding(20)
            }
            .navigationBarHidden(true)
        }
    }
}

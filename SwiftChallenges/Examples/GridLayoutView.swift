import SwiftUI

struct GridLayoutView: View {
    private var symbols = ["keyboard", "hifispeaker.fill", "printer.fill", "tv.fill", "desktopcomputer", "headphones", "tv.music.note", "mic", "plus.bubble", "video"]
    
    private var colors: [Color] = [.yellow, .purple, .green]
    
    // describes what the grid will look like
    @State private var gridItemLayout: [GridItem] = [ GridItem() ]
//    Array(repeating: .init(.flexible()), count: 3)
    
    @State private var isGrid = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 16) {
                    ForEach((0..<500), id: \.self) {
                        Image(systemName: symbols[$0 % symbols.count])
                            .font(.system(size: 30))
                            .frame(minWidth:0 , maxWidth: .infinity)
                            .frame(height: isGrid ? 100 : 300)
                            .background(
                                RoundedRectangle(cornerRadius: 20.0)
                                    .fill(colors[$0 % colors.count])
                            )
                    }
                }
                .padding()
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isGrid)
            }
            .navigationTitle("Items")
            .toolbar {
                ToolbarItem {
                    Button {
                        isGrid.toggle()
                        gridItemLayout = Array(
                            repeating: .init(
                                isGrid ? .adaptive(minimum: 100) : .flexible()
                            ),
                            count: isGrid ? 3 : 1
                        )
                    } label: {
                        Image(systemName: "square.grid.2x2")
                            .font(.title)
                            .symbolVariant(isGrid ? .fill : .square)
                            .foregroundStyle(.black, .black)
                    }
                }
            }
        }
    }
}

#Preview {
    GridLayoutView()
}

import SwiftUI

struct ContentView: View {
    var body: some View {
        TriptychView()
            .frame(minWidth: 1000, minHeight: 700)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(NSColor.controlBackgroundColor))
            .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
} 
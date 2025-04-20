import SwiftUI

struct StatCard: View {
    let title: String
    let items: [(String, String)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 4)
            
            ForEach(items, id: \.0) { item in
                HStack {
                    Text(item.0)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(item.1)
                        .monospacedDigit()
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .shadow(radius: 2)
    }
}

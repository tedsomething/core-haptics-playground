import SwiftUI

struct HapticItemView: View {
    var title: String
    @Binding var value: Float
    var range: ClosedRange<Float>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(title): \(String(format: "%.2f", value))")
            Slider(value: $value, in: range)
        }
        .padding(.vertical, 4)
    }
}

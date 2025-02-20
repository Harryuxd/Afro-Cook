import SwiftUI

struct GameKeyboardView: View {
    // Callback functions for keyboard actions
    let onKeyTapped: (String) -> Void
    let onDelete: () -> Void
    let onSubmit: () -> Void
    let disabledKeys: Set<String>
    let cuisineColor: Color
    
    // Keyboard layout in rows
    private let rows = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["Z", "X", "C", "V", "B", "N", "M"]
    ]
    
    var body: some View {
        VStack(spacing: 6) {
            // Create each row of the keyboard
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 4) {
                    // Add Enter button only to the last row
                    if row == rows.last {
                        Button(action: onSubmit) {
                            Text("Enter")
                                .font(.system(size: 14))
                                .frame(width: 60, height: 50)
                                .background(cuisineColor)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }
                    }
                    
                    // Letter keys for current row
                    ForEach(row, id: \.self) { key in
                        Button(action: { onKeyTapped(key) }) {
                            Text(key)
                                .font(.system(size: 18, weight: .medium))
                                .frame(width: 35, height: 50)
                                .background(Color.gray.opacity(0.1))
                                .foregroundColor(.black)
                                .cornerRadius(6)
                        }
                        .disabled(disabledKeys.contains(key))
                    }
                    
                    // Add Delete button only to the last row
                    if row == rows.last {
                        Button(action: onDelete) {
                            Image(systemName: "delete.left")
                                .font(.system(size: 18, weight: .medium))
                                .frame(width: 60, height: 50)
                                .background(cuisineColor)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }
                    }
                }
            }
        }
        // Basic padding for the keyboard
        .padding(.horizontal, 2)
        .padding(.vertical)
    }
} 

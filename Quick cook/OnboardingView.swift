import SwiftUI

struct OnboardingView: View {
    @State private var currentStep = 0
    @AppStorage("selectedMealType") private var selectedMealType: String?
    @AppStorage("selectedCookingTime") private var selectedTime: Int?
    @AppStorage("selectedCuisine") private var selectedCuisine: String?
    @Environment(\.dismiss) private var dismiss
    
    let mealTypes = ["Breakfast", "Brunch", "Lunch", "Dinner", "Snack"]
    let cookingTimes = [15, 30, 45, 60]
    let cuisines = [
        // Main Cuisines
        "🇯🇲 Jamaican",
        "🇳🇬 Nigerian",
        "🇪🇹 Ethiopian",
        "🇹🇹 Trinidadian",
        "🇭🇹 Haitian",
        "🇬🇭 Ghanaian",
        "🇧🇧 Barbadian",
        "🇰🇪 Kenyan",
        "🇿🇦 South African",
        "🇸🇳 Senegalese",
        
        // Additional Cuisines
        "🇨🇩 Congolese",
        "🇨🇮 Ivorian",
        "🇨🇲 Cameroonian",
        "🇦🇴 Angolan",
        "🇹🇿 Tanzanian",
        "🇧🇸 Bahamian"
    ]
    
    let mealFacts: [String: String] = [
        "Breakfast": "Did you know? Breakfast means 'breaking the fast' after a long night's sleep! 🥞",
        "Brunch": "Fun Fact: Brunch was invented in England in the late 1800s as a way to combine breakfast and lunch! 🥂",
        "Lunch": "Fun Fact: The word 'lunch' comes from 'luncheon,' which meant a small meal between breakfast and dinner. 🍔",
        "Dinner": "Surprise! In the 1700s, 'dinner' was actually the biggest meal at noon, not in the evening! 🍽",
        "Snack": "Did you know? Snacking can boost your energy and help you stay focused throughout the day! 🍿"
    ]
    
    private var currentMealFact: String? {
        guard let selectedMealType = selectedMealType else { return nil }
        return mealFacts[selectedMealType]
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text(stepTitle)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                
                switch currentStep {
                case 0:
                    mealTypeView
                case 1:
                    cookingTimeView
                case 2:
                    cuisineView
                default:
                    EmptyView()
                }
                
                if let fact = currentMealFact, currentStep == 0 {
                    HStack {
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                            
                            Text(fact)
                                .font(.subheadline)
                                .italic()
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    .transition(.opacity)
                }
                
                Spacer()
                
                Button(action: {
                    if currentStep == 2 {
                        dismiss()
                    } else {
                        withAnimation {
                            currentStep += 1
                        }
                    }
                }) {
                    Text(currentStep == 2 ? "Let's Cook!" : "Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            buttonEnabled 
                                ? cuisineColor
                                : Color(.systemGray4)
                        )
                        .cornerRadius(15)
                }
                .disabled(!buttonEnabled)
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .navigationViewStyle(.stack)
        }
        .interactiveDismissDisabled()
    }
    
    private var stepTitle: String {
        switch currentStep {
        case 0:
            return "What would you like to cook today?"
        case 1:
            return "How much time do you have for cooking?"
        case 2:
            return "Which cuisine would you prefer?"
        default:
            return ""
        }
    }
    
    private var buttonEnabled: Bool {
        switch currentStep {
        case 0:
            return selectedMealType != nil
        case 1:
            return selectedTime != nil
        case 2:
            return selectedCuisine != nil
        default:
            return false
        }
    }
    
    private var mealTypeView: some View {
        Picker("What would you like to make today?", selection: $selectedMealType) {
            ForEach(mealTypes, id: \.self) { mealType in
                Text(mealType)
                    .tag(mealType as String?)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .padding()
    }
    
    private var cookingTimeView: some View {
        Picker("How much time do you have for cooking?", selection: $selectedTime) {
            ForEach(cookingTimes, id: \.self) { time in
                Text("\(time) minutes")
                    .tag(time as Int?)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .padding()
    }
    
    private var cuisineView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(cuisines, id: \.self) { cuisine in
                    SelectionCard(
                        title: cuisine,
                        isSelected: selectedCuisine == cuisine,
                        action: {
                            selectedCuisine = selectedCuisine == cuisine ? nil : cuisine
                        }
                    )
                }
            }
            .padding()
            .padding(.bottom, 30)
        }
    }
    
    private func mealTypeIcon(for mealType: String) -> String {
        switch mealType {
        case "Breakfast": return "sunrise.fill"
        case "Brunch": return "sun.max.fill"
        case "Lunch": return "sun.min.fill"
        case "Dinner": return "moon.fill"
        case "Snack": return "leaf.fill"
        default: return "questionmark"
        }
    }
    
    // Helper property to get the selected cuisine's color
    private var cuisineColor: Color {
        guard let selectedCuisine = selectedCuisine else { return Color(hex: "008751") } // Default to Nigerian green
        
        switch selectedCuisine {
        case "🇳🇬 Nigerian":
            return Color(hex: "008751")
        case "🇬🇭 Ghanaian":
            return Color(hex: "006B3F")
        case "🇪🇹 Ethiopian":
            return Color(hex: "009A44")
        case "🇰🇪 Kenyan":
            return Color(hex: "BE3A34")
        case "🇿🇦 South African":
            return Color(hex: "007A4D")
        case "🇨🇩 Congolese":
            return Color(hex: "007FFF")
        case "🇨🇮 Ivorian":
            return Color(hex: "F77F00")
        case "🇸🇳 Senegalese":
            return Color(hex: "009639")
        case "🇨🇲 Cameroonian":
            return Color(hex: "007A5E")
        case "🇦🇴 Angolan":
            return Color(hex: "CE1126")
        case "🇹🇿 Tanzanian":
            return Color(hex: "1EB53A")
        case "🇭🇹 Haitian":
            return Color(hex: "00209F")
        case "🇯🇲 Jamaican":
            return Color(hex: "009B3A")
        case "🇧🇧 Barbadian":
            return Color(hex: "00267F")
        case "🇹🇹 Trinidadian":
            return Color(hex: "C8102E")
        case "🇧🇸 Bahamian":
            return Color(hex: "00778B")
        default:
            return Color(hex: "008751") // Default to Nigerian green
        }
    }
}

struct SelectionCard: View {
    let title: String
    var icon: String?
    let isSelected: Bool
    let action: () -> Void
    
    private var cardColor: Color {
        switch title {
        case "🇳🇬 Nigerian":
            return Color(hex: "008751")
        case "🇬🇭 Ghanaian":
            return Color(hex: "006B3F")
        case "🇪🇹 Ethiopian":
            return Color(hex: "009A44")
        case "🇰🇪 Kenyan":
            return Color(hex: "BE3A34")
        case "🇿🇦 South African":
            return Color(hex: "007A4D")
        case "🇨🇩 Congolese":
            return Color(hex: "007FFF")
        case "🇨🇮 Ivorian":
            return Color(hex: "F77F00")
        case "🇸🇳 Senegalese":
            return Color(hex: "009639")
        case "🇨🇲 Cameroonian":
            return Color(hex: "007A5E")
        case "🇦🇴 Angolan":
            return Color(hex: "CE1126")
        case "🇹🇿 Tanzanian":
            return Color(hex: "1EB53A")
        case "🇭🇹 Haitian":
            return Color(hex: "00209F")
        case "🇯🇲 Jamaican":
            return Color(hex: "009B3A")
        case "🇧🇧 Barbadian":
            return Color(hex: "00267F")
        case "🇹🇹 Trinidadian":
            return Color(hex: "C8102E")
        case "🇧🇸 Bahamian":
            return Color(hex: "00778B")
        default:
            return Color(.systemGray6)
        }
    }
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomTrailing) {
                // Main card content
                VStack(alignment: .leading, spacing: 8) {
                    Text("CUISINE")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .opacity(0.7)
                    
                    Text(title)
                        .font(.title2.bold())
                        .frame(maxWidth: 170, alignment: .leading)
                        .layoutPriority(1)
                        .padding(.vertical, 4)
                    
                    Text("Popular Foods:")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .opacity(0.7)
                        .padding(.top, 8)
                    
                    ForEach(popularFoods, id: \.self) { food in
                        Text("• \(food)")
                            .font(.caption2)
                            .opacity(0.8)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(30)
                
                // Map image
                Image(mapImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .opacity(0.2)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
                    .zIndex(-1)
                
                // Checkmark
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding(20)
                        .zIndex(1)
                }
            }
            .foregroundColor(.white)
            .frame(width: 260, height: 310)
            .background(
                LinearGradient(
                    colors: [
                        cardColor,
                        cardColor.opacity(0.8)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(
                color: cardColor.opacity(0.3),
                radius: 8,
                x: 0,
                y: 12
            )
            .shadow(
                color: cardColor.opacity(0.3),
                radius: 2,
                x: 0,
                y: 1
            )
        }
    }
    
    // Helper to get map image name based on country
    private var mapImageName: String {
        switch title {
        case "🇳🇬 Nigerian":
            return "Nigeria"
        case "🇬🇭 Ghanaian":
            return "Ghana"
        case "🇪🇹 Ethiopian":
            return "Ethiopia"
        case "🇰🇪 Kenyan":
            return "Kenya"
        case "🇿🇦 South African":
            return "South Africa"
        case "🇨🇩 Congolese":
            return "Congo DR"
        case "🇨🇮 Ivorian":
            return "Ivory Coast"
        case "🇸🇳 Senegalese":
            return "Senegal"
        case "🇨🇲 Cameroonian":
            return "Cameroon"
        case "🇦🇴 Angolan":
            return "Angola"
        case "🇹🇿 Tanzanian":
            return "Tanzania"
        case "🇭🇹 Haitian":
            return "Haiti"
        case "🇯🇲 Jamaican":
            return "Jamaica"
        case "🇧🇧 Barbadian":
            return "Barbados"
        case "🇹🇹 Trinidadian":
            return "Trinidad And Tobago"
        case "🇧🇸 Bahamian":
            return "Bahamas"
        default:
            return "default"
        }
    }
    
    private var popularFoods: [String] {
        switch title {
        case "🇳🇬 Nigerian":
            return ["Jollof Rice", "Egusi Soup", "Pounded Yam", "Suya"]
        case "🇬🇭 Ghanaian":
            return ["Waakye", "Jollof Rice", "Banku", "Fufu"]
        case "🇪🇹 Ethiopian":
            return ["Injera", "Doro Wat", "Shiro", "Tibs"]
        case "🇰🇪 Kenyan":
            return ["Ugali", "Nyama Choma", "Sukuma Wiki", "Pilau"]
        case "🇿🇦 South African":
            return ["Bobotie", "Pap", "Boerewors", "Chakalaka"]
        case "🇨🇩 Congolese":
            return ["Fufu", "Pondu", "Moambe", "Makemba"]
        case "🇨🇮 Ivorian":
            return ["Attieke", "Kedjenou", "Alloco", "Garba"]
        case "🇸🇳 Senegalese":
            return ["Thieboudienne", "Yassa", "Mafe", "Pastels"]
        case "🇨🇲 Cameroonian":
            return ["Ndole", "Eru", "Achu", "Koki"]
        case "🇦🇴 Angolan":
            return ["Muamba", "Calulu", "Funge", "Moamba"]
        case "🇹🇿 Tanzanian":
            return ["Ugali", "Pilau", "Nyama Choma", "Mshikaki"]
        case "🇭🇹 Haitian":
            return ["Griot", "Soup Joumou", "Diri ak Pwa", "Pikliz"]
        case "🇯🇲 Jamaican":
            return ["Jerk Chicken", "Ackee & Saltfish", "Curry Goat", "Patties"]
        case "🇧🇧 Barbadian":
            return ["Flying Fish", "Cou-Cou", "Pudding & Souse", "Fish Cakes"]
        case "🇹🇹 Trinidadian":
            return ["Doubles", "Roti", "Callaloo", "Bake & Shark"]
        case "🇧🇸 Bahamian":
            return ["Conch Fritters", "Rock Lobster", "Peas n' Rice", "Guava Duff"]
        default:
            return []
        }
    }
}

struct TimeCard: View {
    let minutes: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: "clock.fill")
                    .font(.system(size: 40))
                    .foregroundColor(isSelected ? .white : .black)
                Text("\(minutes) min")
                    .font(.headline)
                    .foregroundColor(isSelected ? .white : .black)
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .padding(.top, 8)
                }
            }
            .frame(width: 160, height: 200)
            .background(isSelected ? .black : .clear)
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding(.bottom, 20)
        }
    }
}

// Add Color extension for hex support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 

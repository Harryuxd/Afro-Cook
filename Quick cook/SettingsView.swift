import SwiftUI

struct SettingsView: View {
    @State private var isDarkMode = false
    @State private var notificationsEnabled = true
    @State private var selectedLanguage = "English"
    @AppStorage("shouldShowSplash") private var shouldShowSplash = false
    @AppStorage("selectedMealType") private var selectedMealType = "Dinner"
    @AppStorage("selectedCookingTime") private var selectedCookingTime = 30
    @AppStorage("selectedCuisine") private var selectedCuisine = "🇳🇬 Nigerian"
    @Environment(\.presentationMode) var presentationMode
    
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
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Preferences")) {
                    Picker("Meal Type", selection: $selectedMealType) {
                        ForEach(mealTypes, id: \.self) { mealType in
                            Text(mealType).tag(mealType)
                        }
                    }
                    
                    Picker("Cooking Time", selection: $selectedCookingTime) {
                        ForEach(cookingTimes, id: \.self) { time in
                            Text("\(time) minutes").tag(time)
                        }
                    }
                    
                    Picker("Preferred Cuisine", selection: $selectedCuisine) {
                        ForEach(cuisines, id: \.self) { cuisine in
                            Text(cuisine).tag(cuisine)
                        }
                    }
                }
                
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                
                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                }
                
                Section(header: Text("Language")) {
                    Text(selectedLanguage)
                }
                
                Section(header: Text("About")) {
                    Text("Version 1.0")
                    Text("Made for Students ❤️")
                }
                
                Section {
                    Button(action: {
                        shouldShowSplash = true
                        // Get the window scene and restart
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            window.rootViewController?.dismiss(animated: true)
                        }
                    }) {
                        HStack {
                            Text("Restart Onboarding")
                            Spacer()
                            Image(systemName: "arrow.clockwise")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
} 
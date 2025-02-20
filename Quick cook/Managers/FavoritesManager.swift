import Foundation
class FavoritesManager: ObservableObject {
    @Published private(set) var favoriteMeals: Set<String> = []
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "favoriteMeals"),
           let meals = try? JSONDecoder().decode(Set<String>.self, from: data) {
            favoriteMeals = meals
        }
    }
    
    func toggleFavorite(for mealName: String) {
        if favoriteMeals.contains(mealName) {
            favoriteMeals.remove(mealName)
        } else {
            favoriteMeals.insert(mealName)
        }
        
        if let encoded = try? JSONEncoder().encode(favoriteMeals) {
            UserDefaults.standard.set(encoded, forKey: "favoriteMeals")
        }
    }
    
    func isFavorite(_ mealName: String) -> Bool {
        favoriteMeals.contains(mealName)
    }
} 

//
//  ContentView.swift
//  Quick cook
//
//  Created by Harry Fatukasi on 2025-02-17.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("selectedCuisine") private var selectedCuisine = "🇳🇬 Nigerian"
    @State private var showSettings = false
    @State private var selectedCookingTime: Int = 30
    @State private var selectedMealType = "All"
    @State private var showCountryFilter = false
    @State private var selectedTab = 0
    @StateObject private var favoritesManager = FavoritesManager()
    
    let mealTypes = ["All", "Breakfast", "Lunch", "Dinner", "Snack", "Dessert"]
    
    // Add cuisineColor computed property
    private var cuisineColor: Color {
        switch selectedCuisine {
        case "🇯🇲 Jamaican":
            return Color(hex: "009B3A")
        case "🇳🇬 Nigerian":
            return Color(hex: "008751")
        case "🇪🇹 Ethiopian":
            return Color(hex: "009A44")
        case "🇹🇹 Trinidadian":
            return Color(hex: "C8102E")
        case "🇭🇹 Haitian":
            return Color(hex: "00209F")
        case "🇬🇭 Ghanaian":
            return Color(hex: "006B3F")
        case "🇧🇧 Barbadian":
            return Color(hex: "00267F")
        case "🇰🇪 Kenyan":
            return Color(hex: "BE3A34")
        case "🇿🇦 South African":
            return Color(hex: "007A4D")
        case "🇸🇳 Senegalese":
            return Color(hex: "009639")
        case "🇨🇩 Congolese":
            return Color(hex: "007FFF")
        case "🇨🇮 Ivorian":
            return Color(hex: "F77F00")
        case "🇨🇲 Cameroonian":
            return Color(hex: "007A5E")
        case "🇦🇴 Angolan":
            return Color(hex: "CE1126")
        case "🇹🇿 Tanzanian":
            return Color(hex: "1EB53A")
        case "🇧🇸 Bahamian":
            return Color(hex: "00778B")
        default:
            return Color(hex: "008751") // Default to Nigerian green
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            NavigationView {
                HomeView(
                    selectedCuisine: $selectedCuisine,
                    showSettings: $showSettings,
                    selectedCookingTime: $selectedCookingTime,
                    selectedMealType: $selectedMealType,
                    showCountryFilter: $showCountryFilter,
                    cuisineColor: cuisineColor
                )
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
            
            // Search Tab
            NavigationView {
                GameView(cuisineColor: cuisineColor)
            }
            .tabItem {
                Image(systemName: "gamecontroller.fill")
                Text("Play")
            }
            .tag(1)
            
            // Favorites Tab
            NavigationView {
                FavoritesView(cuisineColor: cuisineColor, allMeals: getAllMeals())
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favorites")
            }
            .tag(2)
            
            // Profile Tab
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(3)
        }
        .environmentObject(favoritesManager)
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showCountryFilter) {
            CountryFilterView(selectedCuisine: $selectedCuisine)
        }
        .tint(cuisineColor)
    }
    
    // Helper function to get all meals
    private func getAllMeals() -> [Meal] {
        let allCuisineMeals = HomeView.cuisineFoods.values.flatMap { $0 }
        return Array(allCuisineMeals)
    }
}

// Home View
struct HomeView: View {
    @Binding var selectedCuisine: String
    @Binding var showSettings: Bool
    @Binding var selectedCookingTime: Int
    @Binding var selectedMealType: String
    @Binding var showCountryFilter: Bool
    let cuisineColor: Color  // Add this property
    
    let mealTypes = ["All", "Breakfast", "Lunch", "Dinner", "Snack", "Dessert"]
    
    // Change from private to static
    static let cuisineFoods: [String: [Meal]] = [
        "🇯🇲 Jamaican": [
            Meal(name: "Curry Goat",
                 image: "Curry-Goat",
                 food_fact: "A Caribbean favorite, curry goat was influenced by Indian indentured servants",
                 description: "Spicy Caribbean curry with tender goat meat",
                 prep_time: 30,
                 cook_time: 120,
                 total_time: 150,
                 difficulty: "Medium",
                 ingredients: [],
                 steps: ["Marinate goat meat...", "Cook with curry spices..."],
                 mealType: "Dinner",
                 tags: ["Curry", "Spicy", "Caribbean", "Goat", "Stew"],
                 course: "Main Course",
                 cuisine: "Jamaican",
                 keywords: ["curry", "goat", "caribbean", "jamaican"],
                 servings: "6 People",
                 calories: "380kcal",
                 author: "Caribbean Kitchen",
                 ingredientSections: [
                     IngredientSection(title: "For the marinade", ingredients: ["1kg goat meat", "4 cloves garlic"]),
                     IngredientSection(title: "For the curry", ingredients: ["3 tbsp curry powder", "Scotch bonnet pepper"])
                 ],
                 nutrition: Nutrition(
                     calories: "380kcal",
                     carbohydrates: "8.2g",
                     protein: "42.5g",
                     fat: "18.7g",
                     saturatedFat: "5.8g",
                     polyunsaturatedFat: "1.2g",
                     monounsaturatedFat: "9.8g",
                     transFat: "0g",
                     cholesterol: "125mg",
                     sodium: "520mg",
                     potassium: "680mg",
                     fiber: "2.1g",
                     sugar: "3.2g",
                     vitaminA: "850IU",
                     vitaminC: "45mg",
                     calcium: "48mg",
                     iron: "4.2mg"
                 )
            )
        ],
        "🇳🇬 Nigerian": [
            Meal(name: "Egusi Soup",
                 image: "Egusi-Soup",
                 food_fact: "Made from ground melon seeds, rich in protein and oils",
                 description: "Traditional Nigerian soup made with ground melon seeds",
                 prep_time: 30,
                 cook_time: 60,
                 total_time: 90,
                 difficulty: "Medium",
                 ingredients: [],
                 steps: ["Toast ground egusi...", "Add to palm oil base..."],
                 mealType: "Dinner",
                 tags: ["Soup", "Nigerian", "Protein", "Traditional"],
                 course: "Main Course",
                 cuisine: "Nigerian",
                 keywords: ["egusi", "soup", "melon seeds", "nigerian"],
                 servings: "8 People",
                 calories: "450kcal",
                 author: "African Kitchen",
                 ingredientSections: [
                     IngredientSection(title: "Main ingredients", ingredients: ["2 cups ground egusi", "Assorted meat"]),
                     IngredientSection(title: "Vegetables", ingredients: ["Bitter leaf", "Spinach"])
                 ],
                 nutrition: Nutrition(
                     calories: "450kcal",
                     carbohydrates: "12g",
                     protein: "32g",
                     fat: "28g",
                     saturatedFat: "8.5g",
                     polyunsaturatedFat: "6.2g",
                     monounsaturatedFat: "12.4g",
                     transFat: "0.1g",
                     cholesterol: "65mg",
                     sodium: "580mg",
                     potassium: "820mg",
                     fiber: "5.8g",
                     sugar: "3.5g",
                     vitaminA: "3500IU",
                     vitaminC: "42mg",
                     calcium: "85mg",
                     iron: "6.5mg"
                 )
            )
        ],
        "🇪🇹 Ethiopian": [
            Meal(name: "Doro Wat",
                 image: "Doro-Wat",
                 food_fact: "A traditional Ethiopian dish, often served at weddings",
                 description: "Ethiopian chicken stew with berbere spice",
                 prep_time: 30,
                 cook_time: 120,
                 total_time: 150,
                 difficulty: "Medium",
                 ingredients: [
                    "1 kg chicken",
                    "2 onions",
                    "2 cloves garlic",
                    "1 scotch bonnet pepper",
                    "1 tsp berbere spice",
                    "1 tsp turmeric",
                    "1 tsp cumin",
                    "Salt to taste"
                 ],
                 steps: [
                    "Marinate chicken with spices",
                    "Cook with onions and garlic",
                    "Add stock and simmer until done"
                 ],
                 mealType: "Dinner",
                 tags: ["Chicken", "Ethiopian", "Traditional", "Stew"],
                 course: "Main Course",
                 cuisine: "Ethiopian",
                 keywords: ["doro", "wat", "chicken", "ethiopian"],
                 servings: "6 People",
                 calories: "350kcal",
                 author: "Ethiopian Kitchen",
                 ingredientSections: [
                     IngredientSection(title: "For the marinade", ingredients: ["1 kg chicken", "2 onions", "2 cloves garlic", "1 scotch bonnet pepper", "1 tsp berbere spice", "1 tsp turmeric", "1 tsp cumin", "Salt to taste"]),
                     IngredientSection(title: "Main ingredients", ingredients: ["1 kg chicken"])
                 ],
                 nutrition: Nutrition(
                     calories: "350kcal",
                     carbohydrates: "8.2g",
                     protein: "42.5g",
                     fat: "18.7g",
                     saturatedFat: "5.8g",
                     polyunsaturatedFat: "1.2g",
                     monounsaturatedFat: "9.8g",
                     transFat: "0g",
                     cholesterol: "125mg",
                     sodium: "520mg",
                     potassium: "680mg",
                     fiber: "2.1g",
                     sugar: "3.2g",
                     vitaminA: "850IU",
                     vitaminC: "45mg",
                     calcium: "48mg",
                     iron: "4.2mg"
                 )
            )
        ],
        "🇹🇹 Trinidadian": [
            Meal(name: "Double Decker",
                 image: "Double-Decker",
                 food_fact: "A popular Trinidadian street food",
                 description: "Trinidadian sandwich with fried bread, meat, and cheese",
                 prep_time: 10,
                 cook_time: 10,
                 total_time: 20,
                 difficulty: "Easy",
                 ingredients: [
                    "2 slices of bread",
                    "1 oz of meat",
                    "1 oz of cheese",
                    "1 tsp of oil"
                 ],
                 steps: [
                    "Fry bread slices",
                    "Add meat and cheese",
                    "Close the sandwich"
                 ],
                 mealType: "Lunch",
                 tags: ["Sandwich", "Trinidadian", "Street Food"],
                 course: "Main Course",
                 cuisine: "Trinidadian",
                 keywords: ["double", "decker", "sandwich", "trinidadian"],
                 servings: "1 Person",
                 calories: "250kcal",
                 author: "Trinidadian Kitchen",
                 ingredientSections: [
                     IngredientSection(title: "Ingredients", ingredients: ["2 slices of bread", "1 oz of meat", "1 oz of cheese", "1 tsp of oil"]),
                     IngredientSection(title: "Main ingredients", ingredients: ["2 slices of bread", "1 oz of meat", "1 oz of cheese"])
                 ],
                 nutrition: Nutrition(
                     calories: "250kcal",
                     carbohydrates: "30g",
                     protein: "15g",
                     fat: "10g",
                     saturatedFat: "5g",
                     polyunsaturatedFat: "2g",
                     monounsaturatedFat: "7g",
                     transFat: "0.5g",
                     cholesterol: "25mg",
                     sodium: "500mg",
                     potassium: "100mg",
                     fiber: "1g",
                     sugar: "2g",
                     vitaminA: "100IU",
                     vitaminC: "0.5mg",
                     calcium: "50mg",
                     iron: "1mg"
                 )
            )
        ],
        "🇭🇹 Haitian": [
            Meal(name: "Boucan",
                 image: "Boucan",
                 food_fact: "A traditional Haitian dish, often served at weddings",
                 description: "Haitian stew with meat and vegetables",
                 prep_time: 30,
                 cook_time: 120,
                 total_time: 150,
                 difficulty: "Medium",
                 ingredients: [
                    "1 kg meat",
                    "2 onions",
                    "2 cloves garlic",
                    "1 scotch bonnet pepper",
                    "1 tsp berbere spice",
                    "1 tsp turmeric",
                    "1 tsp cumin",
                    "Salt to taste"
                 ],
                 steps: [
                    "Marinate meat with spices",
                    "Cook with onions and garlic",
                    "Add stock and simmer until done"
                 ],
                 mealType: "Dinner",
                 tags: ["Meat", "Haitian", "Traditional", "Stew"],
                 course: "Main Course",
                 cuisine: "Haitian",
                 keywords: ["boucan", "meat", "haitian", "traditional"],
                 servings: "6 People",
                 calories: "350kcal",
                 author: "Haitian Kitchen",
                 ingredientSections: [
                     IngredientSection(title: "For the marinade", ingredients: ["1 kg meat", "2 onions", "2 cloves garlic", "1 scotch bonnet pepper", "1 tsp berbere spice", "1 tsp turmeric", "1 tsp cumin", "Salt to taste"]),
                     IngredientSection(title: "Main ingredients", ingredients: ["1 kg meat"])
                 ],
                 nutrition: Nutrition(
                     calories: "350kcal",
                     carbohydrates: "8.2g",
                     protein: "42.5g",
                     fat: "18.7g",
                     saturatedFat: "5.8g",
                     polyunsaturatedFat: "1.2g",
                     monounsaturatedFat: "9.8g",
                     transFat: "0g",
                     cholesterol: "125mg",
                     sodium: "520mg",
                     potassium: "680mg",
                     fiber: "2.1g",
                     sugar: "3.2g",
                     vitaminA: "850IU",
                     vitaminC: "45mg",
                     calcium: "48mg",
                     iron: "4.2mg"
                 )
            )
        ],
        "🇬🇭 Ghanaian": [
            Meal(name: "Jollof Rice",
                 image: "Jollof-Rice",
                 food_fact: "A popular West African dish.",
                 description: "Spicy tomato-based rice dish",
                 prep_time: 20,
                 cook_time: 40,
                 total_time: 60,
                 difficulty: "Medium",
                 ingredients: [
                    "2 cups long grain rice",
                    "4 large tomatoes",
                    "2 red bell peppers",
                    "2 onions",
                    "3 tbsp tomato paste",
                    "2 cloves garlic",
                    "2 bay leaves",
                    "1 tsp thyme",
                    "Salt to taste"
                 ],
                 steps: [
                    "Blend tomatoes, peppers, and onions",
                    "Cook down tomato mixture",
                    "Add rice and stock",
                    "Cook until rice is done"
                 ],
                 mealType: "Dinner",
                 tags: ["Rice", "Spicy", "West African", "Party Food"],
                 course: "Main Course",
                 cuisine: "Nigerian",
                 keywords: ["jollof", "rice", "nigerian", "party rice"],
                 servings: "6 People",
                 calories: "350kcal",
                 author: "African Kitchen",
                 ingredientSections: [
                     IngredientSection(title: "For the sauce", ingredients: ["4 large tomatoes", "2 red bell peppers"]),
                     IngredientSection(title: "For the rice", ingredients: ["2 cups long grain rice", "2 bay leaves"])
                 ],
                 nutrition: Nutrition(
                     calories: "568.5kcal",
                     carbohydrates: "88.1g",
                     protein: "10.8g",
                     fat: "19g",
                     saturatedFat: "3.4g",
                     polyunsaturatedFat: "4.6g",
                     monounsaturatedFat: "10.4g",
                     transFat: "0.2g",
                     cholesterol: "10.3mg",
                     sodium: "665.5mg",
                     potassium: "557.4mg",
                     fiber: "4.1g",
                     sugar: "7.3g",
                     vitaminA: "1982.6IU",
                     vitaminC: "69.4mg",
                     calcium: "60.6mg",
                     iron: "2mg"
                 )
            ),
            Meal(name: "Egusi Soup",
                 image: "Egusi-Soup",
                 food_fact: "Egusi is made from ground melon seeds and is rich in protein and healthy fats.",
                 description: "Thick, hearty soup made with ground melon seeds",
                 prep_time: 30,
                 cook_time: 60,
                 total_time: 90,
                 difficulty: "Medium",
                 ingredients: [
                    "2 cups ground egusi (melon seeds)",
                    "1 kg assorted meat",
                    "2 cups pumpkin leaves",
                    "2 onions",
                    "3 scotch bonnet peppers",
                    "Palm oil",
                    "Stock cubes",
                    "Salt to taste"
                 ],
                 steps: [
                    "Brown the ground egusi",
                    "Add meat and stock",
                    "Add vegetables",
                    "Simmer until done"
                 ],
                 mealType: "Dinner",
                 tags: ["Soup", "Protein Rich", "Nigerian", "Traditional", "Spicy", "Melon Seeds", "Hearty", "Stew"],
                 course: "Main Course",
                 cuisine: "Nigerian",
                 keywords: ["egusi", "soup", "melon seeds", "nigerian soup"],
                 servings: "8 People",
                 calories: "450kcal",
                 author: "African Kitchen",
                 ingredientSections: [
                     IngredientSection(
                         title: "Main ingredients",
                         ingredients: [
                             "2 cups ground egusi (melon seeds)",
                             "1 kg assorted meat",
                             "Palm oil",
                             "Stock cubes",
                             "Salt to taste"
                         ]
                     ),
                     IngredientSection(
                         title: "Vegetables and aromatics",
                         ingredients: [
                             "2 cups pumpkin leaves",
                             "2 onions",
                             "3 scotch bonnet peppers"
                         ]
                     )
                 ],
                 nutrition: Nutrition(
                     calories: "450kcal",
                     carbohydrates: "12g",
                     protein: "32g",
                     fat: "28g",
                     saturatedFat: "8.5g",
                     polyunsaturatedFat: "6.2g",
                     monounsaturatedFat: "12.4g",
                     transFat: "0.1g",
                     cholesterol: "65mg",
                     sodium: "580mg",
                     potassium: "820mg",
                     fiber: "5.8g",
                     sugar: "3.5g",
                     vitaminA: "3500IU",
                     vitaminC: "42mg",
                     calcium: "85mg",
                     iron: "6.5mg"
                 )
            )
        ],
        "🇧🇧 Barbadian": [
            Meal(name: "Bajans",
                 image: "Bajans",
                 food_fact: "A traditional Barbadian dish, often served at weddings",
                 description: "Barbadian stew with meat and vegetables",
                 prep_time: 30,
                 cook_time: 120,
                 total_time: 150,
                 difficulty: "Medium",
                 ingredients: [
                    "1 kg meat",
                    "2 onions",
                    "2 cloves garlic",
                    "1 scotch bonnet pepper",
                    "1 tsp berbere spice",
                    "1 tsp turmeric",
                    "1 tsp cumin",
                    "Salt to taste"
                 ],
                 steps: [
                    "Marinate meat with spices",
                    "Cook with onions and garlic",
                    "Add stock and simmer until done"
                 ],
                 mealType: "Dinner",
                 tags: ["Meat", "Barbadian", "Traditional", "Stew"],
                 course: "Main Course",
                 cuisine: "Barbadian",
                 keywords: ["bajans", "meat", "barbadian", "traditional"],
                 servings: "6 People",
                 calories: "350kcal",
                 author: "Barbadian Kitchen",
                 ingredientSections: [
                     IngredientSection(title: "For the marinade", ingredients: ["1 kg meat", "2 onions", "2 cloves garlic", "1 scotch bonnet pepper", "1 tsp berbere spice", "1 tsp turmeric", "1 tsp cumin", "Salt to taste"]),
                     IngredientSection(title: "Main ingredients", ingredients: ["1 kg meat"])
                 ],
                 nutrition: Nutrition(
                     calories: "350kcal",
                     carbohydrates: "8.2g",
                     protein: "42.5g",
                     fat: "18.7g",
                     saturatedFat: "5.8g",
                     polyunsaturatedFat: "1.2g",
                     monounsaturatedFat: "9.8g",
                     transFat: "0g",
                     cholesterol: "125mg",
                     sodium: "520mg",
                     potassium: "680mg",
                     fiber: "2.1g",
                     sugar: "3.2g",
                     vitaminA: "850IU",
                     vitaminC: "45mg",
                     calcium: "48mg",
                     iron: "4.2mg"
                 )
            )
        ],
        "🇰🇪 Kenyan": [
            Meal(name: "Kachumbari",
                 image: "Kachumbari",
                 food_fact: "A Kenyan salad made from tomatoes, onions, and cucumber",
                 description: "Kenyan salad made from tomatoes, onions, and cucumber",
                 prep_time: 10,
                 cook_time: 0,
                 total_time: 10,
                 difficulty: "Easy",
                 ingredients: [
                    "2 tomatoes",
                    "1 cucumber",
                    "1 onion",
                    "1 red bell pepper",
                    "1/2 lime",
                    "Salt to taste"
                 ],
                 steps: [
                    "Blend all ingredients",
                    "Add salt and lime",
                    "Chill until ready to serve"
                 ],
                 mealType: "Snack",
                 tags: ["Salad", "Kenyan", "Traditional"],
                 course: "Appetizer",
                 cuisine: "Kenyan",
                 keywords: ["kachumbari", "salad", "kenyan", "traditional"],
                 servings: "1 Person",
                 calories: "50kcal",
                 author: "Kenyan Kitchen",
                 ingredientSections: [
                     IngredientSection(title: "Ingredients", ingredients: ["2 tomatoes", "1 cucumber", "1 onion", "1 red bell pepper", "1/2 lime", "Salt to taste"]),
                     IngredientSection(title: "Main ingredients", ingredients: ["2 tomatoes", "1 cucumber", "1 onion", "1 red bell pepper"])
                 ],
                 nutrition: Nutrition(
                     calories: "50kcal",
                     carbohydrates: "7g",
                     protein: "1g",
                     fat: "2g",
                     saturatedFat: "0g",
                     polyunsaturatedFat: "0g",
                     monounsaturatedFat: "0g",
                     transFat: "0g",
                     cholesterol: "0mg",
                     sodium: "200mg",
                     potassium: "200mg",
                     fiber: "2g",
                     sugar: "4g",
                     vitaminA: "1500IU",
                     vitaminC: "45mg",
                     calcium: "20mg",
                     iron: "0.5mg"
                 )
            )
        ],
        "🇿🇦 South African": [
            Meal(name: "Bunny Chow",
                 image: "Bunny-Chow",
                 food_fact: "Created by Indian migrants in Durban, served in hollowed bread",
                 description: "South African curry served in a bread loaf",
                 prep_time: 20,
                 cook_time: 60,
                 total_time: 80,
                 difficulty: "Medium",
                 ingredients: [],
                 steps: ["Prepare curry...", "Hollow bread loaf..."],
                 mealType: "Lunch",
                 tags: ["Curry", "Street Food", "South African", "Bread"],
                 course: "Main Course",
                 cuisine: "South African",
                 keywords: ["bunny", "chow", "curry", "durban"],
                 servings: "4 People",
                 calories: "650kcal",
                 author: "African Kitchen",
                 ingredientSections: [
                     IngredientSection(title: "For the curry", ingredients: ["500g lamb/beans", "Curry powder"]),
                     IngredientSection(title: "For serving", ingredients: ["1 loaf bread", "Fresh coriander"])
                 ],
                 nutrition: Nutrition(
                     calories: "650kcal",
                     carbohydrates: "82g",
                     protein: "28g",
                     fat: "24g",
                     saturatedFat: "7.2g",
                     polyunsaturatedFat: "3.8g",
                     monounsaturatedFat: "11.5g",
                     transFat: "0.3g",
                     cholesterol: "45mg",
                     sodium: "980mg",
                     potassium: "450mg",
                     fiber: "4.5g",
                     sugar: "6.8g",
                     vitaminA: "750IU",
                     vitaminC: "28mg",
                     calcium: "120mg",
                     iron: "4.8mg"
                 )
            )
        ],
        "🇸🇳 Senegalese": [
            Meal(name: "Thieboudienne",
                 image: "Thieboudienne",
                 food_fact: "A traditional Senegalese dish, made with rice and fish",
                 description: "Senegalese rice and fish stew",
                 prep_time: 30,
                 cook_time: 120,
                 total_time: 150,
                 difficulty: "Medium",
                 ingredients: [
                    "2 cups long grain rice",
                    "1 kg fish",
                    "2 onions",
                    "2 cloves garlic",
                    "1 scotch bonnet pepper",
                    "1 tsp turmeric",
                    "1 tsp cumin",
                    "Salt to taste"
                 ],
                 steps: [
                    "Cook rice",
                    "Cook fish",
                    "Add spices and vegetables",
                    "Simmer until done"
                 ],
                 mealType: "Dinner",
                 tags: ["Rice", "Fish", "Senegalese", "Traditional"],
                 course: "Main Course",
                 cuisine: "Senegalese",
                 keywords: ["thieboudienne", "rice", "fish", "senegalese"],
                 servings: "6 People",
                 calories: "450kcal",
                 author: "Senegalese Kitchen",
                 ingredientSections: [
                     IngredientSection(title: "For the rice", ingredients: ["2 cups long grain rice"]),
                     IngredientSection(title: "For the fish", ingredients: ["1 kg fish"]),
                     IngredientSection(title: "For the spices", ingredients: ["1 tsp turmeric", "1 tsp cumin"]),
                     IngredientSection(title: "For the vegetables", ingredients: ["2 onions", "1 scotch bonnet pepper"])
                 ],
                 nutrition: Nutrition(
                     calories: "450kcal",
                     carbohydrates: "82g",
                     protein: "32g",
                     fat: "12g",
                     saturatedFat: "3g",
                     polyunsaturatedFat: "2g",
                     monounsaturatedFat: "5g",
                     transFat: "0.2g",
                     cholesterol: "50mg",
                     sodium: "580mg",
                     potassium: "820mg",
                     fiber: "5.8g",
                     sugar: "3.5g",
                     vitaminA: "3500IU",
                     vitaminC: "42mg",
                     calcium: "85mg",
                     iron: "6.5mg"
                 )
            )
        ],
        "🇨🇩 Congolese": [
            Meal(name: "Ndolé",
                 image: "Ndolé",
                 food_fact: "A Congolese dish made from cassava leaves",
                 description: "Congolese dish made from cassava leaves",
                 prep_time: 30,
                 cook_time: 0,
                 total_time: 30,
                 difficulty: "Easy",
                 ingredients: [
                    "Cassava leaves",
                    "Tomatoes",
                    "Onions",
                    "Garlic",
                    "Chili peppers",
                    "Salt to taste"
                 ],
                 steps: [
                    "Blend all ingredients",
                    "Chill until ready to serve"
                 ],
                 mealType: "Snack",
                 tags: ["Cassava", "Congolese", "Traditional"],
                 course: "Appetizer",
                 cuisine: "Congolese",
                 keywords: ["ndolé", "cassava", "congolese", "traditional"],
                 servings: "1 Person",
                 calories: "50kcal",
                 author: "Congolese Kitchen",
                 ingredientSections: [
                     IngredientSection(title: "Ingredients", ingredients: ["Cassava leaves", "Tomatoes", "Onions", "Garlic", "Chili peppers", "Salt to taste"]),
                     IngredientSection(title: "Main ingredients", ingredients: ["Cassava leaves", "Tomatoes", "Onions", "Garlic", "Chili peppers"])
                 ],
                 nutrition: Nutrition(
                     calories: "50kcal",
                     carbohydrates: "12g",
                     protein: "1g",
                     fat: "2g",
                     saturatedFat: "0g",
                     polyunsaturatedFat: "0g",
                     monounsaturatedFat: "0g",
                     transFat: "0g",
                     cholesterol: "0mg",
                     sodium: "200mg",
                     potassium: "200mg",
                     fiber: "2g",
                     sugar: "4g",
                     vitaminA: "1500IU",
                     vitaminC: "45mg",
                     calcium: "20mg",
                     iron: "0.5mg"
                 )
            )
        ],
        "🇨🇮 Ivorian": [
            Meal(name: "Djéré",
                 image: "Djéré",
                 food_fact: "A traditional Ivorian dish, made from cassava",
                 description: "Ivorian dish made from cassava",
                 prep_time: 30,
                 cook_time: 0,
                 total_time: 30,
                 difficulty: "Easy",
                 ingredients: [
                    "Cassava",
                    "Tomatoes",
                    "Onions",
                    "Garlic",
                    "Chili peppers",
                    "Salt to taste"
                 ],
                 steps: [
                    "Blend all ingredients",
                    "Chill until ready to serve"
                 ],
                 mealType: "Snack",
                 tags: ["Cassava", "Ivorian", "Traditional"],
                 course: "Appetizer",
                 cuisine: "Ivorian",
                 keywords: ["djéré", "cassava", "ivorian", "traditional"],
                 servings: "1 Person",
                 calories: "50kcal",
                 author: "Ivorian Kitchen",
                 ingredientSections: [
                     IngredientSection(title: "Ingredients", ingredients: ["Cassava", "Tomatoes", "Onions", "Garlic", "Chili peppers", "Salt to taste"]),
                     IngredientSection(title: "Main ingredients", ingredients: ["Cassava", "Tomatoes", "Onions", "Garlic", "Chili peppers"])
                 ],
                 nutrition: Nutrition(
                     calories: "50kcal",
                     carbohydrates: "12g",
                     protein: "1g",
                     fat: "2g",
                     saturatedFat: "0g",
                     polyunsaturatedFat: "0g",
                     monounsaturatedFat: "0g",
                     transFat: "0g",
                     cholesterol: "0mg",
                     sodium: "200mg",
                     potassium: "200mg",
                     fiber: "2g",
                     sugar: "4g",
                     vitaminA: "1500IU",
                     vitaminC: "45mg",
                     calcium: "20mg",
                     iron: "0.5mg"
                 )
            )
        ],
        "🇨🇲 Cameroonian": [
            Meal(name: "Fufu",
                 image: "Fufu",
                 food_fact: "A Cameroonian dish made from cassava",
                 description: "Cameroonian dish made from cassava",
                 prep_time: 30,
                 cook_time: 0,
                 total_time: 30,
                 difficulty: "Easy",
                 ingredients: [
                    "Cassava",
                    "Tomatoes",
                    "Onions",
                    "Garlic",
                    "Chili peppers",
                    "Salt to taste"
                 ],
                 steps: [
                    "Blend all ingredients",
                    "Chill until ready to serve"
                 ],
                 mealType: "Snack",
                 tags: ["Cassava", "Cameroonian", "Traditional"],
                 course: "Appetizer",
                 cuisine: "Cameroonian",
                 keywords: ["fufu", "cassava", "cameroonian", "traditional"],
                 servings: "1 Person",
                 calories: "50kcal",
                 author: "Cameroonian Kitchen",
                 ingredientSections: [
                     IngredientSection(title: "Ingredients", ingredients: ["Cassava", "Tomatoes", "Onions", "Garlic", "Chili peppers", "Salt to taste"]),
                     IngredientSection(title: "Main ingredients", ingredients: ["Cassava", "Tomatoes", "Onions", "Garlic", "Chili peppers"])
                 ],
                 nutrition: Nutrition(
                     calories: "50kcal",
                     carbohydrates: "12g",
                     protein: "1g",
                     fat: "2g",
                     saturatedFat: "0g",
                     polyunsaturatedFat: "0g",
                     monounsaturatedFat: "0g",
                     transFat: "0g",
                     cholesterol: "0mg",
                     sodium: "200mg",
                     potassium: "200mg",
                     fiber: "2g",
                     sugar: "4g",
                     vitaminA: "1500IU",
                     vitaminC: "45mg",
                     calcium: "20mg",
                     iron: "0.5mg"
                 )
            )
        ],
        "🇦🇴 Angolan": [
            Meal(name: "Cacá",
                 image: "Cacá",
                 food_fact: "A traditional Angolan dish, made from cassava",
                 description: "Angolan dish made from cassava",
                 prep_time: 30,
                 cook_time: 0,
                 total_time: 30,
                 difficulty: "Easy",
                 ingredients: [
                    "Cassava",
                    "Tomatoes",
                    "Onions",
                    "Garlic",
                    "Chili peppers",
                    "Salt to taste"
                 ],
                 steps: [
                    "Blend all ingredients",
                    "Chill until ready to serve"
                 ],
                 mealType: "Snack",
                 tags: ["Cassava", "Angolan", "Traditional"],
                 course: "Appetizer",
                 cuisine: "Angolan",
                 keywords: ["cacá", "cassava", "angolan", "traditional"],
                 servings: "1 Person",
                 calories: "50kcal",
                 author: "Angolan Kitchen",
                 ingredientSections: [
                     IngredientSection(title: "Ingredients", ingredients: ["Cassava", "Tomatoes", "Onions", "Garlic", "Chili peppers", "Salt to taste"]),
                     IngredientSection(title: "Main ingredients", ingredients: ["Cassava", "Tomatoes", "Onions", "Garlic", "Chili peppers"])
                 ],
                 nutrition: Nutrition(
                     calories: "50kcal",
                     carbohydrates: "12g",
                     protein: "1g",
                     fat: "2g",
                     saturatedFat: "0g",
                     polyunsaturatedFat: "0g",
                     monounsaturatedFat: "0g",
                     transFat: "0g",
                     cholesterol: "0mg",
                     sodium: "200mg",
                     potassium: "200mg",
                     fiber: "2g",
                     sugar: "4g",
                     vitaminA: "1500IU",
                     vitaminC: "45mg",
                     calcium: "20mg",
                     iron: "0.5mg"
                 )
            )
        ],
        "🇹🇿 Tanzanian": [
            Meal(name: "Mchuzi",
                 image: "Mchuzi",
                 food_fact: "A traditional Tanzanian dish, made from cassava",
                 description: "Tanzanian dish made from cassava",
                 prep_time: 30,
                 cook_time: 0,
                 total_time: 30,
                 difficulty: "Easy",
                 ingredients: [
                    "Cassava",
                    "Tomatoes",
                    "Onions",
                    "Garlic",
                    "Chili peppers",
                    "Salt to taste"
                 ],
                 steps: [
                    "Blend all ingredients",
                    "Chill until ready to serve"
                 ],
                 mealType: "Snack",
                 tags: ["Cassava", "Tanzanian", "Traditional"],
                 course: "Appetizer",
                 cuisine: "Tanzanian",
                 keywords: ["mchuzi", "cassava", "tanzanian", "traditional"],
                 servings: "1 Person",
                 calories: "50kcal",
                 author: "Tanzanian Kitchen",
                 ingredientSections: [
                     IngredientSection(title: "Ingredients", ingredients: ["Cassava", "Tomatoes", "Onions", "Garlic", "Chili peppers", "Salt to taste"]),
                     IngredientSection(title: "Main ingredients", ingredients: ["Cassava", "Tomatoes", "Onions", "Garlic", "Chili peppers"])
                 ],
                 nutrition: Nutrition(
                     calories: "50kcal",
                     carbohydrates: "12g",
                     protein: "1g",
                     fat: "2g",
                     saturatedFat: "0g",
                     polyunsaturatedFat: "0g",
                     monounsaturatedFat: "0g",
                     transFat: "0g",
                     cholesterol: "0mg",
                     sodium: "200mg",
                     potassium: "200mg",
                     fiber: "2g",
                     sugar: "4g",
                     vitaminA: "1500IU",
                     vitaminC: "45mg",
                     calcium: "20mg",
                     iron: "0.5mg"
                 )
            )
        ],
        "🇧🇸 Bahamian": [
            Meal(name: "Bajans",
                 image: "Bajans",
                 food_fact: "A traditional Barbadian dish, often served at weddings",
                 description: "Barbadian stew with meat and vegetables",
                 prep_time: 30,
                 cook_time: 120,
                 total_time: 150,
                 difficulty: "Medium",
                 ingredients: [
                    "1 kg meat",
                    "2 onions",
                    "2 cloves garlic",
                    "1 scotch bonnet pepper",
                    "1 tsp berbere spice",
                    "1 tsp turmeric",
                    "1 tsp cumin",
                    "Salt to taste"
                 ],
                 steps: [
                    "Marinate meat with spices",
                    "Cook with onions and garlic",
                    "Add stock and simmer until done"
                 ],
                 mealType: "Dinner",
                 tags: ["Meat", "Barbadian", "Traditional", "Stew"],
                 course: "Main Course",
                 cuisine: "Barbadian",
                 keywords: ["bajans", "meat", "barbadian", "traditional"],
                 servings: "6 People",
                 calories: "350kcal",
                 author: "Barbadian Kitchen",
                 ingredientSections: [
                     IngredientSection(title: "For the marinade", ingredients: ["1 kg meat", "2 onions", "2 cloves garlic", "1 scotch bonnet pepper", "1 tsp berbere spice", "1 tsp turmeric", "1 tsp cumin", "Salt to taste"]),
                     IngredientSection(title: "Main ingredients", ingredients: ["1 kg meat"])
                 ],
                 nutrition: Nutrition(
                     calories: "350kcal",
                     carbohydrates: "8.2g",
                     protein: "42.5g",
                     fat: "18.7g",
                     saturatedFat: "5.8g",
                     polyunsaturatedFat: "1.2g",
                     monounsaturatedFat: "9.8g",
                     transFat: "0g",
                     cholesterol: "125mg",
                     sodium: "520mg",
                     potassium: "680mg",
                     fiber: "2.1g",
                     sugar: "3.2g",
                     vitaminA: "850IU",
                     vitaminC: "45mg",
                     calcium: "48mg",
                     iron: "4.2mg"
                 )
            )
        ]
    ]
    
    // Updated filterMeals function
    private func filterMeals() -> [Meal] {
        let meals = HomeView.cuisineFoods[selectedCuisine] ?? []
        return meals.filter { meal in
            if selectedMealType == "All" {
                return true
            }
            return meal.mealType == selectedMealType
        }
    }
    
    
    // Add computed property for current map image
    private var mapImageName: String {
        switch selectedCuisine {
        case "🇯🇲 Jamaican":
            return "Jamaica"
        case "🇳🇬 Nigerian":
            return "Nigeria"
        case "🇪🇹 Ethiopian":
            return "Ethiopia"
        case "🇹🇹 Trinidadian":
            return "Trinidad And Tobago"
        case "🇭🇹 Haitian":
            return "Haiti"
        case "🇬🇭 Ghanaian":
            return "Ghana"
        case "🇧🇧 Barbadian":
            return "Barbados"
        case "🇰🇪 Kenyan":
            return "Kenya"
        case "🇿🇦 South African":
            return "South Africa"
        case "🇸🇳 Senegalese":
            return "Senegal"
        case "🇨🇩 Congolese":
            return "Congo DR"
        case "🇨🇮 Ivorian":
            return "Ivory Coast"
        case "🇨🇲 Cameroonian":
            return "Cameroon"
        case "🇦🇴 Angolan":
            return "Angola"
        case "🇹🇿 Tanzanian":
            return "Tanzania"
        case "🇧🇸 Bahamian":
            return "Bahamas"
        default:
            return "Nigeria"
        }
    }
    
    // Add computed property for continent
    private var continentName: String {
        switch selectedCuisine {
        case "🇯🇲 Jamaican", "🇹🇹 Trinidadian", "🇭🇹 Haitian", "🇧🇧 Barbadian", "🇧🇸 Bahamian":
            return "Caribbean"
        case "🇳🇬 Nigerian", "🇬🇭 Ghanaian", "🇸🇳 Senegalese", "🇨🇮 Ivorian":
            return "West Africa"
        case "🇪🇹 Ethiopian", "🇰🇪 Kenyan", "🇹🇿 Tanzanian":
            return "East Africa"
        case "🇿🇦 South African", "🇦🇴 Angolan":
            return "Southern Africa"
        case "🇨🇩 Congolese", "🇨🇲 Cameroonian":
            return "Central Africa"
        default:
            return "Africa"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom navigation title with map
            HStack {
                Text("Quick Cook")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(mapImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
                    .opacity(0.8)
            }
            .padding(.horizontal)
            .padding(.top, 40)
            .padding(.bottom, 8)
            
            // Updated Cuisine Filter with Continent
            HStack {
                Button(action: { showCountryFilter.toggle() }) {
                    HStack {
                        Text(selectedCuisine)
                            .lineLimit(1)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(cuisineColor.opacity(0.1))
                    .foregroundColor(cuisineColor)
                    .cornerRadius(20)
                }
                
                Spacer()
                
                Text(continentName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            // Meal Type Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(mealTypes, id: \.self) { type in
                        Button(action: { selectedMealType = type }) {
                            Text(type)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    selectedMealType == type ?
                                    cuisineColor :
                                    cuisineColor.opacity(0.1)
                                )
                                .foregroundColor(
                                    selectedMealType == type ?
                                    .white :
                                    cuisineColor
                                )
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .background(Color.white)
            .shadow(color: .black.opacity(0.05), radius: 5, y: 5)
            
            // Content
            ScrollView {
                VStack(spacing: 16) {
                    let filteredFoods = filterMeals()
                    
                    if filteredFoods.isEmpty {
                        VStack(spacing: 16) {
                            Text("No meals found matching your filters")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding()
                                .multilineTextAlignment(.center)
                            
                            Image(mapImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 200)
                                .opacity(0.3)
                        }
                    } else {
                        ForEach(filteredFoods, id: \.name) { food in
                            NavigationLink(destination: MealDetailView(meal: food)) {
                                MealCard(meal: food, cuisineColor: cuisineColor)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true) // Hide default navigation bar
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showSettings.toggle() }) {
                    Image(systemName: "gear")
                        .foregroundColor(cuisineColor)
                }
            }
        }
    }
}

struct CountriesListView: View {
    let countries: [String]
    
    var body: some View {
        NavigationView {
            List(countries, id: \.self) { country in
                NavigationLink(destination: Text("Recipes for \(country)")) {
                    Text(country)
                        .font(.body)
                }
            }
            .navigationTitle("Browse")
            .searchable(text: .constant(""), prompt: "Search")
            
            Text("Select a country")
        }
    }
}

// New view for country filter
struct CountryFilterView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCuisine: String
    
    let cuisines = [
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
        "🇨🇩 Congolese",
        "🇨🇮 Ivorian",
        "🇨🇲 Cameroonian",
        "🇦🇴 Angolan",
        "🇹🇿 Tanzanian",
        "🇧🇸 Bahamian"
    ]
    
    var body: some View {
        NavigationView {
            List(cuisines, id: \.self) { cuisine in
                Button(action: {
                    selectedCuisine = cuisine
                    dismiss()
                }) {
                    HStack {
                        Text(cuisine)
                        Spacer()
                        if cuisine == selectedCuisine {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
            .navigationTitle("Select Cuisine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Helper view for meal cards
struct MealCard: View {
    let meal: Meal
    let cuisineColor: Color
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Left side - Image
            if let image = UIImage(named: meal.image) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            // Right side - Content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(meal.name)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        favoritesManager.toggleFavorite(for: meal.name)
                    }) {
                        Image(systemName: favoritesManager.isFavorite(meal.name) ? "heart.fill" : "heart")
                            .foregroundColor(cuisineColor)
                    }
                }
                
                Spacer()
                
                HStack {
                    // Time
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                        Text(meal.formattedTime)
                    }
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    
                    Spacer()
                    
                    // Difficulty
                    HStack(spacing: 4) {
                        Image(systemName: "chart.bar")
                            .font(.caption)
                        Text(meal.difficulty)
                    }
                    .foregroundColor(.gray)
                    .font(.subheadline)
                }
            }
            .padding(.vertical, 8)
        }
        .frame(height: 100)
        .padding(8)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, y: 5)
    }
}

#Preview {
    ContentView()
}

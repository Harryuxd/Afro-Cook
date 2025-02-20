import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    let cuisineColor: Color
    let allMeals: [Meal]
    
    var filteredMeals: [Meal] {
        if searchText.isEmpty {
            return []
        }
        return allMeals.filter { meal in
            meal.name.localizedCaseInsensitiveContains(searchText) ||
            meal.description.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(filteredMeals, id: \.name) { meal in
                        NavigationLink(destination: MealDetailView(meal: meal)) {
                            MealCard(meal: meal, cuisineColor: cuisineColor)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Search")
        .searchable(text: $searchText, prompt: "Search meals...")
    }
}
import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    let cuisineColor: Color
    let allMeals: [Meal]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                let favoriteMeals = allMeals.filter { favoritesManager.isFavorite($0.name) }
                
                if favoriteMeals.isEmpty {
                    Text("No favorite meals yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(favoriteMeals, id: \.name) { meal in
                        NavigationLink(destination: MealDetailView(meal: meal)) {
                            MealCard(meal: meal, cuisineColor: cuisineColor)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Favorites")
    }
}
import SwiftUI
import PhotosUI

struct CookingPhoto: Identifiable {
    let id = UUID()
    let image: UIImage
    let date: Date
}

struct MealDetailView: View {
    let meal: Meal
    @State private var selectedTab = 0
    @State private var showPrepTimer = false
    @State private var showCookTimer = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var cookingPhotos: [CookingPhoto] = []
    @State private var selectedPhotoForViewing: UIImage?
    @State private var isShowingFullScreenPhoto = false
    
    let tabs = ["Overview", "Recipe", "Cooking History"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Image and Title
                if let image = UIImage(named: meal.image) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                }
                
                // Tabs
                Picker("Sections", selection: $selectedTab) {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        Text(tabs[index]).tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Tab Content
                switch selectedTab {
                case 0: // Overview
                    overviewTab
                case 1: // Recipe
                    recipeTab
                case 2: // Cooking History (renamed from History)
                    cookingHistoryTab
                default:
                    EmptyView()
                }
            }
        }
        .navigationTitle(meal.name)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedItem) { newItem in
            if let item = newItem {
                handlePhotoSelection(item)
            }
        }
    }
    
    private var overviewTab: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 1. Tags
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(meal.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(15)
                    }
                }
            }
            .padding(.horizontal)
            
            // 2. Food Fact
            if !meal.food_fact.isEmpty {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                    
                    Text(meal.food_fact)
                        .font(.subheadline)
                        .italic()
                        .padding()
                }
            }
            
            // 3. Meal Info
            VStack(alignment: .leading, spacing: 12) {
                InfoRow(title: "Course", value: meal.course)
                InfoRow(title: "Cuisine", value: meal.cuisine)
                InfoRow(title: "Servings", value: meal.servings)
                InfoRow(title: "Calories", value: meal.calories)
                InfoRow(title: "Author", value: meal.author)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Description
            Text(meal.description)
                .font(.body)
                .padding(.horizontal)
            
            // Timers Section
            timersSection
                .padding(.horizontal)
            
            // Nutrition Section
            nutritionSection
                .padding(.horizontal)
        }
    }
    
    private var recipeTab: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Ingredients Section
            ingredientsSection
            
            // Instructions Section
            instructionsSection
        }
        .padding()
    }
    
    private var cookingHistoryTab: some View {
        VStack(spacing: 16) {
            if cookingPhotos.isEmpty {
                Spacer()
                Text("Add photos of your cooking journey!")
                    .foregroundColor(.secondary)
                    .padding()
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(cookingPhotos.sorted(by: { $0.date > $1.date })) { photo in
                            HStack(alignment: .top, spacing: 0) {
                                // Timeline line and dot
                                VStack {
                                    Circle()
                                        .fill(Color.accentColor)
                                        .frame(width: 10, height: 10)
                                    
                                    if photo.id != cookingPhotos.sorted(by: { $0.date > $1.date }).last?.id {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 2)
                                    }
                                }
                                .frame(width: 20)
                                .padding(.top, 6)
                                
                                // Photo content
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(formatDate(photo.date))
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            if let index = cookingPhotos.firstIndex(where: { $0.id == photo.id }) {
                                                cookingPhotos.remove(at: index)
                                            }
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    
                                    Image(uiImage: photo.image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .onTapGesture {
                                            selectedPhotoForViewing = photo.image
                                            isShowingFullScreenPhoto = true
                                        }
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                        )
                                }
                                .padding(.leading, 8)
                                .padding(.trailing)
                                .padding(.vertical, 12)
                            }
                        }
                    }
                }
                .padding(.vertical)
                .padding(.leading)
            }
            
            Spacer()
            
            PhotosPicker(selection: $selectedItem,
                        matching: .images) {
                Label("Add Photo", systemImage: "photo.badge.plus")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .sheet(isPresented: $isShowingFullScreenPhoto) {
            if let photo = selectedPhotoForViewing {
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)
                    
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                isShowingFullScreenPhoto = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .shadow(radius: 3)
                            }
                        }
                        Spacer()
                    }
                }
                .preferredColorScheme(.dark)
            }
        }
    }
    
    private var timersSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Prep Timer
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "clock")
                        Text("Prep: \(meal.prep_time) min")
                    }
                    if showPrepTimer {
                        TimerView(
                            minutes: meal.prep_time,
                            recipeName: meal.name,
                            timerType: "Prep"
                        )
                    }
                }
                Spacer()
                Button(action: { showPrepTimer.toggle() }) {
                    Image(systemName: showPrepTimer ? "timer.circle.fill" : "timer.circle")
                        .font(.title2)
                }
            }
            
            // Cook Timer
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "clock.fill")
                        Text("Cook: \(meal.cook_time) min")
                    }
                    if showCookTimer {
                        TimerView(
                            minutes: meal.cook_time,
                            recipeName: meal.name,
                            timerType: "Cook"
                        )
                    }
                }
                Spacer()
                Button(action: { showCookTimer.toggle() }) {
                    Image(systemName: showCookTimer ? "timer.circle.fill" : "timer.circle")
                        .font(.title2)
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        
        if Calendar.current.isDateInToday(date) {
            return "Today at " + date.formatted(date: .omitted, time: .shortened)
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday at " + date.formatted(date: .omitted, time: .shortened)
        } else if Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year) {
            formatter.dateFormat = "MMM d 'at' h:mm a"
        } else {
            formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        }
        
        return formatter.string(from: date)
    }
    
    private func handlePhotoSelection(_ item: PhotosPickerItem) {
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                let newPhoto = CookingPhoto(image: image, date: Date())
                cookingPhotos.append(newPhoto)
            }
        }
    }
    
    private var nutritionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Nutrition Facts")
                .font(.headline)
                .padding(.bottom, 4)
            
            Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 8) {
                GridRow {
                    Text("Calories").bold()
                    Text(meal.nutrition.calories)
                }
                GridRow {
                    Text("Carbohydrates").bold()
                    Text(meal.nutrition.carbohydrates)
                }
                GridRow {
                    Text("Protein").bold()
                    Text(meal.nutrition.protein)
                }
                GridRow {
                    Text("Fat").bold()
                    Text(meal.nutrition.fat)
                }
                GridRow {
                    Text("Fiber").bold()
                    Text(meal.nutrition.fiber)
                }
                GridRow {
                    Text("Sugar").bold()
                    Text(meal.nutrition.sugar)
                }
                GridRow {
                    Text("Sodium").bold()
                    Text(meal.nutrition.sodium)
                }
                GridRow {
                    Text("Potassium").bold()
                    Text(meal.nutrition.potassium)
                }
            }
            .font(.subheadline)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ingredients")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(meal.ingredientSections, id: \.title) { section in
                VStack(alignment: .leading, spacing: 8) {
                    Text(section.title)
                        .font(.headline)
                    
                    ForEach(section.ingredients, id: \.self) { ingredient in
                        Text("• " + ingredient)
                            .font(.body)
                    }
                }
                .padding(.bottom, 8)
            }
        }
    }
    
    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Instructions")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(Array(meal.steps.enumerated()), id: \.element) { index, step in
                HStack(alignment: .top, spacing: 16) {
                    Text("\(index + 1)")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.3))
                        .fontWeight(.bold)
                    
                    Text(step)
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                }
                .padding(.bottom, 8)
            }
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
    }
} 
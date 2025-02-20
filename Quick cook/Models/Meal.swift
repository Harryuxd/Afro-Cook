// Represents a complete meal with all its details and recipe information
struct Meal: Codable {
    // Basic meal information
    let name: String            // Name of the dish
    let image: String          // Image filename
    let food_fact: String      // Interesting fact about the dish
    let description: String    // Brief description of the dish
    
    // Timing information
    let prep_time: Int         // Preparation time in minutes
    let cook_time: Int         // Cooking time in minutes
    let total_time: Int        // Total time to make the dish
    
    // Recipe details
    let difficulty: String     // Difficulty level (e.g., "Easy", "Medium", "Hard")
    let ingredients: [String]  // List of all ingredients (when not using sections)
    let steps: [String]       // Step-by-step cooking instructions
    let mealType: String      // Type of meal (e.g., "Main", "Dessert", "Appetizer")
    
    // Categorization and metadata
    let tags: [String]        // Tags for filtering and categorization
    let course: String        // When to serve (e.g., "Lunch/Dinner", "Breakfast")
    let cuisine: String       // Origin of the dish (e.g., "African", "Caribbean")
    let keywords: [String]    // Search keywords
    
    // Nutritional and serving information
    let servings: String      // Number of people it serves
    let calories: String      // Caloric information
    let author: String        // Recipe creator or source
    
    // Organized ingredients
    let ingredientSections: [IngredientSection]  // Grouped ingredients with titles
    
    // Nutrition information
    let nutrition: Nutrition
    
    // CodingKeys for JSON encoding/decoding
    enum CodingKeys: String, CodingKey {
        case name, image, food_fact, description, prep_time, cook_time
        case total_time, difficulty, ingredients, steps, mealType
        case tags, course, cuisine, keywords, servings, calories, author
        case ingredientSections, nutrition
    }
    
    var formattedTime: String {
        return "\(total_time) mins"
    }
    
    // Game initializer (minimal)
    init(name: String, image: String, food_fact: String) {
        self.name = name
        self.image = image
        self.food_fact = food_fact
        
        // Set default values for other required properties
        self.description = ""
        self.prep_time = 0
        self.cook_time = 0
        self.total_time = 0
        self.difficulty = ""
        self.ingredients = []
        self.steps = []
        self.mealType = ""
        self.tags = []
        self.course = ""
        self.cuisine = ""
        self.keywords = []
        self.servings = ""
        self.calories = ""
        self.author = ""
        self.ingredientSections = []
        self.nutrition = Nutrition(
            calories: "",
            carbohydrates: "",
            protein: "",
            fat: "",
            saturatedFat: "",
            polyunsaturatedFat: "",
            monounsaturatedFat: "",
            transFat: "",
            cholesterol: "",
            sodium: "",
            potassium: "",
            fiber: "",
            sugar: "",
            vitaminA: "",
            vitaminC: "",
            calcium: "",
            iron: ""
        )
    }
    
    // Full initializer (for ContentView)
    init(name: String, image: String, food_fact: String, description: String, 
         prep_time: Int, cook_time: Int, total_time: Int, difficulty: String,
         ingredients: [String], steps: [String], mealType: String, tags: [String],
         course: String, cuisine: String, keywords: [String], servings: String,
         calories: String, author: String, ingredientSections: [IngredientSection],
         nutrition: Nutrition) {
        self.name = name
        self.image = image
        self.food_fact = food_fact
        self.description = description
        self.prep_time = prep_time
        self.cook_time = cook_time
        self.total_time = total_time
        self.difficulty = difficulty
        self.ingredients = ingredients
        self.steps = steps
        self.mealType = mealType
        self.tags = tags
        self.course = course
        self.cuisine = cuisine
        self.keywords = keywords
        self.servings = servings
        self.calories = calories
        self.author = author
        self.ingredientSections = ingredientSections
        self.nutrition = nutrition
    }
}

// Represents a grouped section of ingredients with a title
struct IngredientSection: Codable {
    let title: String        // Section title (e.g., "For the sauce", "For the marinade")
    let ingredients: [String] // List of ingredients in this section
    
    // CodingKeys for JSON encoding/decoding
    enum CodingKeys: String, CodingKey {
        case title, ingredients
    }
}

struct Nutrition: Codable {
    let calories: String
    let carbohydrates: String
    let protein: String
    let fat: String
    let saturatedFat: String
    let polyunsaturatedFat: String
    let monounsaturatedFat: String
    let transFat: String
    let cholesterol: String
    let sodium: String
    let potassium: String
    let fiber: String
    let sugar: String
    let vitaminA: String
    let vitaminC: String
    let calcium: String
    let iron: String
}


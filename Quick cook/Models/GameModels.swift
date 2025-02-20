struct GameState {
    let allMeals: [Meal]  // All available meals
    let targetDish: Meal
    var currentLevel: Int
    var guesses: [String]
    var currentGuess: String
    var hasWon: Bool
    var gameCompleted: Bool
    var attemptsLeft: Int  // Add this property
    
    init(meals: [Meal], startLevel: Int = 0) {
        self.allMeals = meals
        self.currentLevel = startLevel
        self.targetDish = meals[startLevel]
        self.guesses = []
        self.currentGuess = ""
        self.hasWon = false
        self.gameCompleted = false
        self.attemptsLeft = 3  // Initialize with 3 attempts
    }
} 
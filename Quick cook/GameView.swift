import SwiftUI

struct GameView: View {
    let cuisineColor: Color
    @State private var gameState: GameState
    @State private var showRules = true
    @State private var showHint = false
    @State private var showSuccess = false
    @State private var showGameComplete = false
    @State private var showGameOver = false
    @State private var disabledKeys: Set<String> = []
    @State private var showError = false
    @State private var errorMessage = ""
    
    init(cuisineColor: Color) {
        self.cuisineColor = cuisineColor
        
        // Define game-specific meals with just necessary info
        let gameMeals = [
            Meal(
                name: "JOLLOFRICE",
                image: "Jollof-Rice",
                food_fact: "A spicy West African rice dish that originated from the Senegambia region, now a popular party dish"
            ),
            
            Meal(
                name: "EGUSI",
                image: "Egusi-Soup",
                food_fact: "A traditional West African soup made from ground melon seeds, rich in protein and healthy fats"
            ),
            
            Meal(
                name: "MOIMOI",
                image: "Moi-Moi",
                food_fact: "A steamed bean pudding made from peeled black-eyed peas, a protein-rich Nigerian delicacy"
            ),
            
            Meal(
                name: "CURRYGOAT",
                image: "Curry-Goat",
                food_fact: "A Caribbean favorite influenced by Indian indentured servants, known for its rich, spicy flavor"
            ),
            
            Meal(
                name: "JERKCHICKEN",
                image: "Jerk-Chicken",
                food_fact: "Jamaica's famous spicy grilled chicken, traditionally smoked over pimento wood"
            ),
            
            Meal(
                name: "ACKEEANDSALTFISH",
                image: "Ackee-Saltfish",
                food_fact: "Jamaica's national dish, combining salt cod with ackee, a fruit that looks like scrambled eggs when cooked"
            )
        ]
        
        _gameState = State(initialValue: GameState(meals: gameMeals))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            topButtons
            headerView
            attemptsIndicator
            dishImage
            letterGrid
            keyboardView
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .sheet(isPresented: $showRules) {
            RulesView(cuisineColor: cuisineColor)
        }
        .alert("Hint", isPresented: $showHint) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(gameState.targetDish.food_fact)
        }
        .alert("Correct!", isPresented: $showSuccess) {
            Button("Next Dish") {
                moveToNextLevel()
            }
        } message: {
            Text("You guessed it! Ready for the next one?")
        }
        .alert("Game Complete!", isPresented: $showGameComplete) {
            Button("Play Again") {
                resetGame()
            }
            Button("Exit", role: .cancel) {
                // Handle exit
            }
        } message: {
            Text("Congratulations! You've completed all the dishes!")
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .alert("Game Over!", isPresented: $showGameOver) {
            Button("Play Again") {
                resetGame()
            }
        } message: {
            Text("The word was '\(gameState.targetDish.name)'. Try again!")
        }
    }
    
    // MARK: - View Components
    
    private var topButtons: some View {
        HStack {
            Button("How to Play") {
                showRules = true
            }
            
            Spacer()
            
            Button("Hint") {
                showHint = true
            }
        }
        .font(.subheadline)
        .foregroundColor(cuisineColor)
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var headerView: some View {
        HStack {
            Text("Guess the Dish")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            Text("Level \(gameState.currentLevel + 1)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(cuisineColor)
        }
        .padding(.horizontal)
    }
    
    private var attemptsIndicator: some View {
        HStack(spacing: 12) {
            ForEach((0..<3).reversed(), id: \.self) { index in
                Image(systemName: index < gameState.attemptsLeft ? "x.circle" : "x.circle.fill")
                    .foregroundColor(index < gameState.attemptsLeft ? .gray : .red)
                    .font(.system(size: 20))
            }
        }
        .padding(.top, 8)
    }
    
    private var dishImage: some View {
        Group {
            if let image = UIImage(named: gameState.targetDish.image) {
                FlippableCardView(
                    frontImage: image,
                    foodFact: gameState.targetDish.food_fact,
                    cuisineColor: cuisineColor
                )
            }
        }
    }
    
    private var letterGrid: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: gameState.targetDish.name.count)
        
        return LazyVGrid(columns: columns, spacing: 8) {
            ForEach(0..<gameState.targetDish.name.count, id: \.self) { index in
                LetterContainer(
                    letter: getLetterForPosition(index: index),
                    state: getLetterState(index: index)
                )
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: 350, alignment: .center)
        .frame(maxWidth: .infinity)
    }
    
    private var keyboardView: some View {
        GameKeyboardView(
            onKeyTapped: { key in
                if gameState.currentGuess.count < gameState.targetDish.name.count {
                    gameState.currentGuess += key
                }
            },
            onDelete: {
                if !gameState.currentGuess.isEmpty {
                    gameState.currentGuess.removeLast()
                }
            },
            onSubmit: submitGuess,
            disabledKeys: disabledKeys,
            cuisineColor: cuisineColor
        )
    }
    
    private func getLetterForPosition(index: Int) -> String {
        // First check previous guesses for correct letters
        let targetWord = gameState.targetDish.name.uppercased()
        
        for guess in gameState.guesses {
            if index < guess.count {
                let guessLetter = guess[guess.index(guess.startIndex, offsetBy: index)].uppercased()
                let targetLetter = targetWord[targetWord.index(targetWord.startIndex, offsetBy: index)].uppercased()
                if guessLetter == targetLetter {
                    return guessLetter
                }
            }
        }
        
        // If no correct letter from previous guesses, show current guess letter
        if index < gameState.currentGuess.count {
            let guess = gameState.currentGuess
            return String(guess[guess.index(guess.startIndex, offsetBy: index)])
        }
        
        return ""  // Empty if no letter to show
    }
    
    private func getLetterState(index: Int) -> LetterState {
        let targetWord = gameState.targetDish.name.uppercased()
        
        if index < gameState.currentGuess.count {
            return .current
        }
        
        for guess in gameState.guesses {
            if index < guess.count {
                let guessLetter = guess[guess.index(guess.startIndex, offsetBy: index)].uppercased()
                let targetLetter = targetWord[targetWord.index(targetWord.startIndex, offsetBy: index)].uppercased()
                if guessLetter == targetLetter {
                    return .correctPosition
                }
            }
        }
        
        return .empty
    }
    
    private func submitGuess() {
        guard gameState.currentGuess.count == gameState.targetDish.name.count else {
            errorMessage = "Guess must be \(gameState.targetDish.name.count) letters"
            showError = true
            return
        }
        
        var newState = gameState
        newState.guesses.append(gameState.currentGuess)
        gameState = newState
        
        if gameState.currentGuess.uppercased() == gameState.targetDish.name.uppercased() {
            var newState = gameState
            newState.hasWon = true
            gameState = newState
            
            if gameState.currentLevel == gameState.allMeals.count - 1 {
                showGameComplete = true
            } else {
                showSuccess = true
            }
        } else {
            var newState = gameState
            newState.attemptsLeft -= 1
            gameState = newState
            
            if gameState.attemptsLeft == 0 {
                showGameOver = true
            } else {
                errorMessage = "Wrong guess! \(gameState.attemptsLeft) attempts left"
                showError = true
            }
        }
        
        // Update disabled keys
        updateDisabledKeys()
        
        // Reset current guess
        newState = gameState
        newState.currentGuess = ""
        gameState = newState
    }
    
    private func moveToNextLevel() {
        let nextLevel = gameState.currentLevel + 1
        gameState = GameState(meals: gameState.allMeals, startLevel: nextLevel)
        disabledKeys.removeAll()
    }
    
    private func resetGame() {
        gameState = GameState(meals: gameState.allMeals)
        disabledKeys.removeAll()
    }
    
    private func updateDisabledKeys() {
        let targetWord = gameState.targetDish.name.uppercased()
        let lastGuess = gameState.currentGuess.uppercased()
        
        for (index, letter) in lastGuess.enumerated() {
            let letterStr = String(letter)
            if !targetWord.contains(letter) {
                disabledKeys.insert(letterStr)
            }
        }
    }
}

enum LetterState {
    case empty
    case current
    case correctPosition
}

struct LetterContainer: View {
    let letter: String
    let state: LetterState
    
    var body: some View {
        VStack(spacing: 2) {
            Text(letter.uppercased())
                .font(.title2)
                .fontWeight(.bold)
                .frame(width: 40, height: 40)
                .opacity(state == .correctPosition ? 0.5 : 1.0)
            
            Rectangle()
                .fill(Color.gray)
                .frame(width: 30, height: 2)
        }
    }
}

enum LetterBoxState {
    case empty
    case wrong
    case wrongPosition
    case correct
}

struct LetterBox: View {
    let letter: String
    let state: LetterBoxState
    
    var backgroundColor: Color {
        switch state {
        case .empty: return .white
        case .wrong: return .gray
        case .wrongPosition: return .yellow
        case .correct: return .green
        }
    }
    
    var body: some View {
        Text(letter.uppercased())
            .font(.title2)
            .fontWeight(.bold)
            .frame(width: 45, height: 45)
            .background(backgroundColor)
            .foregroundColor(state == .empty ? .black : .white)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray, lineWidth: 2)
            )
    }
}

struct RulesView: View {
    let cuisineColor: Color
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("How to Play")
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 15) {
                    RuleRow(number: "1", text: "Guess the African or Caribbean dish name")
                    RuleRow(number: "2", text: "You have 3 attempts to guess correctly")
                    RuleRow(number: "3", text: "Correctly positioned letters will remain visible with reduced opacity")
                    RuleRow(number: "4", text: "Wrong letters will be disabled on the keyboard")
                    RuleRow(number: "5", text: "Tap the dish image to see interesting food facts")
                    RuleRow(number: "6", text: "X icons at the top show remaining attempts")
                    RuleRow(number: "7", text: "Use the hint button for clues about the dish")
                }
                .padding()
                
                Button("Start Playing") {
                    dismiss()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(cuisineColor)
                .cornerRadius(10)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RuleRow: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(number + ".")
                .font(.headline)
            Text(text)
                .font(.body)
        }
    }
}

// MARK: - Flippable Card View
struct FlippableCardView: View {
    let frontImage: UIImage
    let foodFact: String
    let cuisineColor: Color
    @State private var isFlipped = false
    
    var body: some View {
        ZStack {
            // Front of card (Image)
            Image(uiImage: frontImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 5)
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .opacity(isFlipped ? 0 : 1)
            
            // Back of card (Food Fact)
            RoundedRectangle(cornerRadius: 10)
                .fill(cuisineColor)
                .frame(width: 300, height: 250)
                .shadow(radius: 2)
                .overlay(
                    Text(foodFact)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(.white)
                )
                .rotation3DEffect(
                    .degrees(isFlipped ? 0 : -180),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .opacity(isFlipped ? 1 : 0)
        }
        .animation(.easeInOut(duration: 0.5), value: isFlipped)
        .onTapGesture {
            isFlipped.toggle()
        }
    }
} 

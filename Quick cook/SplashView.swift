import SwiftUI

struct SplashView: View {
    @AppStorage("shouldShowSplash") private var shouldShowSplash = true
    @State private var showOnboarding = false
    
    var body: some View {
        if !shouldShowSplash {
            ContentView()
        } else {
            VStack(spacing: 24) {
                // App Icon
                Image("appstore") // Make sure to add your app icon to assets
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(16)
                
                // Welcome Text
                VStack(spacing: 8) {
                    Text("Welcome to")
                        .font(.system(size: 36, weight: .bold))
                    Text("Quick Cook")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.accentColor)
                    
                    Text("Your fast meal assistant")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                }
                
                // Features List
                VStack(spacing: 32) {
                    FeatureRow(
                        icon: "globe",
                        title: "Explore Global Cuisine",
                        description: "Select a country and discover authentic dishes."
                    )

                    FeatureRow(
                        icon: "clock.fill",
                        title: "Cook Within Your Time",
                        description: "Choose recipes based on your available cooking time."
                    )

                    FeatureRow(
                        icon: "chart.bar.fill",
                        title: "Adjust Difficulty",
                        description: "Find recipes that match your skill level."
                    )
                }
                .padding(.vertical, 32)
                
                // Continue Button
                Button(action: {
                    showOnboarding = true
                }) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .sheet(isPresented: $showOnboarding) {
                    OnboardingView()
                        .onDisappear {
                            shouldShowSplash = false
                        }
                }
                
                // Made for Students Text
                Text("Made for Students and Beginners ❤️")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.accentColor)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                Text(description)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
} 

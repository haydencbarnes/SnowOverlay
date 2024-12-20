import SwiftUI

struct Snowflake: Identifiable {
    let id: UUID
    var startPosition: CGPoint
    var currentPosition: CGPoint
    let duration: Double
    let emoji: String
    var rotation: Double
    var scale: Double
    var opacity: Double
}

struct SnowView: View {
    @State private var snowflakes: [Snowflake] = []
    @State private var activeSnowflakes: Int
    let onComplete: () -> Void
    
    let winterEmojis = ["❄️", "🏂", "⛄️"]
    
    init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
        self._activeSnowflakes = State(initialValue: 0)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(snowflakes) { snowflake in
                    Text(snowflake.emoji)
                        .font(.system(size: snowflake.emoji == "❄️" ? 30 : 40))
                        .rotation3DEffect(
                            .degrees(snowflake.rotation),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .scaleEffect(snowflake.scale)
                        .opacity(snowflake.opacity)
                        .position(snowflake.currentPosition)
                        .modifier(SparkleModifier())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                let totalSnowflakes = 200
                self.activeSnowflakes = totalSnowflakes
                
                // Stagger the creation of snowflakes
                for index in 0..<totalSnowflakes {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                        let snowflake = createSnowflake(in: geometry.size)
                        snowflakes.append(snowflake)
                        animateSnowflake(snowflake, in: geometry.size)
                    }
                }
            }
        }
        .onChange(of: activeSnowflakes) { count in
            if count == 0 {
                onComplete()
            }
        }
    }

    private func createSnowflake(in size: CGSize) -> Snowflake {
        let startX = CGFloat.random(in: -100...size.width + 100)
        let startY = CGFloat.random(in: -200...0)
        
        let randomValue = Int.random(in: 0...100)
        let emoji: String
        if randomValue < 85 {
            emoji = winterEmojis[0]
        } else if randomValue < 93 {
            emoji = winterEmojis[1]
        } else {
            emoji = winterEmojis[2]
        }
        
        return Snowflake(
            id: UUID(),
            startPosition: CGPoint(x: startX, y: startY),
            currentPosition: CGPoint(x: startX, y: startY),
            duration: Double.random(in: 5...10),
            emoji: emoji,
            rotation: 0,
            scale: 0.1,
            opacity: 0
        )
    }

    private func animateSnowflake(_ snowflake: Snowflake, in size: CGSize) {
        if let index = snowflakes.firstIndex(where: { $0.id == snowflake.id }) {
            let horizontalMovement: CGFloat
            let rotations: Double
            
            switch snowflake.emoji {
            case "🏂":
                horizontalMovement = CGFloat.random(in: -300...300)
                rotations = Double.random(in: 0...180)
            case "⛄️":
                horizontalMovement = CGFloat.random(in: -50...50)
                rotations = Double.random(in: -45...45)
            default:
                horizontalMovement = CGFloat.random(in: -100...100)
                rotations = Double.random(in: 0...360)
            }
            
            // Entrance animation
            withAnimation(.easeIn(duration: 0.5)) {
                snowflakes[index].scale = 1.0
                snowflakes[index].opacity = 1.0
            }
            
            // Movement animation
            withAnimation(Animation.linear(duration: snowflake.duration)) {
                snowflakes[index].currentPosition = CGPoint(
                    x: snowflake.startPosition.x + horizontalMovement,
                    y: size.height + 200
                )
                snowflakes[index].rotation = rotations
            }
            
            // Add subtle continuous animations
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if let currentIndex = snowflakes.firstIndex(where: { $0.id == snowflake.id }) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        snowflakes[currentIndex].scale = CGFloat.random(in: 0.9...1.1)
                    }
                } else {
                    timer.invalidate()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + snowflake.duration) {
                activeSnowflakes -= 1
            }
        }
    }
}

// Sparkle modifier to add a twinkling effect
struct SparkleModifier: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .shadow(color: .white.opacity(isAnimating ? 0.5 : 0.2),
                   radius: isAnimating ? 10 : 5)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever()) {
                    isAnimating = true
                }
            }
    }
}

// Extension to create random colors for the sparkle effect
extension Color {
    static func random() -> Color {
        Color(
            red: Double.random(in: 0.5...1),
            green: Double.random(in: 0.5...1),
            blue: Double.random(in: 0.5...1)
        )
    }
}

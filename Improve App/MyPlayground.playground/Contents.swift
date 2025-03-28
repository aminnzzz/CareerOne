import SwiftUI

// MARK: Content unavailable

struct ContentView: View {
    var body: some View {
        ContentUnavailableView.search
    }
}

ContentUnavailableView("No Music", systemImage: "music.note.list")

ContentUnavailableView {
    Label("No notes", systemImage: "doc.text")
} description: {
    Text("You haven't created any notes yet.")
} actions: {
    Button {
        // create a new note
    } label: {
        Label("Create new note", systemImage: "plus")
    }
}

// MARK: Snap Scroll

ScrollView {
    VStack {
        ForEach(0..<100) { i in
            Text("Item \(i)")
                .frame(maxWidth: .infinity)
                .frame(height: 135)
                .background(.blue)
                .padding(.horizontal)
        }
    }
}
.scrollTargetBehavior(.paging)

ScrollView {
    VStack {
        ForEach(0..<100) { i in
            Text("Item \(i)")
                .frame(maxWidth: .infinity)
                .frame(height: 135)
                .background(.blue)
                .padding(.horizontal)
        }
    }
    .scrollTargetLayout()
}
.scrollTargetBehavior(.viewAligned)

// MARK: Adjusting margins

List {
    Section {
        RoundedRectangle(cornerRadius: 25)
            .fill(.indigo)
            .frame(height: 200)
            .listRowBackground(Color.clear)
            .listRowInsets(.init())
    }

    ForEach(1..<101) { i in
        Text("Row \(i)")
    }
}
.contentMargins(.top, 260, for: .scrollIndicators)

ScrollView(.horizontal, showsIndicators: false) {
    // current code
}
.contentMargins(40, for: .scrollContent)

// MARK: Container relative frame sizes

ScrollView(.horizontal, showsIndicators: false) {
    HStack(spacing: 10) {
        ForEach(1..<11) { i in
            RoundedRectangle(cornerRadius: 20)
                .fill(.mint)
                .frame(height: 200)
                .containerRelativeFrame(.horizontal, count: 3, span: 2, spacing: 10)
        }
    }
}

ScrollView(.horizontal, showsIndicators: false) {
    HStack(spacing: 10) {
        ForEach(1..<11) { i in
            RoundedRectangle(cornerRadius: 20)
                .fill(.mint)
                .frame(height: 200)
                .containerRelativeFrame(.horizontal)
        }
    }
}
.contentMargins(.horizontal, 40, for: .scrollContent)

// MARK: Custom scroll transitions

ScrollView {
    VStack {
        ForEach(1..<11) { i in
            RoundedRectangle(cornerRadius: 20)
                .fill(.indigo.gradient)
                .frame(height: 200)
                .scrollTransition { content, phase in
                    content
                        .scaleEffect(phase == .topLeading ? 0.8 : 1)
                }
        }
    }
}

ScrollView {
    ForEach(0..<20) { i in
        RoundedRectangle(cornerRadius: 25)
            .fill(.blue)
            .frame(height: 200)
        //.scrollTransition(.interactive.threshold(.visible(0.1))) { content, phase in
            .scrollTransition(topLeading: .identity, bottomTrailing: .animated(.spring(duration: 1, bounce: 0.7))) { content, phase in
                content
                    .offset(x: phase == .topLeading ? 100 : 0)
                    .opacity(phase == .topLeading ? 0 : 2)
            }
    }
}

// MARK: Scroll flashing indicators

ScrollView {
    ForEach(0..<20) { i in
        RoundedRectangle(cornerRadius: 25)
            .fill(.blue)
            .frame(height: 200)
    }
}
.scrollIndicatorsFlash(onAppear: true)
//.scrollIndicatorsFlash(trigger: flashNow)

// MARK: Adding sensory feedback

struct ContentView2: View {
    @State private var triggerEffect = false

    var body: some View {
        Button("Hit Me!") {
            triggerEffect.toggle()
        }
        .sensoryFeedback(.impact, trigger: triggerEffect)
    }
}

// MARK: Symbol effects

struct ContentView3: View {
    @State private var completionCount = 0

    var body: some View {
        Button {
            completionCount += 1
        } label: {
            Label("Times Completed: \(completionCount)", systemImage: "checkmark.rectangle.stack.fill")
        }
        .symbolEffect(.bounce, value: completionCount)
        //.bounce.down.wholeSymbol.
        //.symbolEffect(.bounce, options: .repeat(3).speed(0.1), value: completionCount)
        .font(.largeTitle)
    }
}
struct ContentView4: View {
    @State private var triggerAnimation = false

    var body: some View {
        Button {
            triggerAnimation.toggle()
        } label: {
            Label("Taste the Rainbow!", systemImage: "rainbow")
        }
        .symbolRenderingMode(.multicolor)
        .symbolEffect(.variableColor, value: triggerAnimation)
        //.variableColor.hideInactiveLayers
        //.variableColor.iterative
        //.variableColor.reversing
        //.variableColor.iterative.reversing.hideInactiveLayers
        .font(.largeTitle)
    }
}

// MARK: Phase animators

Image(systemName: "heart")
    .symbolVariant(.fill)
    .foregroundStyle(.red)
    .font(.largeTitle)
    .phaseAnimator([true, false]) { content, phase in
        content
            .scaleEffect(phase ? 2 : 1)
    }

Image(systemName: "heart")
    .symbolVariant(.fill)
    .foregroundStyle(.red)
    .font(.largeTitle)
    .phaseAnimator([true, false]) { content, phase in
        content
            .scaleEffect(phase ? 2 : 1)
    } animation: { phase in
        if phase {
            .easeIn
        } else {
            .snappy
        }
    }

enum AnimationPhases: CaseIterable {
    case start, movingUp, scalingUp, movingDown
}

struct ContentView5: View {
    @State private var isLiked = false

    var body: some View {
        Button {
            isLiked.toggle()
        } label: {
            Image(systemName: "heart")
                .symbolVariant(isLiked ? .fill : .none)
        }
        .foregroundStyle(.red)
        .font(.largeTitle)
        .phaseAnimator(isLiked ? AnimationPhases.allCases : [.start], trigger: isLiked) { content, phase in
            content
                .scaleEffect(phase == .scalingUp ? 2 : 1)
                .offset(y: phase != .start ? -50 : 0)
        }
    }
}

// MARK: Visual effect

ScrollView {
    ForEach(0..<100) { i in
        Text("This is an example text message bubble.")
            .padding(8)
            .foregroundStyle(.white)
            .background(.blue.gradient)
            .clipShape(.capsule)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .visualEffect { content, proxy in
                content.hueRotation(-.degrees(proxy.frame(in: .global).minY / 40))
            }
    }
}
.contentMargins(.trailing, 10, for: .scrollContent)

struct ContentView6: View {
    @State private var size = 50.0

    var body: some View {
        Circle()
            .fill(.red)
            .frame(width: size, height: size)
            .visualEffect { content, proxy in
                content.hueRotation(-.degrees(proxy.frame(in: .global).width) / 2)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                    size = 350
                }
            }
    }
}

import SwiftUI
import FamilyControls

@main
struct BePresentApp: App {
    @StateObject private var controller = FocusController()
    @AppStorage("hasEntered") private var hasEntered = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            Group {
                if hasEntered { HomeView(controller: controller) }
                else { WelcomeView { withAnimation { hasEntered = true } } }
            }
            .preferredColorScheme(hasEntered ? .light : .dark)
            .tint(Brand.blue)
            .onChange(of: scenePhase) { _, phase in
                if phase == .active { controller.refreshAuthorization() }
            }
        }
    }
}

enum Brand {
    static let blue = Color(red: 0.09, green: 0.21, blue: 0.96)
    static let ink = Color(red: 0.08, green: 0.12, blue: 0.25)
    static let muted = Color(red: 0.40, green: 0.44, blue: 0.56)
    static let background = Color(red: 0.96, green: 0.97, blue: 1)
}

struct Wordmark: View {
    var size: CGFloat = 37
    var body: some View {
        VStack(alignment: .leading, spacing: -size * 0.30) {
            Text("be")
            Text("present")
        }
            .font(.system(size: size, weight: .heavy, design: .rounded))
            .tracking(-size * 0.05)
            .fixedSize()
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("BePresent")
    }
}

struct DeviceArtwork: View {
    var compact = false
    var body: some View {
        ZStack {
            ForEach(0..<3) { ring in
                Circle().stroke(Brand.blue.opacity(0.07), lineWidth: 1)
                    .frame(width: CGFloat(190 + ring * 55), height: CGFloat(190 + ring * 55))
            }
            RoundedRectangle(cornerRadius: 43, style: .continuous)
                .fill(LinearGradient(colors: [Color(red: 0.25, green: 0.39, blue: 1), Brand.blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay {
                    RoundedRectangle(cornerRadius: 43).strokeBorder(.white.opacity(0.35), lineWidth: 2)
                }
                .overlay { Wordmark(size: 42).foregroundStyle(.white) }
                .frame(width: 177, height: 177)
                .rotationEffect(.degrees(-9))
                .shadow(color: Brand.blue.opacity(0.24), radius: 25, x: 0, y: 17)
            Image(systemName: "wave.3.right")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(Brand.blue)
                .padding(16).background(.white, in: Circle())
                .offset(x: 90, y: 70)
        }
        .frame(height: compact ? 235 : 290)
        .accessibilityHidden(true)
    }
}

struct PrimaryButton: View {
    let title: String
    var icon = "arrow.right"
    var inverted = false
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(title).font(.system(.headline, design: .rounded))
                Spacer()
                Image(systemName: icon).font(.headline)
            }
            .padding(21)
            .foregroundStyle(inverted ? Brand.blue : .white)
            .background(inverted ? .white : Brand.blue, in: RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
    }
}

struct WelcomeView: View {
    var enter: () -> Void
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    HStack(alignment: .top) {
                        Wordmark().foregroundStyle(.white)
                        Spacer()
                        Text("LESS SCROLL.\nMORE LIFE.")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .tracking(2).lineSpacing(5).foregroundStyle(.white.opacity(0.75))
                            .padding(.top, 8)
                    }
                    Spacer(minLength: 12)
                    ZStack {
                        Circle().stroke(.white.opacity(0.12), lineWidth: 1).frame(width: 290, height: 290)
                        Circle().stroke(.white.opacity(0.12), lineWidth: 1).frame(width: 235, height: 235)
                        RoundedRectangle(cornerRadius: 42)
                            .fill(.white.opacity(0.13))
                            .overlay { RoundedRectangle(cornerRadius: 42).stroke(.white.opacity(0.4), lineWidth: 1.5) }
                            .frame(width: 175, height: 175)
                            .rotationEffect(.degrees(-10))
                            .overlay { Wordmark(size: 43).foregroundStyle(.white).rotationEffect(.degrees(-10)) }
                            .shadow(color: .black.opacity(0.15), radius: 20, y: 20)
                        Image(systemName: "wave.3.right")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(Brand.blue).padding(17)
                            .background(.white, in: Circle()).offset(x: 91, y: 72)
                    }
                    .frame(maxWidth: .infinity).frame(height: 290).accessibilityHidden(true)
                    Spacer(minLength: 0)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your time.\nBack in your hands.")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .tracking(-1.5).foregroundStyle(.white)
                            .minimumScaleFactor(0.75)
                        Text("One tap to disconnect from your apps.\nA little more room for everything else.")
                            .font(.system(size: 16)).lineSpacing(5).foregroundStyle(.white.opacity(0.8))
                    }
                    PrimaryButton(title: "Get started", inverted: true, action: enter)
                    Text("NO ACCOUNT. JUST YOU, PRESENT.")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(1.7).foregroundStyle(.white.opacity(0.65))
                        .frame(maxWidth: .infinity)
                }
                .padding(28)
                .frame(minHeight: geometry.size.height)
            }
            .background(LinearGradient(colors: [Color(red: 0.20, green: 0.32, blue: 1), Brand.blue, Color(red: 0.07, green: 0.17, blue: 0.83)], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea())
        }
    }
}

struct HomeView: View {
    @ObservedObject var controller: FocusController
    @State private var showPicker = false
    private var active: Bool { controller.session.isBlocking }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                HStack {
                    Wordmark(size: 29).foregroundStyle(Brand.blue)
                    Spacer()
                    HStack(spacing: 6) {
                        Circle().fill(Brand.blue).frame(width: 6, height: 6)
                        Text(active ? "FOCUS SESSION" : "A FRESH START")
                            .font(.system(size: 9, weight: .bold, design: .monospaced)).tracking(1)
                    }
                    .foregroundStyle(Brand.blue).padding(12)
                    .background(Brand.blue.opacity(0.07), in: Capsule())
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(active ? "Welcome to the now." : "Make room for real life.")
                        .font(.system(size: 31, weight: .bold, design: .rounded)).tracking(-1)
                    Text(active ? "Your phone can wait. This moment is yours." : "Put distractions down. Pick your day up.")
                        .font(.subheadline).foregroundStyle(Brand.muted)
                }
                VStack(spacing: 10) {
                    DeviceArtwork(compact: true)
                    Label(active ? (controller.authorized ? "You’re being present" : "Screen Time access needed") : "Ready when you are", systemImage: active ? "lock.fill" : "sparkles")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                    if let started = controller.session.startedAt {
                        Text(started, style: .timer)
                            .font(.system(size: 34, weight: .medium, design: .rounded)).monospacedDigit()
                            .foregroundStyle(Brand.blue)
                            .accessibilityLabel("Session duration")
                    }
                    Text(active ? "Scan your paired device again to unlock." : "A small tap. A little distance. A clearer mind.")
                        .font(.system(size: 13)).foregroundStyle(Brand.muted)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity).padding(.bottom, 24)
                .background(.white, in: RoundedRectangle(cornerRadius: 28))

                Button { showPicker = true } label: {
                    HStack(spacing: 14) {
                        Image(systemName: active ? "lock.shield" : "square.grid.2x2")
                            .font(.system(size: 21)).foregroundStyle(Brand.blue)
                            .frame(width: 48, height: 48)
                            .background(Brand.blue.opacity(0.07), in: RoundedRectangle(cornerRadius: 14))
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Your distractions").font(.system(.headline, design: .rounded))
                            Text(controller.selectionCount == 0 ? "Choose apps & websites to block" : "\(controller.selectionCount) selections · \(active ? "locked for this session" : "tap to edit")")
                                .font(.caption).foregroundStyle(Brand.muted)
                        }
                        Spacer(minLength: 0)
                        Image(systemName: active ? "lock.fill" : "chevron.right").font(.caption).foregroundStyle(Brand.muted)
                    }
                    .padding(16).background(.white, in: RoundedRectangle(cornerRadius: 22))
                }
                .buttonStyle(.plain).disabled(active || !controller.authorized || controller.busy)

                VStack(spacing: 14) {
                    if !controller.authorized {
                        PrimaryButton(title: controller.busy ? "Connecting…" : "Enable Screen Time", icon: "checkmark.shield") {
                            Task { await controller.requestAccess() }
                        }.disabled(controller.busy)
                        Text("Allow access, choose your distractions, then scan your device.")
                            .font(.caption).foregroundStyle(Brand.muted).multilineTextAlignment(.center)
                    } else {
                        PrimaryButton(title: controller.busy ? "Scanning…" : (active ? "Scan to unlock" : "Scan to be present"), icon: "wave.3.right") {
                            controller.scan()
                        }.disabled(controller.busy || (!active && controller.selectionCount == 0))
                            .opacity(!active && controller.selectionCount == 0 ? 0.5 : 1)
                        Text(active ? "Your paired device is your way back in." : (controller.session.pairedTag == nil ? "Your first scan pairs your device and starts a session." : "Hold the top of your iPhone near your paired device."))
                            .font(.caption).foregroundStyle(Brand.muted).multilineTextAlignment(.center)
                    }
                }
                HStack(spacing: 8) {
                    Rectangle().fill(Brand.blue.opacity(0.1)).frame(height: 1)
                    Text("BE HERE. BE PRESENT.").font(.system(size: 9, weight: .medium, design: .monospaced)).tracking(1.5).fixedSize()
                    Rectangle().fill(Brand.blue.opacity(0.1)).frame(height: 1)
                }.foregroundStyle(Brand.muted).padding(.top, 3)
            }
            .padding(24)
        }
        .foregroundStyle(Brand.ink)
        .background(Brand.background.ignoresSafeArea())
        .familyActivityPicker(isPresented: $showPicker, selection: $controller.selection)
        .onChange(of: controller.selection) { _, _ in controller.saveSelection() }
        .alert("Let’s try that again", isPresented: Binding(get: { controller.errorMessage != nil }, set: { if !$0 { controller.errorMessage = nil } })) {
            Button("OK", role: .cancel) { controller.errorMessage = nil }
        } message: { Text(controller.errorMessage ?? "") }
    }
}

#Preview("Welcome") { WelcomeView {} }
#Preview("Home") { HomeView(controller: FocusController()) }

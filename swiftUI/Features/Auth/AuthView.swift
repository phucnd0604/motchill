import Observation
import SwiftUI

struct AuthView: View {
    @Bindable var authManager: PhucTvSupabaseAuthManager
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var isBusy = false
    @State private var feedbackMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                AuthBackground()

                ScrollView {
                    VStack(spacing: 24) {
                        brandHeader
                        authCard
                    }
                    .frame(maxWidth: 560)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 28)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Đóng") { dismiss() }
                        .foregroundStyle(.white)
                }
            }
        }
        .presentationDetents([.large])
        .presentationCornerRadius(28)
    }

    private var brandHeader: some View {
        VStack(spacing: 10) {
            Text("PHUCTV")
                .font(.system(size: 30, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .tracking(2)

            Text("Welcome Back")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text("Nhập email, nhận magic link và mở app ngay. Không cần mật khẩu.")
                .font(.body)
                .foregroundStyle(.white.opacity(0.72))
                .multilineTextAlignment(.center)
                .frame(maxWidth: 360)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 6)
    }

    private var authCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            emailField
            sendButton
            footerNote
        }
        .padding(22)
        .background(cardBackground)
        .overlay(cardBorder)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.34), radius: 34, x: 0, y: 24)
    }

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("EMAIL ADDRESS")
                .font(.caption.weight(.bold))
                .tracking(1.6)
                .foregroundStyle(.white.opacity(0.55))

            HStack(spacing: 12) {
                Image(systemName: "envelope.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.48))
                    .frame(width: 18)

                TextField("name@example.com", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(.white.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(.white.opacity(0.12), lineWidth: 1)
            )
        }
    }

    private var sendButton: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                Task { await submit() }
            } label: {
                HStack(spacing: 10) {
                    if isBusy {
                        ProgressView()
                            .tint(.black)
                    }
                    Text("Send Magic Link")
                        .font(.headline.weight(.semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [Color(red: 1.0, green: 0.78, blue: 0.73), Color(red: 1.0, green: 0.15, blue: 0.16)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)
            .foregroundStyle(.black)
            .shadow(color: Color.red.opacity(0.25), radius: 18, x: 0, y: 10)
            .disabled(isBusy || !canSubmit)

            if let feedbackMessage {
                Text(feedbackMessage)
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.top, 2)
    }

    private var footerNote: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("How it works")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)

            Text("1. Enter your email")
            Text("2. Supabase sends a secure magic link")
            Text("3. Tap the link to open PhucTv and sign in")
        }
        .font(.footnote)
        .foregroundStyle(.white.opacity(0.58))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 2)
    }

    private var canSubmit: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func submit() async {
        guard canSubmit else { return }
        isBusy = true
        feedbackMessage = nil
        defer { isBusy = false }

        do {
            let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
            try await authManager.sendMagicLink(email: trimmedEmail)
            feedbackMessage = "Magic link đã được gửi. Kiểm tra email để mở app."
        } catch {
            feedbackMessage = error.localizedDescription
        }
    }
}

private struct AuthBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.11, green: 0.08, blue: 0.12),
                    Color(red: 0.04, green: 0.06, blue: 0.09)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.red.opacity(0.22))
                .frame(width: 260, height: 260)
                .blur(radius: 50)
                .offset(x: -150, y: -220)

            Circle()
                .fill(Color.white.opacity(0.07))
                .frame(width: 180, height: 180)
                .blur(radius: 42)
                .offset(x: 130, y: -160)

            RoundedRectangle(cornerRadius: 220, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.red.opacity(0.16),
                            Color.clear,
                            Color.red.opacity(0.12)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 420, height: 560)
                .blur(radius: 46)
                .rotationEffect(.degrees(-18))
                .offset(x: 150, y: 260)
        }
    }
}

private extension Color {
    static let authCardFill = Color(red: 0.08, green: 0.09, blue: 0.12).opacity(0.92)
}

private var cardBackground: some ShapeStyle {
    LinearGradient(
        colors: [
            Color.white.opacity(0.08),
            Color.authCardFill,
            Color.black.opacity(0.72)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

private var cardBorder: some View {
    RoundedRectangle(cornerRadius: 28, style: .continuous)
        .strokeBorder(
            LinearGradient(
                colors: [
                    Color.white.opacity(0.18),
                    Color.white.opacity(0.05),
                    Color.white.opacity(0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            lineWidth: 1
        )
}

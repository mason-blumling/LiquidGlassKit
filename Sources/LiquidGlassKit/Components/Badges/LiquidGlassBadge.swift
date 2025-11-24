//
//  LiquidGlassBadge.swift
//  LiquidGlassKit
//
//  Created by Mason Blumling on 11/23/25.
//

import SwiftUI

/// A badge component with Liquid Glass styling.
///
/// `LiquidGlassBadge` displays a small piece of information (text, icon, or both)
/// on a Liquid Glass surface. Badges are ideal for status indicators, counts,
/// or supplementary labels that float above content.
///
/// Example:
/// ```swift
/// LiquidGlassBadge("5", systemImage: "star.fill")
///     .tint(.yellow)
///
/// LiquidGlassBadge("New")
///     .controlSize(.small)
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassBadge: View {
    private let text: String?
    private let systemImage: String?
    private let configuration: GlassConfiguration

    @Environment(\.defaultGlassMaterial) private var defaultMaterial
    @Environment(\.defaultGlassControlSize) private var defaultControlSize
    @Environment(\.defaultGlassIsInteractive) private var defaultIsInteractive

    private var controlSize: GlassControlSize = .small

    /// Creates a badge with text only.
    /// - Parameters:
    ///   - text: The text to display
    ///   - configuration: The glass configuration (default: `.default`)
    public init(
        _ text: String,
        configuration: GlassConfiguration = .default
    ) {
        self.text = text
        self.systemImage = nil
        self.configuration = configuration
    }

    /// Creates a badge with an icon only.
    /// - Parameters:
    ///   - systemImage: SF Symbol name
    ///   - configuration: The glass configuration (default: `.default`)
    public init(
        systemImage: String,
        configuration: GlassConfiguration = .default
    ) {
        self.text = nil
        self.systemImage = systemImage
        self.configuration = configuration
    }

    /// Creates a badge with both text and icon.
    /// - Parameters:
    ///   - text: The text to display
    ///   - systemImage: SF Symbol name
    ///   - configuration: The glass configuration (default: `.default`)
    public init(
        _ text: String,
        systemImage: String,
        configuration: GlassConfiguration = .default
    ) {
        self.text = text
        self.systemImage = systemImage
        self.configuration = configuration
    }

    public var body: some View {
        HStack(spacing: 4) {
            if let systemImage = systemImage {
                Image(systemName: systemImage)
                    .imageScale(.small)
            }

            if let text = text {
                Text(text)
                    .font(.caption)
                    .fontWeight(.medium)
            }
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .liquidGlassBackground(configuration)
    }

    private var horizontalPadding: CGFloat {
        switch controlSize {
        case .mini: return 6
        case .small: return 8
        case .regular: return 10
        case .large: return 12
        case .extraLarge: return 14
        }
    }

    private var verticalPadding: CGFloat {
        switch controlSize {
        case .mini: return 2
        case .small: return 4
        case .regular: return 6
        case .large: return 8
        case .extraLarge: return 10
        }
    }

    /// Sets the control size for this badge.
    /// - Parameter size: The desired control size
    /// - Returns: A badge with the specified size
    public func controlSize(_ size: GlassControlSize) -> Self {
        var copy = self
        copy.controlSize = size
        return copy
    }
}

/// A badge component specifically designed for use in grouped/morphing contexts.
///
/// Use this variant when you need to animate badges within a `LiquidGlassBadgeStack`
/// or other container that uses `GlassEffectContainer` for morphing effects.
@available(iOS 26.0, macOS 26.0, *)
public struct GroupableLiquidGlassBadge: View {
    private let text: String?
    private let systemImage: String?
    private let configuration: GlassConfiguration
    private let id: String  // Changed from AnyHashable to String for Sendable

    @Environment(\.glassEffectNamespace) private var namespace

    /// Creates a groupable badge with text only.
    /// - Parameters:
    ///   - text: The text to display
    ///   - id: Unique identifier for glass morphing
    ///   - configuration: The glass configuration
    public init(
        _ text: String,
        id: String,  // Changed from AnyHashable to String
        configuration: GlassConfiguration = .default
    ) {
        self.text = text
        self.systemImage = nil
        self.id = id
        self.configuration = configuration
    }

    /// Creates a groupable badge with both text and icon.
    /// - Parameters:
    ///   - text: The text to display
    ///   - systemImage: SF Symbol name
    ///   - id: Unique identifier for glass morphing
    ///   - configuration: The glass configuration
    public init(
        _ text: String,
        systemImage: String,
        id: String,  // Changed from AnyHashable to String
        configuration: GlassConfiguration = .default
    ) {
        self.text = text
        self.systemImage = systemImage
        self.id = id
        self.configuration = configuration
    }

    public var body: some View {
        HStack(spacing: 4) {
            if let systemImage = systemImage {
                Image(systemName: systemImage)
                    .imageScale(.small)
            }

            if let text = text {
                Text(text)
                    .font(.caption)
                    .fontWeight(.medium)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .liquidGlassBackground(configuration)
        .liquidGlassGrouped(id: id, in: namespace)
    }
}

// MARK: - Environment Key for Namespace

@available(iOS 26.0, macOS 26.0, *)
private struct GlassEffectNamespaceKey: EnvironmentKey {
    static let defaultValue: Namespace.ID? = nil
}

@available(iOS 26.0, macOS 26.0, *)
extension EnvironmentValues {
    var glassEffectNamespace: Namespace.ID {
        get { self[GlassEffectNamespaceKey.self] ?? Namespace().wrappedValue }
        set { self[GlassEffectNamespaceKey.self] = newValue }
    }
}

// MARK: - Previews

#Preview("Badge Variants") {
    VStack(spacing: 20) {
        // Notification count
        HStack {
            Text("Messages")
                .font(.headline)
            LiquidGlassBadge("12")
                .tint(.red)
        }

        // Status labels
        HStack(spacing: 12) {
            LiquidGlassBadge("New")
                .tint(.blue)

            LiquidGlassBadge("Sale")
                .tint(.orange)

            LiquidGlassBadge("Featured", systemImage: "star.fill")
                .tint(.yellow)
        }

        // Rating badge
        LiquidGlassBadge("4.9★", systemImage: "heart.fill")
            .tint(.red)

        // Icon-only badges
        HStack(spacing: 8) {
            LiquidGlassBadge(systemImage: "checkmark.seal.fill")
                .tint(.blue)

            LiquidGlassBadge(systemImage: "crown.fill")
                .tint(.yellow)
        }
    }
    .padding()
}

#Preview("Badge Sizes", traits: .sizeThatFitsLayout) {
    VStack(spacing: 12) {
        LiquidGlassBadge("Mini", systemImage: "star.fill")
            .controlSize(.mini)

        LiquidGlassBadge("Small", systemImage: "star.fill")
            .controlSize(.small)

        LiquidGlassBadge("Regular", systemImage: "star.fill")
            .controlSize(.regular)
    }
    .padding()
}

#Preview("Badges on Content") {
    ScrollView {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(0..<6) { index in
                RoundedRectangle(cornerRadius: 12)
                    .fill(.blue.opacity(0.2))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(alignment: .topTrailing) {
                        if index % 2 == 0 {
                            LiquidGlassBadge("New", systemImage: "sparkles")
                                .tint(.purple)
                                .padding(8)
                        } else if index % 3 == 0 {
                            LiquidGlassBadge("\(index)", systemImage: "star.fill")
                                .tint(.yellow)
                                .padding(8)
                        }
                    }
            }
        }
        .padding()
    }
    .frame(height: 400)
}

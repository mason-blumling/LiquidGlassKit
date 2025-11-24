//
//  LiquidGlassBadgeStack.swift
//  LiquidGlassKit
//
//  Created by Mason Blumling on 11/23/25.
//

import SwiftUI

/// A container for badge clusters that supports morphing and melding animations.
///
/// `LiquidGlassBadgeStack` uses `GlassEffectContainer` to coordinate glass effects
/// across multiple badges, allowing them to smoothly morph together or separate
/// with fluid animations.
///
/// This component demonstrates the power of Liquid Glass's grouping and morphing
/// capabilities, as shown in Apple's Landmarks sample.
///
/// Example:
/// ```swift
/// @Namespace var badgeNamespace
/// @State private var showDetails = false
///
/// LiquidGlassBadgeStack(namespace: badgeNamespace) {
///     Badge("New", id: "new")
///
///     if showDetails {
///         Badge("5 items", id: "count")
///         Badge("Updated", id: "status")
///     }
/// }
/// .animation(.smooth, value: showDetails)
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassBadgeStack<Content: View>: View {
    private let content: Content
    private let namespace: Namespace.ID
    private var spacing: CGFloat = 8
    private var useGlassEffectContainer: Bool = true

    /// Creates a badge stack with morphing support.
    /// - Parameters:
    ///   - namespace: The namespace for coordinating glass effects
    ///   - spacing: The spacing between badges
    ///   - content: A view builder for the badges
    public init(
        namespace: Namespace.ID,
        spacing: CGFloat = 8,
        @ViewBuilder content: () -> Content
    ) {
        self.namespace = namespace
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        if useGlassEffectContainer {
            GlassEffectContainer(spacing: spacing) {
                content
                    .environment(\.glassEffectNamespace, namespace)
            }
        } else {
            HStack(spacing: spacing) {
                content
                    .environment(\.glassEffectNamespace, namespace)
            }
        }
    }

    /// Sets whether to use GlassEffectContainer for morphing.
    ///
    /// When enabled (default), badges will morph smoothly. When disabled,
    /// badges will animate independently.
    ///
    /// - Parameter enabled: Whether to enable container-based morphing
    /// - Returns: A badge stack with updated morphing behavior
    public func glassMorphing(_ enabled: Bool) -> Self {
        var copy = self
        copy.useGlassEffectContainer = enabled
        return copy
    }
}

/// A badge cluster that demonstrates union-based morphing.
///
/// This component shows how to use `glassEffectUnion` to merge multiple
/// glass surfaces into a unified sampling region for more cohesive animations.
///
/// Example:
/// ```swift
/// @Namespace var namespace
/// @State private var isMerged = false
///
/// LiquidGlassBadgeCluster(
///     namespace: namespace,
///     unionID: "badge-group",
///     isMerged: isMerged
/// ) {
///     Badge("3", systemImage: "star.fill", id: "stars")
///     Badge("12", systemImage: "heart.fill", id: "likes")
/// }
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassBadgeCluster<Content: View>: View {
    private let content: Content
    private let namespace: Namespace.ID
    private let unionID: String  // Changed from AnyHashable to String for Sendable
    private let isMerged: Bool
    private var spacing: CGFloat = 4

    /// Creates a badge cluster with union-based morphing.
    /// - Parameters:
    ///   - namespace: The namespace for glass effects
    ///   - unionID: Identifier for the glass union
    ///   - isMerged: Whether badges should merge into one glass surface
    ///   - spacing: Spacing between badges (when not merged)
    ///   - content: A view builder for the badges
    public init(
        namespace: Namespace.ID,
        unionID: String,  // Changed from AnyHashable to String
        isMerged: Bool,
        spacing: CGFloat = 4,
        @ViewBuilder content: () -> Content
    ) {
        self.namespace = namespace
        self.unionID = unionID
        self.isMerged = isMerged
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        GlassEffectContainer(spacing: isMerged ? 0 : spacing) {
            content
                .environment(\.glassEffectNamespace, namespace)
                .glassEffectUnion(id: unionID, namespace: namespace)
        }
        .glassEffectTransition(.identity)
    }
}

/// A morphing badge that can transition between different states.
///
/// Use this for badges that change their content or appearance with animation,
/// such as a notification count that updates or a status indicator that changes.
///
/// Example:
/// ```swift
/// @Namespace var namespace
/// @State private var count = 5
///
/// MorphingBadge(
///     text: "\(count)",
///     systemImage: "bell.fill",
///     id: "notifications",
///     namespace: namespace
/// )
/// .animation(.smooth, value: count)
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct MorphingBadge: View {
    private let text: String
    private let systemImage: String?
    private let id: String  // Changed from AnyHashable to String
    private let namespace: Namespace.ID
    private let configuration: GlassConfiguration

    @State private var isVisible = true

    /// Creates a morphing badge.
    /// - Parameters:
    ///   - text: The text to display
    ///   - systemImage: Optional SF Symbol name
    ///   - id: Unique identifier for glass morphing
    ///   - namespace: The namespace for glass effects
    ///   - configuration: The glass configuration
    public init(
        text: String,
        systemImage: String? = nil,
        id: String,  // Changed from AnyHashable to String
        namespace: Namespace.ID,
        configuration: GlassConfiguration = .default
    ) {
        self.text = text
        self.systemImage = systemImage
        self.id = id
        self.namespace = namespace
        self.configuration = configuration
    }

    public var body: some View {
        HStack(spacing: 4) {
            if let systemImage = systemImage {
                Image(systemName: systemImage)
                    .imageScale(.small)
            }

            Text(text)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .liquidGlassBackground(configuration)
        .glassEffectID(id, in: namespace)
        .glassEffectTransition(.identity)
        .transition(.scale.combined(with: .opacity))
    }
}

// MARK: - Badge Builder

/// A result builder for constructing badge collections.
@available(iOS 26.0, macOS 26.0, *)
@resultBuilder
public struct BadgeBuilder {
    public static func buildBlock<Content: View>(_ content: Content) -> Content {
        content
    }

    public static func buildOptional<Content: View>(_ content: Content?) -> Content? {
        content
    }

    public static func buildEither<TrueContent: View, FalseContent: View>(
        first: TrueContent
    ) -> _ConditionalContent<TrueContent, FalseContent> {
        ViewBuilder.buildEither(first: first)
    }

    public static func buildEither<TrueContent: View, FalseContent: View>(
        second: FalseContent
    ) -> _ConditionalContent<TrueContent, FalseContent> {
        ViewBuilder.buildEither(second: second)
    }
}

// MARK: - Environment Extension
// Note: GlassEffectNamespaceKey and glassEffectNamespace extension are defined in LiquidGlassBadge.swift

// MARK: - Previews

#Preview("Morphing Badge Stack") {
    @Previewable @Namespace var namespace
    @Previewable @State var showDetails = false

    VStack(spacing: 30) {
        // Product card with expandable badges
        VStack(alignment: .leading, spacing: 12) {
            Text("Premium Headphones")
                .font(.title2)
                .fontWeight(.semibold)

            LiquidGlassBadgeStack(namespace: namespace, spacing: 8) {
                GroupableLiquidGlassBadge("Featured", systemImage: "star.fill", id: "featured")
                    .tint(.yellow)

                if showDetails {
                    GroupableLiquidGlassBadge("4.9★", systemImage: "heart.fill", id: "rating")
                        .tint(.red)

                    GroupableLiquidGlassBadge("1,234 sold", id: "sold")
                }
            }
            .animation(.smooth, value: showDetails)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))

        // Toggle button
        Button {
            showDetails.toggle()
        } label: {
            Label(showDetails ? "Hide Details" : "Show Details", systemImage: showDetails ? "chevron.up" : "chevron.down")
        }
        .buttonStyle(.bordered)
    }
    .padding()
}

#Preview("Dynamic Badge List") {
    @Previewable @Namespace var namespace
    @Previewable @State var selectedFilters: Set<String> = ["All"]

    let availableFilters = ["All", "Photos", "Videos", "Live", "Favorites"]

    VStack(spacing: 20) {
        Text("Gallery Filters")
            .font(.headline)

        LiquidGlassBadgeStack(namespace: namespace, spacing: 10) {
            ForEach(selectedFilters.sorted(), id: \.self) { filter in
                GroupableLiquidGlassBadge(filter, systemImage: "checkmark", id: filter)
                    .tint(filter == "All" ? .blue : .purple)
            }
        }
        .animation(.smooth, value: selectedFilters)

        // Filter buttons
        VStack(spacing: 8) {
            ForEach(availableFilters, id: \.self) { filter in
                Button {
                    if selectedFilters.contains(filter) {
                        selectedFilters.remove(filter)
                    } else {
                        selectedFilters.insert(filter)
                    }
                } label: {
                    Text(selectedFilters.contains(filter) ? "Remove \(filter)" : "Add \(filter)")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
    }
    .padding()
}

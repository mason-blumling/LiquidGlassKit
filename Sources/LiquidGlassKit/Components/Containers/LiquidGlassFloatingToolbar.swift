//
//  LiquidGlassFloatingToolbar.swift
//  LiquidGlassKit
//
//  Created by Mason Blumling on 11/23/25.
//

import SwiftUI

/// A floating toolbar container with Liquid Glass styling.
///
/// `LiquidGlassFloatingToolbar` creates a toolbar that floats above content
/// on a Liquid Glass surface. It handles proper grouping of toolbar items
/// and supports badges, scroll edge effects, and platform-appropriate styling.
///
/// This component is ideal for Maps-style floating controls, bottom action bars,
/// or any toolbar that needs to float over scrolling content while maintaining legibility.
///
/// Example:
/// ```swift
/// LiquidGlassFloatingToolbar {
///     ToolbarItem {
///         LiquidGlassButton("Edit", systemImage: "pencil") {
///             editContent()
///         }
///     }
///
///     ToolbarItem {
///         LiquidGlassButton("Share", systemImage: "square.and.arrow.up") {
///             shareContent()
///         }
///         .badge(3)
///     }
/// }
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassFloatingToolbar<Content: View>: View {
    private let content: Content
    private let configuration: GlassConfiguration
    private var horizontalPadding: CGFloat = 12
    private var verticalPadding: CGFloat = 8
    private var spacing: CGFloat = 12
    private var cornerRadius: CGFloat?

    /// Creates a floating toolbar with custom content.
    /// - Parameters:
    ///   - configuration: The glass configuration to use
    ///   - content: A view builder for the toolbar content
    public init(
        configuration: GlassConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = configuration
        self.content = content()
    }

    public var body: some View {
        HStack(spacing: spacing) {
            content
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .liquidGlassBackground(resolvedConfiguration())
    }

    private func resolvedConfiguration() -> GlassConfiguration {
        var config = configuration

        // Use concentric shape if corner radius is specified
        if let radius = cornerRadius {
            config.shapeStyle = .concentric(cornerRadius: radius)
        } else if case .capsule = config.shapeStyle {
            // Keep capsule as-is
        } else {
            // Default to concentric with platform radius
            #if os(macOS)
            config.shapeStyle = .concentric(cornerRadius: 10)
            #else
            config.shapeStyle = .concentric(cornerRadius: 16)
            #endif
        }

        return config
    }

    /// Sets custom padding for the toolbar.
    /// - Parameters:
    ///   - horizontal: Horizontal padding
    ///   - vertical: Vertical padding
    /// - Returns: A toolbar with the specified padding
    public func padding(horizontal: CGFloat, vertical: CGFloat) -> Self {
        var copy = self
        copy.horizontalPadding = horizontal
        copy.verticalPadding = vertical
        return copy
    }

    /// Sets the spacing between toolbar items.
    /// - Parameter spacing: The spacing value
    /// - Returns: A toolbar with the specified spacing
    public func spacing(_ spacing: CGFloat) -> Self {
        var copy = self
        copy.spacing = spacing
        return copy
    }

    /// Sets the corner radius for the toolbar.
    /// - Parameter radius: The corner radius value
    /// - Returns: A toolbar with the specified corner radius
    public func cornerRadius(_ radius: CGFloat) -> Self {
        var copy = self
        copy.cornerRadius = radius
        return copy
    }
}

/// A grouped floating toolbar that uses ToolbarSpacer for automatic grouping.
///
/// This variant demonstrates proper toolbar grouping following Apple's design guidelines.
/// Items are automatically grouped by ToolbarSpacer, creating visual separation.
///
/// Example:
/// ```swift
/// GroupedFloatingToolbar {
///     Button("Edit", systemImage: "pencil") { }
///     Button("Copy", systemImage: "doc.on.doc") { }
///
///     ToolbarSpacer()
///
///     Button("Share", systemImage: "square.and.arrow.up") { }
///         .badge(2)
/// }
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct GroupedFloatingToolbar<Content: View>: View {
    private let content: Content
    private let configuration: GlassConfiguration

    /// Creates a grouped floating toolbar.
    /// - Parameters:
    ///   - configuration: The glass configuration
    ///   - content: A view builder for the toolbar content
    public init(
        configuration: GlassConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = configuration
        self.content = content()
    }

    public var body: some View {
        HStack {
            content
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .liquidGlassBackground(configuration)
    }
}

/// A toolbar item wrapper for use with floating toolbars.
///
/// Provides a consistent container for toolbar actions with optional badges.
@available(iOS 26.0, macOS 26.0, *)
public struct FloatingToolbarItem<Content: View>: View {
    private let content: Content
    private var badgeCount: Int?

    /// Creates a toolbar item.
    /// - Parameter content: The item's content
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        if let count = badgeCount {
            content.badge(count)
        } else {
            content
        }
    }

    /// Adds a badge to the toolbar item.
    /// - Parameter count: The badge count (nil to hide)
    /// - Returns: A toolbar item with a badge
    public func badge(_ count: Int?) -> Self {
        var copy = self
        copy.badgeCount = count
        return copy
    }
}

/// A toolbar that adapts to scroll position with edge effects.
///
/// This component demonstrates how to properly handle scroll edge effects
/// when combining Liquid Glass with scrolling content.
///
/// Example:
/// ```swift
/// ScrollView {
///     // Content
/// }
/// .safeAreaInset(edge: .bottom) {
///     ScrollAwareToolbar {
///         Button("Action 1") { }
///         Button("Action 2") { }
///     }
/// }
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct ScrollAwareToolbar<Content: View>: View {
    private let content: Content
    private let configuration: GlassConfiguration

    @Environment(\.verticalSizeClass) private var verticalSizeClass

    /// Creates a scroll-aware toolbar.
    /// - Parameters:
    ///   - configuration: The glass configuration
    ///   - content: A view builder for the toolbar content
    public init(
        configuration: GlassConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = configuration
        self.content = content()
    }

    public var body: some View {
        HStack(spacing: 12) {
            content
        }
        .padding(.horizontal, 16)
        .padding(.vertical, verticalSizeClass == .compact ? 8 : 12)
        .liquidGlassBackground(configuration)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

// MARK: - Previews

#Preview("Basic Floating Toolbar") {
    ZStack(alignment: .bottom) {
        // Background content
        LinearGradient(
            colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        // Floating toolbar
        LiquidGlassFloatingToolbar {
            LiquidGlassButton("Edit", systemImage: "pencil") {
                print("Edit")
            }

            LiquidGlassButton("Copy", systemImage: "doc.on.doc") {
                print("Copy")
            }

            LiquidGlassProminentButton("Done") {
                print("Done")
            }
            .tint(.blue)
        }
        .padding()
    }
}

#Preview("Grouped Toolbar") {
    ZStack(alignment: .bottom) {
        Color.gray.opacity(0.2)
            .ignoresSafeArea()

        GroupedFloatingToolbar {
            // Left group
            LiquidGlassButton("Edit", systemImage: "pencil") {
                print("Edit")
            }

            LiquidGlassButton("Copy", systemImage: "doc.on.doc") {
                print("Copy")
            }

            Spacer()

            // Right group
            LiquidGlassButton("Share", systemImage: "square.and.arrow.up") {
                print("Share")
            }

            LiquidGlassProminentButton("Save") {
                print("Save")
            }
            .tint(.green)
        }
        .padding()
    }
}

#Preview("Toolbar Over Scrolling Content") {
    ScrollView {
        VStack(spacing: 20) {
            ForEach(0..<20) { index in
                RoundedRectangle(cornerRadius: 12)
                    .fill(.blue.opacity(0.3))
                    .frame(height: 100)
                    .overlay {
                        Text("Item \(index + 1)")
                            .font(.headline)
                    }
            }
        }
        .padding()
    }
    .safeAreaInset(edge: .bottom) {
        ScrollAwareToolbar {
            LiquidGlassButton(systemImage: "heart") {
                print("Like")
            }

            LiquidGlassButton(systemImage: "star") {
                print("Favorite")
            }

            LiquidGlassButton(systemImage: "square.and.arrow.up") {
                print("Share")
            }
        }
    }
}

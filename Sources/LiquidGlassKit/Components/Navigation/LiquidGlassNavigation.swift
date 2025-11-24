//
//  LiquidGlassNavigation.swift
//  LiquidGlassKit
//
//  Created by Mason Blumling on 11/23/25.
//

import SwiftUI

// MARK: - Tab Bar

/// A tab bar with Liquid Glass styling.
///
/// `LiquidGlassTabBar` provides a custom tab bar implementation with glass material background.
/// Use this for custom tab bar layouts or when you need more control than SwiftUI's standard TabView.
///
/// Example:
/// ```swift
/// @State private var selectedTab = 0
///
/// VStack {
///     // Content for selected tab
///     Spacer()
///
///     LiquidGlassTabBar(selection: $selectedTab) {
///         LiquidGlassTabItem(title: "Home", systemImage: "house.fill", tag: 0)
///         LiquidGlassTabItem(title: "Search", systemImage: "magnifyingglass", tag: 1)
///         LiquidGlassTabItem(title: "Profile", systemImage: "person.fill", tag: 2)
///     }
/// }
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassTabBar<Content: View>: View {
    @Binding private var selection: Int
    private let content: Content
    private let configuration: GlassConfiguration

    /// Creates a glass tab bar.
    /// - Parameters:
    ///   - selection: Binding to the selected tab index
    ///   - configuration: Glass configuration
    ///   - content: A view builder for the tab items
    public init(
        selection: Binding<Int>,
        configuration: GlassConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self._selection = selection
        self.configuration = configuration
        self.content = content()
    }

    public var body: some View {
        HStack(spacing: 0) {
            content
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .liquidGlassBackground(configuration)
    }
}

/// A tab item for use in `LiquidGlassTabBar`.
@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassTabItem: View {
    private let title: String
    private let systemImage: String
    private let tag: Int
    @Environment(\.defaultGlassControlSize) private var defaultControlSize

    /// Creates a glass tab item.
    /// - Parameters:
    ///   - title: The tab title
    ///   - systemImage: SF Symbol name
    ///   - tag: The tag value for this tab
    public init(title: String, systemImage: String, tag: Int) {
        self.title = title
        self.systemImage = systemImage
        self.tag = tag
    }

    public var body: some View {
        VStack(spacing: 4) {
            Image(systemName: systemImage)
                .imageScale(.medium)

            Text(title)
                .font(.caption2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

// MARK: - Navigation Bar

/// A custom navigation bar with Liquid Glass styling.
///
/// `LiquidGlassNavigationBar` provides a glass material navigation bar for custom navigation layouts.
/// For standard navigation, consider using SwiftUI's `.toolbarBackground(.glass, for: .navigationBar)`.
///
/// Example:
/// ```swift
/// VStack(spacing: 0) {
///     LiquidGlassNavigationBar(
///         title: "Photos",
///         leading: {
///             LiquidGlassButton("Back", systemImage: "chevron.left") {
///                 // Navigate back
///             }
///         },
///         trailing: {
///             LiquidGlassButton("Edit") {
///                 // Edit action
///             }
///         }
///     )
///
///     ScrollView {
///         // Content
///     }
/// }
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassNavigationBar<Leading: View, Trailing: View>: View {
    private let title: String
    private let leading: Leading
    private let trailing: Trailing
    private let configuration: GlassConfiguration

    /// Creates a glass navigation bar with custom leading and trailing items.
    /// - Parameters:
    ///   - title: The navigation title
    ///   - configuration: Glass configuration
    ///   - leading: A view builder for leading items (e.g., back button)
    ///   - trailing: A view builder for trailing items (e.g., action buttons)
    public init(
        title: String,
        configuration: GlassConfiguration = .default,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.configuration = configuration
        self.leading = leading()
        self.trailing = trailing()
    }

    public var body: some View {
        HStack {
            leading
                .frame(minWidth: 60, alignment: .leading)

            Spacer()

            Text(title)
                .font(.headline)
                .lineLimit(1)

            Spacer()

            trailing
                .frame(minWidth: 60, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .liquidGlassBackground(configuration)
    }
}

// MARK: - Convenience Initializers

@available(iOS 26.0, macOS 26.0, *)
extension LiquidGlassNavigationBar where Leading == EmptyView, Trailing == EmptyView {
    /// Creates a glass navigation bar with only a title.
    /// - Parameters:
    ///   - title: The navigation title
    ///   - configuration: Glass configuration
    public init(
        title: String,
        configuration: GlassConfiguration = .default
    ) {
        self.title = title
        self.configuration = configuration
        self.leading = EmptyView()
        self.trailing = EmptyView()
    }
}

@available(iOS 26.0, macOS 26.0, *)
extension LiquidGlassNavigationBar where Trailing == EmptyView {
    /// Creates a glass navigation bar with leading items only.
    /// - Parameters:
    ///   - title: The navigation title
    ///   - configuration: Glass configuration
    ///   - leading: A view builder for leading items
    public init(
        title: String,
        configuration: GlassConfiguration = .default,
        @ViewBuilder leading: () -> Leading
    ) {
        self.title = title
        self.configuration = configuration
        self.leading = leading()
        self.trailing = EmptyView()
    }
}

@available(iOS 26.0, macOS 26.0, *)
extension LiquidGlassNavigationBar where Leading == EmptyView {
    /// Creates a glass navigation bar with trailing items only.
    /// - Parameters:
    ///   - title: The navigation title
    ///   - configuration: Glass configuration
    ///   - trailing: A view builder for trailing items
    public init(
        title: String,
        configuration: GlassConfiguration = .default,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.configuration = configuration
        self.leading = EmptyView()
        self.trailing = trailing()
    }
}

// MARK: - Toolbar Background Helpers

@available(iOS 26.0, macOS 26.0, *)
extension View {
    /// Applies glass material to standard SwiftUI navigation bars.
    ///
    /// This is a convenience wrapper around SwiftUI's `.toolbarBackground()` modifier
    /// that applies glass material styling to navigation bars and toolbars.
    ///
    /// Example:
    /// ```swift
    /// NavigationStack {
    ///     ContentView()
    ///         .glassNavigationBar()
    /// }
    /// ```
    ///
    /// - Parameter material: The glass material to use (default: `.regular`)
    /// - Returns: A view with glass-styled navigation bar
    public func glassNavigationBar(material: GlassMaterial = .regular) -> some View {
        self
            #if os(iOS)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(material.material, for: .navigationBar)
            #endif
    }

    /// Applies glass material to standard SwiftUI tab bars.
    ///
    /// This is a convenience wrapper around SwiftUI's `.toolbarBackground()` modifier
    /// that applies glass material styling to tab bars.
    ///
    /// Example:
    /// ```swift
    /// TabView {
    ///     HomeView()
    ///         .tabItem { Label("Home", systemImage: "house") }
    /// }
    /// .glassTabBar()
    /// ```
    ///
    /// - Parameter material: The glass material to use (default: `.regular`)
    /// - Returns: A view with glass-styled tab bar
    public func glassTabBar(material: GlassMaterial = .regular) -> some View {
        self
            #if os(iOS)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(material.material, for: .tabBar)
            #endif
    }
}

// MARK: - Previews

#Preview("Custom Tab Bar") {
    @Previewable @State var selectedTab = 0

    VStack(spacing: 0) {
        // Content area
        ZStack {
            Color.blue.opacity(0.1)
                .ignoresSafeArea()

            VStack {
                Image(systemName: tabIcon(for: selectedTab))
                    .font(.system(size: 80))
                    .foregroundStyle(.blue)

                Text(tabTitle(for: selectedTab))
                    .font(.title)
                    .fontWeight(.bold)
            }
        }

        // Custom glass tab bar
        LiquidGlassTabBar(selection: $selectedTab) {
            Button {
                selectedTab = 0
            } label: {
                LiquidGlassTabItem(title: "Home", systemImage: "house.fill", tag: 0)
            }
            .buttonStyle(.plain)
            .opacity(selectedTab == 0 ? 1.0 : 0.6)

            Button {
                selectedTab = 1
            } label: {
                LiquidGlassTabItem(title: "Search", systemImage: "magnifyingglass", tag: 1)
            }
            .buttonStyle(.plain)
            .opacity(selectedTab == 1 ? 1.0 : 0.6)

            Button {
                selectedTab = 2
            } label: {
                LiquidGlassTabItem(title: "Library", systemImage: "books.vertical.fill", tag: 2)
            }
            .buttonStyle(.plain)
            .opacity(selectedTab == 2 ? 1.0 : 0.6)

            Button {
                selectedTab = 3
            } label: {
                LiquidGlassTabItem(title: "Profile", systemImage: "person.fill", tag: 3)
            }
            .buttonStyle(.plain)
            .opacity(selectedTab == 3 ? 1.0 : 0.6)
        }
    }
}

#Preview("Custom Navigation Bar") {
    VStack(spacing: 0) {
        LiquidGlassNavigationBar(
            title: "Photo Library",
            leading: {
                LiquidGlassButton(systemImage: "chevron.left") {
                    print("Back")
                }
            },
            trailing: {
                HStack(spacing: 8) {
                    LiquidGlassButton(systemImage: "square.and.arrow.up") {
                        print("Share")
                    }

                    LiquidGlassButton("Edit") {
                        print("Edit")
                    }
                }
            }
        )

        // Content area
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(0..<12) { index in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.blue.opacity(0.3))
                        .aspectRatio(1, contentMode: .fit)
                        .overlay {
                            Text("\(index + 1)")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                }
            }
            .padding()
        }
    }
}

#Preview("Navigation Bar Variants") {
    ScrollView {
        VStack(spacing: 20) {
            // Title only
            VStack(spacing: 0) {
                LiquidGlassNavigationBar(title: "Title Only")

                Rectangle()
                    .fill(.gray.opacity(0.2))
                    .frame(height: 100)
            }

            // Leading button only
            VStack(spacing: 0) {
                LiquidGlassNavigationBar(
                    title: "With Back Button",
                    leading: {
                        LiquidGlassButton(systemImage: "chevron.left") {
                            print("Back")
                        }
                    }
                )

                Rectangle()
                    .fill(.gray.opacity(0.2))
                    .frame(height: 100)
            }

            // Trailing button only
            VStack(spacing: 0) {
                LiquidGlassNavigationBar(
                    title: "With Action",
                    trailing: {
                        LiquidGlassButton("Done") {
                            print("Done")
                        }
                    }
                )

                Rectangle()
                    .fill(.gray.opacity(0.2))
                    .frame(height: 100)
            }
        }
        .padding()
    }
}

#Preview("Standard Navigation Modifiers") {
    NavigationStack {
        List(0..<20) { index in
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.blue.opacity(0.3))
                    .frame(width: 50, height: 50)

                VStack(alignment: .leading) {
                    Text("Item \(index + 1)")
                        .font(.headline)
                    Text("With glass navigation bar")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Photos")
        .glassNavigationBar() // Apply glass styling
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    print("Edit")
                }
            }
            #else
            ToolbarItem(placement: .automatic) {
                Button("Edit") {
                    print("Edit")
                }
            }
            #endif
        }
    }
}

// MARK: - Helper Functions

private func tabTitle(for index: Int) -> String {
    switch index {
    case 0: return "Home"
    case 1: return "Search"
    case 2: return "Library"
    case 3: return "Profile"
    default: return ""
    }
}

private func tabIcon(for index: Int) -> String {
    switch index {
    case 0: return "house.fill"
    case 1: return "magnifyingglass"
    case 2: return "books.vertical.fill"
    case 3: return "person.fill"
    default: return "questionmark"
    }
}

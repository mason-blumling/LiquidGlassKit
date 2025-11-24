//
//  LiquidGlassSearchBar.swift
//  LiquidGlassKit
//
//  Created by Mason Blumling on 11/23/25.
//

import SwiftUI

/// A standard search bar with Liquid Glass styling.
///
/// `LiquidGlassSearchBar` provides a search field with glass material background,
/// search icon, and clear button. Use this for standard search functionality in lists,
/// toolbars, or as a floating element.
///
/// Example:
/// ```swift
/// @State private var searchText = ""
///
/// LiquidGlassSearchBar(text: $searchText, prompt: "Search items")
///     .padding()
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassSearchBar: View {
    @Binding private var text: String
    private let prompt: String
    private let configuration: GlassConfiguration
    private var showsCancelButton: Bool = false

    /// Creates a glass search bar.
    /// - Parameters:
    ///   - text: Binding to the search text
    ///   - prompt: Placeholder text
    ///   - configuration: Glass configuration (default: `.default`)
    public init(
        text: Binding<String>,
        prompt: String = "Search",
        configuration: GlassConfiguration = .default
    ) {
        self._text = text
        self.prompt = prompt
        self.configuration = configuration
    }

    public var body: some View {
        HStack(spacing: 8) {
            // Search icon
            Image(systemName: "magnifyingglass")
                .imageScale(.small)

            // Text field
            TextField(prompt, text: $text)
                .textFieldStyle(.plain)

            // Clear button (when text exists)
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.small)
                }
                .buttonStyle(.plain)
            }

            // Optional cancel button
            if showsCancelButton {
                Button("Cancel") {
                    text = ""
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .liquidGlassBackground(configuration)
    }

    /// Shows or hides the cancel button.
    /// - Parameter shows: Whether to show the cancel button
    /// - Returns: A search bar with updated cancel button visibility
    public func showsCancelButton(_ shows: Bool) -> Self {
        var copy = self
        copy.showsCancelButton = shows
        return copy
    }
}

/// A compact search bar for toolbars and tight spaces.
///
/// `LiquidGlassCompactSearchBar` provides a more condensed search experience,
/// suitable for navigation bars or areas with limited space.
///
/// Example:
/// ```swift
/// @State private var searchText = ""
/// @State private var isSearching = false
///
/// LiquidGlassCompactSearchBar(
///     text: $searchText,
///     isActive: $isSearching,
///     prompt: "Search"
/// )
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassCompactSearchBar: View {
    @Binding private var text: String
    @Binding private var isActive: Bool
    private let prompt: String
    private let configuration: GlassConfiguration

    /// Creates a compact glass search bar.
    /// - Parameters:
    ///   - text: Binding to the search text
    ///   - isActive: Binding to the active state
    ///   - prompt: Placeholder text
    ///   - configuration: Glass configuration
    public init(
        text: Binding<String>,
        isActive: Binding<Bool>,
        prompt: String = "Search",
        configuration: GlassConfiguration = .default
    ) {
        self._text = text
        self._isActive = isActive
        self.prompt = prompt
        self.configuration = configuration
    }

    public var body: some View {
        HStack(spacing: 6) {
            Image(systemName: isActive ? "magnifyingglass" : "magnifyingglass")
                .imageScale(.small)

            if isActive {
                TextField(prompt, text: $text)
                    .textFieldStyle(.plain)

                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.small)
                    }
                    .buttonStyle(.plain)
                }
            } else {
                Text(prompt)
                    .font(.subheadline)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .liquidGlassBackground(configuration)
        .onTapGesture {
            isActive = true
        }
    }
}

/// A floating search bar that overlays content.
///
/// `LiquidGlassFloatingSearchBar` is designed to float above scrolling content,
/// commonly used in Maps-style interfaces or photo galleries.
///
/// Example:
/// ```swift
/// ZStack {
///     ScrollView {
///         // Content
///     }
///
///     VStack {
///         LiquidGlassFloatingSearchBar(text: $searchText)
///             .padding()
///         Spacer()
///     }
/// }
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassFloatingSearchBar: View {
    @Binding private var text: String
    private let prompt: String
    private let configuration: GlassConfiguration

    /// Creates a floating glass search bar.
    /// - Parameters:
    ///   - text: Binding to the search text
    ///   - prompt: Placeholder text
    ///   - configuration: Glass configuration
    public init(
        text: Binding<String>,
        prompt: String = "Search",
        configuration: GlassConfiguration = .default
    ) {
        self._text = text
        self.prompt = prompt
        self.configuration = configuration
    }

    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .imageScale(.medium)

            TextField(prompt, text: $text)
                .textFieldStyle(.plain)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .liquidGlassBackground(configuration)
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}

// MARK: - Previews

#Preview("Standard Search Bar") {
    @Previewable @State var searchText = ""

    VStack(spacing: 20) {
        Text("Search Photos")
            .font(.largeTitle)
            .fontWeight(.bold)

        LiquidGlassSearchBar(text: $searchText, prompt: "Search photos and albums")
            .padding(.horizontal)

        // Search results
        if !searchText.isEmpty {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(0..<5) { index in
                        HStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.gray.opacity(0.3))
                                .frame(width: 60, height: 60)

                            VStack(alignment: .leading) {
                                Text("Result \(index + 1)")
                                    .font(.headline)
                                Text("Matches '\(searchText)'")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
            }
        } else {
            Spacer()
        }
    }
    .padding()
}

#Preview("Search Bar with Cancel") {
    @Previewable @State var searchText = "Mountains"

    VStack(spacing: 20) {
        LiquidGlassSearchBar(
            text: $searchText,
            prompt: "Search destinations"
        )
        .showsCancelButton(true)
        .padding()

        Text("Searching for: \(searchText)")
            .font(.caption)
            .foregroundStyle(.secondary)

        Spacer()
    }
}

#Preview("Compact Search Bar") {
    @Previewable @State var searchText = ""
    @Previewable @State var isActive = false

    VStack(spacing: 16) {
        // Navigation bar simulation
        HStack {
            Text("Gallery")
                .font(.headline)

            Spacer()

            LiquidGlassCompactSearchBar(
                text: $searchText,
                isActive: $isActive,
                prompt: "Search"
            )
            .frame(maxWidth: isActive ? .infinity : 120)
            .animation(.smooth, value: isActive)
        }
        .padding()

        if isActive {
            Text("Tap search bar to activate")
                .font(.caption)
                .foregroundStyle(.secondary)
        }

        Spacer()
    }
}

#Preview("Floating Search Over Content") {
    @Previewable @State var searchText = ""

    ZStack(alignment: .top) {
        // Background content (map-style)
        LinearGradient(
            colors: [.green.opacity(0.3), .blue.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay {
            // Simulated map pins
            VStack(spacing: 40) {
                ForEach(0..<6) { _ in
                    HStack(spacing: 50) {
                        ForEach(0..<4) { _ in
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .padding()
        }

        // Floating search bar
        LiquidGlassFloatingSearchBar(
            text: $searchText,
            prompt: "Search places"
        )
        .padding()
        .padding(.top, 8)
    }
}

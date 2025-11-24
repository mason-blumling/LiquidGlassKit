//
//  LiquidGlassHeroHeader.swift
//  LiquidGlassKit
//
//  Created by Mason Blumling on 11/23/25.
//

import SwiftUI

/// A hero header component that demonstrates background extension effects.
///
/// `LiquidGlassHeroHeader` creates a hero-style header with a blurred, extended
/// background image that sits beneath Liquid Glass UI elements. This pattern is
/// commonly seen in Apple apps like Landmarks, where artwork extends and blurs
/// behind navigation and content areas.
///
/// The component uses `backgroundExtensionEffect()` to mirror and blur content
/// while ensuring text and controls maintain legibility by sitting above the glass layer.
///
/// Example:
/// ```swift
/// LiquidGlassHeroHeader(image: "mountainscape") {
///     VStack(alignment: .leading) {
///         Text("National Park")
///             .font(.largeTitle)
///             .fontWeight(.bold)
///         Text("Yosemite")
///             .font(.title2)
///     }
/// }
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassHeroHeader<Content: View, ImageContent: View>: View {
    private let image: ImageContent
    private let content: Content
    private var height: CGFloat = 300
    private var blurRadius: CGFloat = 20
    private var gradientOpacity: CGFloat = 0.3

    /// Creates a hero header with an image and content overlay.
    /// - Parameters:
    ///   - image: A view builder for the background image
    ///   - content: A view builder for the overlay content
    public init(
        @ViewBuilder image: () -> ImageContent,
        @ViewBuilder content: () -> Content
    ) {
        self.image = image()
        self.content = content()
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            // Background image with extension effect
            image
                .aspectRatio(contentMode: .fill)
                .frame(height: height)
                .clipped()
                .backgroundExtensionEffect()
                .overlay {
                    // Dimming gradient for legibility
                    LinearGradient(
                        colors: [
                            .clear,
                            .black.opacity(gradientOpacity)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }

            // Content on glass (sits above the sampled background)
            content
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: height)
    }

    /// Sets the height of the hero header.
    /// - Parameter height: The desired height
    /// - Returns: A hero header with the specified height
    public func height(_ height: CGFloat) -> Self {
        var copy = self
        copy.height = height
        return copy
    }

    /// Sets the dimming gradient opacity for legibility.
    /// - Parameter opacity: The gradient opacity (0-1)
    /// - Returns: A hero header with the specified gradient
    public func dimmingGradient(opacity: CGFloat) -> Self {
        var copy = self
        copy.gradientOpacity = opacity
        return copy
    }
}

// MARK: - Convenience Initializers

@available(iOS 26.0, macOS 26.0, *)
extension LiquidGlassHeroHeader where ImageContent == Image {
    /// Creates a hero header with a named image.
    /// - Parameters:
    ///   - imageName: The name of the image asset
    ///   - content: A view builder for the overlay content
    public init(
        _ imageName: String,
        @ViewBuilder content: () -> Content
    ) {
        self.image = Image(imageName)
        self.content = content()
    }

    /// Creates a hero header with a system image.
    /// - Parameters:
    ///   - systemImage: SF Symbol name
    ///   - content: A view builder for the overlay content
    public init(
        systemImage: String,
        @ViewBuilder content: () -> Content
    ) {
        self.image = Image(systemName: systemImage)
        self.content = content()
    }
}

/// A sidebar layout with background extension for hero content.
///
/// This component demonstrates the Landmarks-style layout where a sidebar
/// sits on a glass surface and hero images extend beneath it.
///
/// Example:
/// ```swift
/// SidebarWithHeroLayout(
///     image: Image("landscape")
/// ) {
///     // Sidebar content
///     List {
///         ForEach(items) { item in
///             Text(item.name)
///         }
///     }
/// } detail: {
///     // Detail content
///     Text("Details")
/// }
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct SidebarWithHeroLayout<Image: View, Sidebar: View, Detail: View>: View {
    private let image: Image
    private let sidebar: Sidebar
    private let detail: Detail

    /// Creates a sidebar layout with hero background extension.
    /// - Parameters:
    ///   - image: A view builder for the hero image
    ///   - sidebar: A view builder for the sidebar content
    ///   - detail: A view builder for the detail content
    public init(
        @ViewBuilder image: () -> Image,
        @ViewBuilder sidebar: () -> Sidebar,
        @ViewBuilder detail: () -> Detail
    ) {
        self.image = image()
        self.sidebar = sidebar()
        self.detail = detail()
    }

    public var body: some View {
        #if os(macOS)
        macOSLayout
        #else
        iOSLayout
        #endif
    }

    @ViewBuilder
    private var iOSLayout: some View {
        NavigationSplitView {
            ZStack(alignment: .topLeading) {
                // Hero image with extension
                image
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .backgroundExtensionEffect()
                    .overlay {
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.3)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                    .ignoresSafeArea(edges: .top)

                // Sidebar content on glass
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 200)

                        sidebar
                    }
                }
            }
        } detail: {
            detail
        }
    }

    @ViewBuilder
    private var macOSLayout: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            ZStack(alignment: .top) {
                // Hero image with extension for detail pane
                image
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .clipped()
                    .backgroundExtensionEffect()
                    .ignoresSafeArea(edges: .top)

                detail
            }
        }
    }
}

/// A floating search bar with Liquid Glass styling that works with hero headers.
///
/// Example:
/// ```swift
/// @State private var searchText = ""
///
/// HeroSearchBar(text: $searchText, prompt: "Search locations")
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct HeroSearchBar: View {
    @Binding private var text: String
    private let prompt: String
    private let configuration: GlassConfiguration

    /// Creates a hero-style search bar.
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
                .foregroundStyle(.secondary)

            TextField(prompt, text: $text)
                .textFieldStyle(.plain)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .liquidGlassBackground(configuration)
    }
}

// MARK: - Previews

#Preview("Basic Hero Header") {
    LiquidGlassHeroHeader {
        // Background image
        LinearGradient(
            colors: [.blue, .purple, .pink],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    } content: {
        VStack(alignment: .leading, spacing: 8) {
            Text("Yosemite National Park")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("California, USA")
                .font(.title2)

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .imageScale(.small)
                Text("4.9")
                Text("• 1,234 reviews")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
        }
    }
    .height(350)
}

#Preview("Hero with Search Bar") {
    @Previewable @State var searchText = ""

    VStack(spacing: 0) {
        ZStack(alignment: .top) {
            LiquidGlassHeroHeader {
                LinearGradient(
                    colors: [.orange, .red],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } content: {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Discover")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Find your next adventure")
                        .font(.title3)
                }
            }
            .height(250)

            // Floating search bar
            HeroSearchBar(text: $searchText, prompt: "Search destinations")
                .padding()
                .padding(.top, 180)
        }

        // Content area
        ScrollView {
            VStack(spacing: 16) {
                ForEach(0..<5) { index in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gray.opacity(0.2))
                        .frame(height: 100)
                        .overlay {
                            Text("Destination \(index + 1)")
                        }
                }
            }
            .padding()
        }
    }
}

#Preview("Hero with Scrolling Content") {
    ScrollView {
        VStack(spacing: 0) {
            LiquidGlassHeroHeader {
                LinearGradient(
                    colors: [.green, .blue],
                    startPoint: .top,
                    endPoint: .bottom
                )
            } content: {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Featured Location")
                        .font(.title)
                        .fontWeight(.semibold)

                    HStack {
                        LiquidGlassBadge("New", systemImage: "star.fill")
                            .tint(.yellow)

                        LiquidGlassBadge("Trending")
                            .tint(.orange)
                    }
                }
            }
            .height(300)

            // Content below hero
            VStack(alignment: .leading, spacing: 20) {
                Text("About")
                    .font(.headline)

                Text("This is a beautiful location perfect for your next visit. Experience stunning views and unforgettable moments.")
                    .foregroundStyle(.secondary)

                Divider()

                Text("Details")
                    .font(.headline)

                ForEach(0..<3) { index in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("Feature \(index + 1)")
                        Spacer()
                    }
                }
            }
            .padding()
        }
    }
}

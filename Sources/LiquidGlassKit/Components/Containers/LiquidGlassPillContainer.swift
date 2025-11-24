//
//  LiquidGlassPillContainer.swift
//  LiquidGlassKit
//
//  Created by Mason Blumling on 11/23/25.
//

import SwiftUI

/// A pill-shaped container with Liquid Glass styling.
///
/// `LiquidGlassPillContainer` is a simple, capsule-shaped view that wraps content
/// in a glass effect. It's ideal for filter chips, compact labels, or any small
/// piece of UI that needs to float above content.
///
/// Example:
/// ```swift
/// LiquidGlassPillContainer {
///     Label("Photos", systemImage: "photo")
/// }
///
/// LiquidGlassPillContainer(isInteractive: true) {
///     Text("Tap me")
/// }
/// .onTapGesture {
///     // Handle interaction
/// }
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassPillContainer<Content: View>: View {
    private let content: Content
    private let configuration: GlassConfiguration
    private var horizontalPadding: CGFloat = 12
    private var verticalPadding: CGFloat = 8

    /// Creates a pill container with custom content.
    /// - Parameters:
    ///   - isInteractive: Whether the pill should have interactive glass effects
    ///   - material: The glass material to use
    ///   - content: A view builder for the container's content
    public init(
        isInteractive: Bool = false,
        material: GlassMaterial = .regular,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.configuration = GlassConfiguration(
            material: material,
            isInteractive: isInteractive,
            shapeStyle: .capsule
        )
    }

    /// Creates a pill container with a specific configuration.
    /// - Parameters:
    ///   - configuration: The glass configuration to use
    ///   - content: A view builder for the container's content
    public init(
        configuration: GlassConfiguration,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.configuration = configuration
    }

    public var body: some View {
        content
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .liquidGlassBackground(configuration)
    }

    /// Sets custom padding for the pill container.
    /// - Parameters:
    ///   - horizontal: Horizontal padding
    ///   - vertical: Vertical padding
    /// - Returns: A pill container with the specified padding
    public func padding(horizontal: CGFloat, vertical: CGFloat) -> Self {
        var copy = self
        copy.horizontalPadding = horizontal
        copy.verticalPadding = vertical
        return copy
    }
}

// MARK: - Convenience Initializers

@available(iOS 26.0, macOS 26.0, *)
extension LiquidGlassPillContainer where Content == Text {
    /// Creates a pill container with text only.
    /// - Parameters:
    ///   - text: The text to display
    ///   - isInteractive: Whether the pill should have interactive effects
    ///   - material: The glass material to use
    public init(
        _ text: String,
        isInteractive: Bool = false,
        material: GlassMaterial = .regular
    ) {
        self.content = Text(text)
        self.configuration = GlassConfiguration(
            material: material,
            isInteractive: isInteractive,
            shapeStyle: .capsule
        )
    }
}

@available(iOS 26.0, macOS 26.0, *)
extension LiquidGlassPillContainer where Content == Label<Text, Image> {
    /// Creates a pill container with text and icon.
    /// - Parameters:
    ///   - title: The text to display
    ///   - systemImage: SF Symbol name
    ///   - isInteractive: Whether the pill should have interactive effects
    ///   - material: The glass material to use
    public init(
        _ title: String,
        systemImage: String,
        isInteractive: Bool = false,
        material: GlassMaterial = .regular
    ) {
        self.content = Label(title, systemImage: systemImage)
        self.configuration = GlassConfiguration(
            material: material,
            isInteractive: isInteractive,
            shapeStyle: .capsule
        )
    }
}

/// A horizontally-scrolling stack of pill containers.
///
/// Use this to display a row of filter chips or category pills that can
/// scroll horizontally when they exceed the available width.
///
/// Example:
/// ```swift
/// LiquidGlassPillStack {
///     LiquidGlassPillContainer("Photos", systemImage: "photo")
///     LiquidGlassPillContainer("Videos", systemImage: "video")
///     LiquidGlassPillContainer("Audio", systemImage: "music.note")
/// }
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassPillStack<Content: View>: View {
    private let content: Content
    private var spacing: CGFloat = 8

    /// Creates a horizontally-scrolling pill stack.
    /// - Parameters:
    ///   - spacing: The spacing between pills
    ///   - content: A view builder for the pills
    public init(
        spacing: CGFloat = 8,
        @ViewBuilder content: () -> Content
    ) {
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacing) {
                content
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Previews

#Preview("Filter Chips") {
    @Previewable @State var selectedCategory = "All"

    let categories = ["All", "Photos", "Videos", "Documents", "Music"]

    VStack(spacing: 20) {
        Text("Select Category")
            .font(.headline)

        // Interactive filter pills
        LiquidGlassPillStack(spacing: 12) {
            ForEach(categories, id: \.self) { category in
                LiquidGlassPillContainer(
                    category,
                    systemImage: iconForCategory(category),
                    isInteractive: true
                )
                .opacity(selectedCategory == category ? 1.0 : 0.7)
                .onTapGesture {
                    selectedCategory = category
                }
            }
        }

        Text("Selected: \(selectedCategory)")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
}

#Preview("Tag Cloud") {
    let tags = ["Swift", "SwiftUI", "iOS", "macOS", "Design", "UI/UX", "Animation", "Performance"]

    VStack(spacing: 16) {
        Text("Popular Tags")
            .font(.headline)

        FlowLayout(spacing: 8) {
            ForEach(tags, id: \.self) { tag in
                LiquidGlassPillContainer(tag, systemImage: "number")
                    .tint(.blue)
            }
        }
    }
    .padding()
}

#Preview("Scrolling Tabs") {
    @Previewable @State var selectedTab = "For You"

    let tabs = ["For You", "Following", "Trending", "Recent", "Popular", "Saved"]

    VStack(spacing: 0) {
        LiquidGlassPillStack(spacing: 10) {
            ForEach(tabs, id: \.self) { tab in
                LiquidGlassPillContainer(tab, isInteractive: true)
                    .opacity(selectedTab == tab ? 1.0 : 0.6)
                    .onTapGesture {
                        selectedTab = tab
                    }
            }
        }
        .padding(.vertical, 12)

        Divider()

        // Content area
        Text(selectedTab)
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue.opacity(0.1))
    }
}

// MARK: - Helper Views

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        let height = rows.reduce(0) { $0 + $1.maxHeight } + CGFloat(max(0, rows.count - 1)) * spacing
        return CGSize(width: proposal.width ?? 0, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var y = bounds.minY

        for row in rows {
            var x = bounds.minX

            for index in row.indices {
                let size = subviews[index].sizeThatFits(.unspecified)
                subviews[index].place(at: CGPoint(x: x, y: y), proposal: .unspecified)
                x += size.width + spacing
            }

            y += row.maxHeight + spacing
        }
    }

    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [(indices: [Int], maxHeight: CGFloat)] {
        var rows: [(indices: [Int], maxHeight: CGFloat)] = []
        var currentRow: [Int] = []
        var currentX: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        let maxWidth = proposal.width ?? .infinity

        for (index, subview) in subviews.enumerated() {
            let size = subview.sizeThatFits(.unspecified)

            if currentX + size.width > maxWidth && !currentRow.isEmpty {
                rows.append((indices: currentRow, maxHeight: currentRowHeight))
                currentRow = []
                currentX = 0
                currentRowHeight = 0
            }

            currentRow.append(index)
            currentX += size.width + spacing
            currentRowHeight = max(currentRowHeight, size.height)
        }

        if !currentRow.isEmpty {
            rows.append((indices: currentRow, maxHeight: currentRowHeight))
        }

        return rows
    }
}

private func iconForCategory(_ category: String) -> String {
    switch category {
    case "All": return "square.grid.2x2"
    case "Photos": return "photo"
    case "Videos": return "video"
    case "Documents": return "doc"
    case "Music": return "music.note"
    default: return "folder"
    }
}

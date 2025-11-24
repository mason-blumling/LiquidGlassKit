//
//  GlassDimmingLayer.swift
//  LiquidGlassKit
//
//  Created by Mason Blumling on 11/23/25.
//

import SwiftUI

/// A dimming overlay required when using clear glass over bright content.
///
/// According to Apple's Liquid Glass guidelines, clear glass materials require
/// a 35% dimming layer when placed over bright content to maintain legibility.
/// Regular glass materials automatically handle legibility and don't require dimming.
///
/// Example:
/// ```swift
/// ZStack {
///     // Bright content
///     Image("bright-photo")
///         .resizable()
///         .overlay {
///             GlassDimmingLayer() // Add dimming for clear glass
///         }
///
///     // Clear glass UI elements
///     VStack {
///         LiquidGlassButton("Action") { }
///             .liquidGlassBackground(material: .clear)
///     }
/// }
/// ```
///
/// - Important: Only use this with `.clear` glass materials. Regular glass
///   maintains legibility automatically and doesn't need additional dimming.
@available(iOS 26.0, macOS 26.0, *)
public struct GlassDimmingLayer: View {
    /// The opacity level for the dimming layer (35% as specified by Apple)
    private let opacity: Double = 0.35

    /// Creates a dimming layer for clear glass legibility.
    public init() {}

    public var body: some View {
        Rectangle()
            .fill(.black.opacity(opacity))
            .allowsHitTesting(false)
    }
}

/// View modifier for easily applying a dimming layer.
@available(iOS 26.0, macOS 26.0, *)
extension View {
    /// Applies a dimming overlay for clear glass legibility.
    ///
    /// Use this modifier when placing clear glass UI elements over bright content.
    /// The dimming layer ensures proper legibility by reducing background brightness.
    ///
    /// Example:
    /// ```swift
    /// Image("sunset")
    ///     .resizable()
    ///     .glassDimming()
    /// ```
    ///
    /// - Returns: A view with a 35% black dimming overlay
    public func glassDimming() -> some View {
        overlay {
            GlassDimmingLayer()
        }
    }
}

// MARK: - Previews

#Preview("Dimming Over Bright Content") {
    ZStack {
        // Bright gradient background
        LinearGradient(
            colors: [.yellow, .orange, .red, .pink],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay {
            GlassDimmingLayer() // Required for clear glass
        }

        // Clear glass UI elements
        VStack(spacing: 20) {
            Text("Clear Glass UI")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            LiquidGlassButton("Action", systemImage: "star.fill") {
                print("Action")
            }
            .liquidGlassBackground(material: .clear)

            LiquidGlassPillContainer("Filter", systemImage: "line.3.horizontal.decrease.circle")
                .liquidGlassBackground(material: .clear)
        }
    }
}

#Preview("Modifier Usage") {
    ZStack {
        // Bright image with dimming modifier
        LinearGradient(
            colors: [.blue, .cyan, .green],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .glassDimming() // Convenience modifier

        // Clear glass floating toolbar
        VStack {
            Spacer()

            LiquidGlassFloatingToolbar(
                configuration: GlassConfiguration(material: .clear)
            ) {
                LiquidGlassButton("Edit", systemImage: "pencil") {
                    print("Edit")
                }

                LiquidGlassButton("Share", systemImage: "square.and.arrow.up") {
                    print("Share")
                }

                LiquidGlassProminentButton("Save") {
                    print("Save")
                }
                .tint(.white)
            }
            .padding()
        }
    }
}

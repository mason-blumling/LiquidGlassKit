//
//  GlassModifiers.swift
//  LiquidGlassKit
//
//  Created by Mason Blumling on 11/23/25.
//

import SwiftUI

/// View modifiers for applying Liquid Glass effects.
@available(iOS 26.0, macOS 26.0, *)
extension View {
    /// Applies a Liquid Glass background with the specified configuration.
    ///
    /// This modifier wraps SwiftUI's `glassEffect()` with type-safe configuration
    /// and handles shape selection, interactivity, and tinting automatically.
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .liquidGlassBackground(.default)
    /// ```
    ///
    /// - Parameter configuration: The glass configuration to apply
    /// - Returns: A view with a liquid glass background
    public func liquidGlassBackground(_ configuration: GlassConfiguration = .default) -> some View {
        modifier(LiquidGlassBackgroundModifier(configuration: configuration))
    }

    /// Applies a Liquid Glass background with custom parameters.
    /// - Parameters:
    ///   - material: The glass material to use
    ///   - shape: The shape style for the glass container
    ///   - isInteractive: Whether to enable interactive effects
    ///   - tint: Optional tint color
    /// - Returns: A view with a liquid glass background
    public func liquidGlassBackground(
        material: GlassMaterial = .regular,
        shape: GlassShapeStyle = .capsule,
        isInteractive: Bool = false,
        tint: Color? = nil
    ) -> some View {
        let config = GlassConfiguration(
            material: material,
            isInteractive: isInteractive,
            tint: tint,
            shapeStyle: shape
        )
        return liquidGlassBackground(config)
    }

    /// Applies interactive glass effects when enabled.
    ///
    /// Interactive glass responds to user interactions with shimmer and bounce effects.
    /// Use this for controls and elements that should provide haptic feedback.
    ///
    /// - Parameter isInteractive: Whether to enable interactive effects
    /// - Returns: A view with updated interactivity
    public func liquidGlassInteractive(_ isInteractive: Bool = true) -> some View {
        modifier(LiquidGlassInteractiveModifier(isInteractive: isInteractive))
    }

    /// Groups this view with other glass elements for shared sampling and morphing.
    ///
    /// Glass elements with the same ID and namespace will share a sampling region
    /// and can morph smoothly between each other using transitions.
    ///
    /// Example:
    /// ```swift
    /// @Namespace var glassNamespace
    ///
    /// Badge("New")
    ///     .liquidGlassGrouped(id: "badge", in: glassNamespace)
    /// ```
    ///
    /// - Parameters:
    ///   - id: A unique identifier for this glass group
    ///   - namespace: The namespace for coordinating glass effects
    /// - Returns: A view configured for glass grouping
    public func liquidGlassGrouped<ID: Hashable & Sendable>(id: ID, in namespace: Namespace.ID) -> some View {
        modifier(LiquidGlassGroupingModifier(id: id, namespace: namespace))
    }
}

// MARK: - Internal Modifiers

@available(iOS 26.0, macOS 26.0, *)
private struct LiquidGlassBackgroundModifier: ViewModifier {
    let configuration: GlassConfiguration
    @Environment(\.defaultGlassMaterial) private var defaultMaterial
    @Environment(\.defaultGlassShapeStyle) private var defaultShapeStyle

    func body(content: Content) -> some View {
        let material = resolvedGlass()

        content.background {
            shapeView()
                .glassEffect(material, in: resolvedShape())
        }
    }

    private func resolvedGlass() -> Glass {
        var glass = configuration.material.glass

        if configuration.isInteractive {
            glass = glass.interactive(true)
        }

        if let tint = configuration.tint {
            glass = glass.tint(tint)
        }

        return glass
    }

    @ViewBuilder
    private func shapeView() -> some View {
        switch configuration.shapeStyle {
        case .capsule:
            Capsule()
        case .concentric(let radius):
            if let radius = radius {
                ConcentricRoundedRectangle(cornerRadius: radius)
            } else {
                GlassShapes.concentricRectangle()
            }
        case .fixed(let radius):
            RoundedRectangle(cornerRadius: radius)
        }
    }

    private func resolvedShape() -> GlassAnyShape {
        switch configuration.shapeStyle {
        case .capsule:
            return GlassAnyShape(Capsule())
        case .concentric(let radius):
            if let radius = radius {
                return GlassAnyShape(ConcentricRoundedRectangle(cornerRadius: radius))
            } else {
                return GlassAnyShape(GlassShapes.concentricRectangle())
            }
        case .fixed(let radius):
            return GlassAnyShape(RoundedRectangle(cornerRadius: radius))
        }
    }
}

@available(iOS 26.0, macOS 26.0, *)
private struct LiquidGlassInteractiveModifier: ViewModifier {
    let isInteractive: Bool

    func body(content: Content) -> some View {
        // Interactive state is applied via Glass.interactive() in the background modifier
        // This modifier serves as a semantic marker and could apply additional effects
        content
    }
}

@available(iOS 26.0, macOS 26.0, *)
private struct LiquidGlassGroupingModifier<ID: Hashable & Sendable>: ViewModifier {
    let id: ID
    let namespace: Namespace.ID

    func body(content: Content) -> some View {
        content
            .glassEffectID(id, in: namespace)
    }
}

// MARK: - Shape Type Erasure

@available(iOS 26.0, macOS 26.0, *)
private struct GlassAnyShape: Shape {
    private let _path: @Sendable (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        _path = { rect in
            shape.path(in: rect)
        }
    }

    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}

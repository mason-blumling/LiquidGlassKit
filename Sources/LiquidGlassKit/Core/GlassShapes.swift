//
//  GlassShapes.swift
//  LiquidGlassKit
//
//  Created by Mason Blumling on 11/23/25.
//

import SwiftUI

/// Shape helpers for creating concentric and properly-sized glass containers.
@available(iOS 26.0, macOS 26.0, *)
public struct GlassShapes {
    /// Creates a concentric rounded rectangle that aligns with platform conventions.
    ///
    /// Concentric shapes share a common center point and scale their corner radii
    /// proportionally, following Apple's concentricity principle.
    ///
    /// - Parameter cornerRadius: Optional corner radius. If nil, uses platform default.
    /// - Returns: A rounded rectangle shape suitable for glass effects.
    public static func concentricRectangle(cornerRadius: CGFloat? = nil) -> RoundedRectangle {
        #if os(macOS)
        // macOS prefers smaller, denser radii
        let defaultRadius: CGFloat = 8
        #else
        // iOS prefers more pronounced rounding
        let defaultRadius: CGFloat = 12
        #endif

        return RoundedRectangle(cornerRadius: cornerRadius ?? defaultRadius)
    }

    /// Creates a concentric rounded rectangle with explicit corner style.
    /// - Parameters:
    ///   - cornerRadius: The corner radius value
    ///   - style: The corner curve style (continuous or circular)
    /// - Returns: A rounded rectangle with the specified style
    public static func concentricRectangle(
        cornerRadius: CGFloat,
        style: RoundedCornerStyle
    ) -> RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: style)
    }

    /// Calculates a concentric corner radius based on a reference size.
    ///
    /// This maintains visual hierarchy when nesting glass containers by scaling
    /// radii proportionally around a shared center.
    ///
    /// - Parameters:
    ///   - baseRadius: The base corner radius
    ///   - inset: The inset from the outer container (for nested elements)
    /// - Returns: A corner radius that maintains concentricity
    public static func concentricRadius(base baseRadius: CGFloat, inset: CGFloat) -> CGFloat {
        max(0, baseRadius - inset)
    }

    /// Returns platform-appropriate default corner radius for control size.
    /// - Parameter size: The control size to get radius for
    /// - Returns: Recommended corner radius
    public static func defaultCornerRadius(for size: GlassControlSize) -> CGFloat {
        #if os(macOS)
        switch size {
        case .mini: return 4
        case .small: return 6
        case .regular: return 8
        case .large: return 10
        case .extraLarge: return 12
        }
        #else
        switch size {
        case .mini: return 6
        case .small: return 8
        case .regular: return 12
        case .large: return 16
        case .extraLarge: return 20
        }
        #endif
    }
}

/// A shape that represents a concentric rounded rectangle following platform conventions.
@available(iOS 26.0, macOS 26.0, *)
public struct ConcentricRoundedRectangle: Shape {
    public var cornerRadius: CGFloat
    public var style: RoundedCornerStyle

    /// Creates a concentric rounded rectangle.
    /// - Parameters:
    ///   - cornerRadius: The corner radius
    ///   - style: The corner curve style (default: .continuous)
    public init(cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous) {
        self.cornerRadius = cornerRadius
        self.style = style
    }

    public func path(in rect: CGRect) -> Path {
        Path(
            roundedRect: rect,
            cornerRadius: cornerRadius,
            style: style
        )
    }
}

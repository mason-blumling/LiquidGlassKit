//
//  GlassConfiguration.swift
//  LiquidGlassKit
//
//  Created by Mason Blumling on 11/23/25.
//

import SwiftUI

/// Configuration for Liquid Glass materials, shapes, and behaviors.
@available(iOS 26.0, macOS 26.0, *)
public struct GlassConfiguration: Sendable {
    /// The glass material variant to use.
    public var material: GlassMaterial

    /// Whether the glass should respond to interactions with shimmer/bounce effects.
    public var isInteractive: Bool

    /// Optional tint color for the glass effect.
    public var tint: Color?

    /// The shape style to use for the glass container.
    public var shapeStyle: GlassShapeStyle

    /// Creates a glass configuration.
    /// - Parameters:
    ///   - material: The glass material variant (default: `.regular`)
    ///   - isInteractive: Whether to enable interactive effects (default: `false`)
    ///   - tint: Optional tint color (default: `nil`)
    ///   - shapeStyle: The shape style to apply (default: `.capsule`)
    public init(
        material: GlassMaterial = .regular,
        isInteractive: Bool = false,
        tint: Color? = nil,
        shapeStyle: GlassShapeStyle = .capsule
    ) {
        self.material = material
        self.isInteractive = isInteractive
        self.tint = tint
        self.shapeStyle = shapeStyle
    }

    /// Default configuration with regular glass and capsule shape.
    public static let `default` = GlassConfiguration()

    /// Clear glass configuration (requires dimming layer for legibility).
    public static let clear = GlassConfiguration(material: .clear)

    /// Interactive glass configuration that responds to touches.
    public static let interactive = GlassConfiguration(isInteractive: true)
}

/// Liquid Glass material variants.
@available(iOS 26.0, macOS 26.0, *)
public enum GlassMaterial: Sendable {
    /// Regular glass with standard blur and luminosity adjustment.
    /// Maintains legibility automatically.
    case regular

    /// Clear glass with high translucency.
    /// Requires a dimming layer (35% opacity) when over bright content.
    case clear

    /// Identity glass (no effect, for transitions).
    case identity

    /// Custom glass with specific characteristics.
    case custom(Glass)

    /// Converts to SwiftUI's Glass type.
    internal var glass: Glass {
        switch self {
        case .regular:
            return .regular
        case .clear:
            return .clear
        case .identity:
            return .identity
        case .custom(let glass):
            return glass
        }
    }
}

/// Shape styles for Liquid Glass components following Apple's concentricity principles.
@available(iOS 26.0, macOS 26.0, *)
public enum GlassShapeStyle: Sendable {
    /// Capsule shape (fully rounded ends). Preferred for iOS buttons and pills.
    case capsule

    /// Concentric rounded rectangle with platform-appropriate corner radius.
    /// Preferred for macOS controls and containers.
    case concentric(cornerRadius: CGFloat? = nil)

    /// Fixed rounded rectangle that doesn't adjust to content.
    case fixed(cornerRadius: CGFloat)

    // Note: .custom(any Shape) case removed to maintain Sendable conformance
    // Custom shapes can be applied directly via view modifiers instead
}

/// Control size variants for Liquid Glass components.
@available(iOS 26.0, macOS 26.0, *)
public enum GlassControlSize {
    case mini
    case small
    case regular
    case large
    case extraLarge

    /// Converts to SwiftUI's ControlSize.
    internal var controlSize: ControlSize {
        switch self {
        case .mini:
            return .mini
        case .small:
            return .small
        case .regular:
            return .regular
        case .large:
            return .large
        case .extraLarge:
            return .extraLarge
        }
    }
}

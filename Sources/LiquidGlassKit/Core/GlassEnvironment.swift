//
//  GlassEnvironment.swift
//  LiquidGlassKit
//
//  Created by Mason Blumling on 11/23/25.
//

import SwiftUI

/// Environment values for configuring Liquid Glass defaults throughout a view hierarchy.
@available(iOS 26.0, macOS 26.0, *)
extension EnvironmentValues {
    /// The default glass material to use in the current environment.
    @Entry public var defaultGlassMaterial: GlassMaterial = .regular

    /// The default shape style for glass components.
    @Entry public var defaultGlassShapeStyle: GlassShapeStyle = .capsule

    /// The default control size for glass components.
    @Entry public var defaultGlassControlSize: GlassControlSize = .regular

    /// Whether glass components should be interactive by default.
    @Entry public var defaultGlassIsInteractive: Bool = false
}

/// View extensions for setting Liquid Glass environment defaults.
@available(iOS 26.0, macOS 26.0, *)
extension View {
    /// Sets the default glass material for components in this view hierarchy.
    /// - Parameter material: The glass material to use as default
    /// - Returns: A view with the updated environment
    public func defaultGlassMaterial(_ material: GlassMaterial) -> some View {
        environment(\.defaultGlassMaterial, material)
    }

    /// Sets the default shape style for glass components in this view hierarchy.
    /// - Parameter shapeStyle: The shape style to use as default
    /// - Returns: A view with the updated environment
    public func defaultGlassShapeStyle(_ shapeStyle: GlassShapeStyle) -> some View {
        environment(\.defaultGlassShapeStyle, shapeStyle)
    }

    /// Sets the default control size for glass components in this view hierarchy.
    /// - Parameter size: The control size to use as default
    /// - Returns: A view with the updated environment
    public func defaultGlassControlSize(_ size: GlassControlSize) -> some View {
        environment(\.defaultGlassControlSize, size)
    }

    /// Sets whether glass components should be interactive by default.
    /// - Parameter isInteractive: Whether to enable interactive effects by default
    /// - Returns: A view with the updated environment
    public func defaultGlassIsInteractive(_ isInteractive: Bool) -> some View {
        environment(\.defaultGlassIsInteractive, isInteractive)
    }
}

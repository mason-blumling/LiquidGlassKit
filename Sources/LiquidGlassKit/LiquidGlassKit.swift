//
//  LiquidGlassKit.swift
//  LiquidGlassKit
//
//  Created by Mason Blumling on 11/23/25.
//

import SwiftUI

/// LiquidGlassKit - A comprehensive SwiftUI framework for Apple's Liquid Glass design system.
///
/// This framework provides reusable components and utilities for building beautiful,
/// functional interfaces using Liquid Glass materials on iOS 26+ and macOS 26+.
///
/// ## Core Concepts
///
/// **Liquid Glass** is a dynamic material that creates functional layers floating above content.
/// It maintains legibility through adaptive blur and luminosity adjustments while keeping
/// visual connection to underlying content.
///
/// ## Key Features
///
/// - **Type-safe Configuration**: `GlassConfiguration`, `GlassMaterial`, `GlassShapeStyle`
/// - **Pre-built Components**: Buttons, badges, pills, toolbars, hero headers
/// - **Morphing & Animations**: `LiquidGlassBadgeStack` with `GlassEffectContainer` support
/// - **Platform Conventions**: Automatic shape and sizing for iOS/macOS
///
/// ## Quick Start
///
/// ```swift
/// import LiquidGlassKit
///
/// // Simple glass button
/// LiquidGlassButton("Save") {
///     saveDocument()
/// }
/// .controlSize(.large)
///
/// // Morphing badge cluster
/// @Namespace var badgeNamespace
///
/// LiquidGlassBadgeStack(namespace: badgeNamespace) {
///     LiquidGlassBadge("New", systemImage: "star.fill")
///     if showDetails {
///         LiquidGlassBadge("5 items")
///     }
/// }
///
/// // Floating toolbar over content
/// ScrollView {
///     // Your content
/// }
/// .safeAreaInset(edge: .bottom) {
///     LiquidGlassFloatingToolbar {
///         LiquidGlassButton("Edit", systemImage: "pencil") { }
///         LiquidGlassButton("Share", systemImage: "square.and.arrow.up") { }
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Core Types
/// - ``GlassConfiguration``
/// - ``GlassMaterial``
/// - ``GlassShapeStyle``
/// - ``GlassControlSize``
///
/// ### Environment & Modifiers
/// - ``View/liquidGlassBackground(_:)``
/// - ``View/liquidGlassInteractive(_:)``
/// - ``View/liquidGlassGrouped(id:in:)``
/// - ``View/defaultGlassMaterial(_:)``
///
/// ### Buttons
/// - ``LiquidGlassButton``
/// - ``LiquidGlassProminentButton``
///
/// ### Badges
/// - ``LiquidGlassBadge``
/// - ``LiquidGlassBadgeStack``
/// - ``LiquidGlassBadgeCluster``
/// - ``MorphingBadge``
///
/// ### Containers
/// - ``LiquidGlassPillContainer``
/// - ``LiquidGlassPillStack``
/// - ``LiquidGlassFloatingToolbar``
/// - ``GroupedFloatingToolbar``
/// - ``ScrollAwareToolbar``
///
/// ### Overlays & Layouts
/// - ``LiquidGlassHeroHeader``
/// - ``SidebarWithHeroLayout``
/// - ``HeroSearchBar``
/// - ``GlassDimmingLayer``
///
/// ### Search Components
/// - ``LiquidGlassSearchBar``
/// - ``LiquidGlassCompactSearchBar``
/// - ``LiquidGlassFloatingSearchBar``
///
/// ### Navigation Components
/// - ``LiquidGlassTabBar``
/// - ``LiquidGlassTabItem``
/// - ``LiquidGlassNavigationBar``
/// - ``View/glassNavigationBar(material:)``
/// - ``View/glassTabBar(material:)``
///
/// ### Legibility & Dimming
/// - ``GlassDimmingLayer``
/// - ``View/glassDimming()``
///
/// ### Shape Utilities
/// - ``GlassShapes``
/// - ``ConcentricRoundedRectangle``
@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassKit {
    /// The current version of LiquidGlassKit.
    public static let version = "1.0.0"

    /// Whether the current platform supports Liquid Glass.
    public static var isSupported: Bool {
        #if os(iOS)
        if #available(iOS 26.0, *) {
            return true
        }
        #elseif os(macOS)
        if #available(macOS 26.0, *) {
            return true
        }
        #endif
        return false
    }
}

//
//  LiquidGlassButton.swift
//  LiquidGlassKit
//
//  Created by Mason Blumling on 11/23/25.
//

import SwiftUI

/// A button with Liquid Glass styling.
///
/// `LiquidGlassButton` wraps SwiftUI's standard `Button` with the `.glass` button style,
/// providing automatic glass effects, proper sizing, and platform-appropriate shapes.
///
/// Example:
/// ```swift
/// LiquidGlassButton("Save") {
///     saveDocument()
/// }
/// .controlSize(.large)
///
/// LiquidGlassButton("Share", systemImage: "square.and.arrow.up") {
///     shareContent()
/// }
/// .tint(.blue)
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassButton<Label: View>: View {
    private let role: ButtonRole?
    private let action: () -> Void
    private let label: Label
    private var size: GlassControlSize = .regular
    private var shape: GlassShapeStyle = .capsule

    @Environment(\.defaultGlassControlSize) private var defaultControlSize

    /// Creates a button with a custom label.
    /// - Parameters:
    ///   - role: Optional button role (e.g., `.destructive`)
    ///   - action: The action to perform when the button is tapped
    ///   - label: A view builder for the button's label
    public init(
        role: ButtonRole? = nil,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.role = role
        self.action = action
        self.label = label()
    }

    public var body: some View {
        Button(role: role, action: action) {
            label
        }
        .buttonStyle(.glass)
        .controlSize(size.controlSize)
        // Shape is handled by the glass button style
    }

    /// Sets the control size for this button.
    /// - Parameter size: The desired control size
    /// - Returns: A button with the specified size
    public func controlSize(_ size: GlassControlSize) -> Self {
        var copy = self
        copy.size = size
        return copy
    }

    /// Sets the shape style for this button.
    /// - Parameter shape: The desired shape style
    /// - Returns: A button with the specified shape
    public func shape(_ shape: GlassShapeStyle) -> Self {
        var copy = self
        copy.shape = shape
        return copy
    }
}

// MARK: - Convenience Initializers

@available(iOS 26.0, macOS 26.0, *)
extension LiquidGlassButton where Label == SwiftUI.Label<Text, Image> {
    /// Creates a button with text and an SF Symbol icon.
    /// - Parameters:
    ///   - title: The button's title
    ///   - systemImage: SF Symbol name
    ///   - role: Optional button role
    ///   - action: The action to perform when tapped
    public init(
        _ title: String,
        systemImage: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) where Label == SwiftUI.Label<Text, Image> {
        self.role = role
        self.action = action
        self.label = SwiftUI.Label(title, systemImage: systemImage)
    }
}

@available(iOS 26.0, macOS 26.0, *)
extension LiquidGlassButton where Label == Text {
    /// Creates a button with text only.
    /// - Parameters:
    ///   - title: The button's title
    ///   - role: Optional button role
    ///   - action: The action to perform when tapped
    public init(
        _ title: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) where Label == Text {
        self.role = role
        self.action = action
        self.label = Text(title)
    }
}

@available(iOS 26.0, macOS 26.0, *)
extension LiquidGlassButton where Label == Image {
    /// Creates a button with an icon only.
    /// - Parameters:
    ///   - systemImage: SF Symbol name
    ///   - role: Optional button role
    ///   - action: The action to perform when tapped
    public init(
        systemImage: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) where Label == Image {
        self.role = role
        self.action = action
        self.label = Image(systemName: systemImage)
    }
}

// MARK: - Prominent Button

/// A prominent button with enhanced Liquid Glass styling.
///
/// Use `LiquidGlassProminentButton` for primary actions that deserve extra visual weight.
/// The prominent style uses more opaque glass and stronger tinting.
///
/// Example:
/// ```swift
/// LiquidGlassProminentButton("Continue") {
///     goToNextStep()
/// }
/// .tint(.blue)
/// ```
@available(iOS 26.0, macOS 26.0, *)
public struct LiquidGlassProminentButton<Label: View>: View {
    private let role: ButtonRole?
    private let action: () -> Void
    private let label: Label
    private var size: GlassControlSize = .regular
    private var shape: GlassShapeStyle = .capsule

    /// Creates a prominent button with a custom label.
    /// - Parameters:
    ///   - role: Optional button role
    ///   - action: The action to perform when tapped
    ///   - label: A view builder for the button's label
    public init(
        role: ButtonRole? = nil,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.role = role
        self.action = action
        self.label = label()
    }

    public var body: some View {
        Button(role: role, action: action) {
            label
        }
        .buttonStyle(.glassProminent)
        .controlSize(size.controlSize)
        // Shape is handled by the glass prominent button style
    }

    /// Sets the control size for this button.
    /// - Parameter size: The desired control size
    /// - Returns: A button with the specified size
    public func controlSize(_ size: GlassControlSize) -> Self {
        var copy = self
        copy.size = size
        return copy
    }

    /// Sets the shape style for this button.
    /// - Parameter shape: The desired shape style
    /// - Returns: A button with the specified shape
    public func shape(_ shape: GlassShapeStyle) -> Self {
        var copy = self
        copy.shape = shape
        return copy
    }
}

// MARK: - Prominent Button Convenience Initializers

@available(iOS 26.0, macOS 26.0, *)
extension LiquidGlassProminentButton where Label == SwiftUI.Label<Text, Image> {
    /// Creates a prominent button with text and icon.
    /// - Parameters:
    ///   - title: The button's title
    ///   - systemImage: SF Symbol name
    ///   - role: Optional button role
    ///   - action: The action to perform when tapped
    public init(
        _ title: String,
        systemImage: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) where Label == SwiftUI.Label<Text, Image> {
        self.role = role
        self.action = action
        self.label = SwiftUI.Label(title, systemImage: systemImage)
    }
}

@available(iOS 26.0, macOS 26.0, *)
extension LiquidGlassProminentButton where Label == Text {
    /// Creates a prominent button with text only.
    /// - Parameters:
    ///   - title: The button's title
    ///   - role: Optional button role
    ///   - action: The action to perform when tapped
    public init(
        _ title: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) where Label == Text {
        self.role = role
        self.action = action
        self.label = Text(title)
    }
}

@available(iOS 26.0, macOS 26.0, *)
extension LiquidGlassProminentButton where Label == Image {
    /// Creates a prominent button with an icon only.
    /// - Parameters:
    ///   - systemImage: SF Symbol name
    ///   - role: Optional button role
    ///   - action: The action to perform when tapped
    public init(
        systemImage: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) where Label == Image {
        self.role = role
        self.action = action
        self.label = Image(systemName: systemImage)
    }
}

// MARK: - Previews

#Preview("Button Styles") {
    VStack(spacing: 16) {
        LiquidGlassButton("Save") {
            print("Save tapped")
        }

        LiquidGlassButton("Cancel", role: .cancel) {
            print("Cancel tapped")
        }

        LiquidGlassButton("Delete", role: .destructive) {
            print("Delete tapped")
        }

        LiquidGlassProminentButton("Continue") {
            print("Continue tapped")
        }
        .tint(.blue)
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing))
}

#Preview("With Icons") {
    VStack(spacing: 12) {
        LiquidGlassButton("Edit", systemImage: "pencil") {
            print("Edit")
        }

        LiquidGlassButton("Share", systemImage: "square.and.arrow.up") {
            print("Share")
        }
        .tint(.blue)

        LiquidGlassButton("Add", systemImage: "plus") {
            print("Add")
        }
        .tint(.green)

        LiquidGlassProminentButton("Save", systemImage: "checkmark") {
            print("Save")
        }
        .tint(.blue)
    }
    .padding()
}

#Preview("Control Sizes", traits: .sizeThatFitsLayout) {
    VStack(spacing: 12) {
        LiquidGlassButton("Mini") {
            print("Mini")
        }
        .controlSize(.mini)

        LiquidGlassButton("Small") {
            print("Small")
        }
        .controlSize(.small)

        LiquidGlassButton("Regular") {
            print("Regular")
        }

        LiquidGlassButton("Large") {
            print("Large")
        }
        .controlSize(.large)

        LiquidGlassButton("Extra Large") {
            print("XL")
        }
        .controlSize(.extraLarge)
    }
    .padding()
}

#Preview("Dark Mode") {
    VStack(spacing: 16) {
        LiquidGlassButton("Action", systemImage: "star.fill") {
            print("Action")
        }
        .tint(.yellow)

        LiquidGlassProminentButton("Done", systemImage: "checkmark") {
            print("Done")
        }
        .tint(.green)

        LiquidGlassButton(systemImage: "gear") {
            print("Settings")
        }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.black)
    .preferredColorScheme(.dark)
}

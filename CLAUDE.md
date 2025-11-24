# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**LiquidGlassKit** is a comprehensive Swift Package that provides reusable SwiftUI components for Apple's Liquid Glass design system on iOS 26+ and macOS 26+.

This is a production-quality framework that encapsulates complex Liquid Glass behaviors (morphing, grouping, background extension) behind clean, SwiftUI-native APIs.

**Note**: The framework is currently targeting beta iOS 26.0 / macOS 26.0 APIs. Platform availability requirements may be adjusted as the OS releases finalize.

## Build Commands

```bash
# Build the package
swift build

# Run all tests
swift test

# Run specific test target
swift test --filter LiquidGlassKitTests

# Build in release mode
swift build -c release

# Clean build artifacts
swift package clean

# Generate documentation
swift package generate-documentation

# Open package in Xcode to view previews
open Package.swift
```

## Project Structure

```
Sources/LiquidGlassKit/
├── Core/
│   ├── GlassConfiguration.swift    # Type-safe configuration types
│   ├── GlassEnvironment.swift      # Environment values for defaults
│   ├── GlassShapes.swift           # Shape utilities and concentricity helpers
│   └── GlassModifiers.swift        # View modifiers wrapping glass APIs
├── Components/
│   ├── Buttons/
│   │   └── LiquidGlassButton.swift         # Glass buttons (normal & prominent)
│   ├── Badges/
│   │   ├── LiquidGlassBadge.swift          # Single badges
│   │   └── LiquidGlassBadgeStack.swift     # Morphing badge clusters
│   ├── Containers/
│   │   ├── LiquidGlassPillContainer.swift  # Pill containers
│   │   └── LiquidGlassFloatingToolbar.swift # Floating toolbars
│   ├── Overlays/
│   │   ├── LiquidGlassHeroHeader.swift     # Hero headers with background extension
│   │   └── GlassDimmingLayer.swift         # Dimming layer for clear glass
│   ├── Search/
│   │   └── LiquidGlassSearchBar.swift      # Search bar variants
│   └── Navigation/
│       └── LiquidGlassNavigation.swift     # Navigation and tab bars
└── LiquidGlassKit.swift                     # Main module documentation
```

## Architecture & Design Principles

### Core Concepts

1. **Type-Safe Configuration**: All glass effects configured through `GlassConfiguration`, `GlassMaterial`, `GlassShapeStyle` enums
2. **Environment Propagation**: Glass defaults flow through view hierarchies via SwiftUI environment
3. **Platform Conventions**: Automatic iOS/macOS adaptations (capsules vs rounded rectangles, different padding)
4. **Morphing Support**: Badge stacks use `GlassEffectContainer` + `glassEffectID` + `glassEffectUnion` for smooth transitions

### Key Design Patterns

#### Configuration Over Inheritance
Components accept `GlassConfiguration` structs rather than subclassing:
```swift
let config = GlassConfiguration(
    material: .regular,
    isInteractive: true,
    shapeStyle: .capsule
)
LiquidGlassButton("Action", configuration: config) { }
```

#### Modifier-Based Customization
All customization via view modifiers:
```swift
LiquidGlassButton("Save") { }
    .controlSize(.large)
    .shape(.concentric(cornerRadius: 12))
    .tint(.blue)
```

#### Namespace-Based Morphing
Morphing badges require `@Namespace` coordination:
```swift
@Namespace var ns
LiquidGlassBadgeStack(namespace: ns) {
    GroupableLiquidGlassBadge("New", id: "badge1")
}
```

### Component Responsibilities

- **Core**: Foundational types, no SwiftUI views
- **Buttons**: Wrappers around `.buttonStyle(.glass)` with shape/size control
- **Badges**: Simple badges + morphing stacks using `GlassEffectContainer`
- **Containers**: Pills and toolbars with proper grouping
- **Overlays**: Hero headers using `backgroundExtensionEffect()`

## Important Implementation Notes

### Platform Availability
All public APIs marked `@available(iOS 26.0, macOS 15.0, *)`. The framework depends on unreleased APIs that may change.

### Shape System
Follow Apple's concentricity principle:
- iOS: Capsules for buttons/pills
- macOS: Concentric rounded rectangles for density
- Nested elements use `GlassShapes.concentricRadius(base:inset:)` to maintain alignment

### Legibility Requirements
- **Regular glass**: Automatic legibility (blur + luminosity adjustment)
- **Clear glass**: Requires 35% dimming layer over bright content
- Always use vibrant foregrounds on glass

### Morphing & Grouping
When multiple glass elements need to morph:
1. Wrap in `GlassEffectContainer`
2. Assign each element a unique ID via `.glassEffectID(_:in:)`
3. Use `.glassEffectUnion(id:in:)` for merging regions
4. Apply `.glassEffectTransition(.identity)` for smooth animations

### Performance
- Avoid nesting multiple `GlassEffectContainer`s
- One container per logical group
- Glass cannot sample glass (leads to visual artifacts)

## Common Development Tasks

### Adding a New Component
1. Create file in appropriate `Components/` subdirectory
2. Define public struct/view with `@available(iOS 26.0, macOS 26.0, *)`
3. Accept `GlassConfiguration` or use environment defaults
4. Add doc comments explaining purpose and usage
5. Add 2-4 inline previews at the bottom using `#Preview` macro showing practical variants

### Modifying Core Types
Changes to `GlassConfiguration`, `GlassMaterial`, `GlassShapeStyle` affect all components. Test thoroughly:
- Run all previews
- Verify iOS and macOS behavior
- Check shape concentricity with nested components

### Adding Environment Values
1. Add `@Entry` property to `EnvironmentValues` extension in `GlassEnvironment.swift`
2. Create corresponding `View` extension method
3. Update components to read from environment

## Testing Strategy

Currently no unit tests (SwiftUI previews serve as visual tests). When adding tests:
- Test configuration resolution (environment + explicit config)
- Test shape calculations for concentricity
- Test platform-specific behavior isolation

## Preview Organization

All component previews are **inline within their component files** using the `#Preview` macro. This modern approach provides:

- **Better maintainability**: Previews live next to the code they demonstrate
- **Faster development**: No context switching between files
- **Automatic DEBUG wrapping**: `#Preview` automatically compiles only in debug builds
- **Real scenarios**: Each component has 2-4 focused previews showing practical usage

### Preview Guidelines

When adding new components or modifying existing ones:

1. **Add 2-4 previews per component** showing:
   - Basic usage
   - Common variants (sizes, styles, states)
   - Real developer scenarios (not overly complex)
   - Interactive states using `@Previewable`

2. **Use modern SwiftUI preview patterns**:
   ```swift
   #Preview("Descriptive Name") {
       @Previewable @State var text = ""

       ComponentName(...)
           .padding()
   }
   ```

3. **Keep previews focused and copy-paste-ready**:
   - Show practical, real-world usage patterns
   - Avoid over-engineering or unnecessary complexity
   - Use descriptive preview names
   - Include comments for complex scenarios

4. **Example preview structure**:
   ```swift
   // Component implementation
   public struct MyComponent: View {
       // ... implementation
   }

   // MARK: - Previews

   #Preview("Basic Usage") {
       MyComponent()
           .padding()
   }

   #Preview("With State") {
       @Previewable @State var isSelected = false

       MyComponent(isSelected: $isSelected)
   }

   #Preview("Over Content") {
       ZStack {
           Color.blue.opacity(0.3)
           MyComponent()
       }
   }
   ```

### Current Preview Coverage

All components have inline previews:
- ✅ **Buttons** (LiquidGlassButton.swift): 4 previews - styles, icons, sizes, dark mode
- ✅ **Badges** (LiquidGlassBadge.swift): 3 previews - variants, sizes, on content
- ✅ **Badge Stacks** (LiquidGlassBadgeStack.swift): 2 previews - morphing, dynamic list
- ✅ **Pills** (LiquidGlassPillContainer.swift): 3 previews - filter chips, tag cloud, scrolling tabs
- ✅ **Toolbars** (LiquidGlassFloatingToolbar.swift): 3 previews - basic, grouped, over scrolling
- ✅ **Hero Headers** (LiquidGlassHeroHeader.swift): 3 previews - basic, with search, scrolling
- ✅ **Dimming Layer** (GlassDimmingLayer.swift): 2 previews - direct usage, modifier
- ✅ **Search Bars** (LiquidGlassSearchBar.swift): 4 previews - standard, cancel button, compact, floating
- ✅ **Navigation** (LiquidGlassNavigation.swift): 4 previews - tab bar, nav bar, variants, modifiers

### Working with Previews

To view previews:
1. Open `Package.swift` in Xcode
2. Navigate to any component file in `Sources/LiquidGlassKit/Components/`
3. Scroll to the `// MARK: - Previews` section at the bottom
4. Use Xcode's preview canvas to view and interact with previews
5. Each preview demonstrates specific component capabilities and edge cases

## Known Limitations

1. **iOS 26 / macOS 26 Beta**: APIs may change before release
2. **No AppKit Bridge**: SwiftUI-only, no direct `NSGlassEffectView` exposure
3. **Shape Type Erasure**: Custom shapes use internal `AnyShape` wrapper (may lose some type info)
4. **Button Label Constraints**: Force casts in convenience initializers (safe but inelegant)

## Debugging & Utilities

The framework provides runtime utilities for debugging:

```swift
// Check if current platform supports Liquid Glass
if LiquidGlassKit.isSupported {
    print("Liquid Glass is available")
}

// Get framework version
print("Using LiquidGlassKit \(LiquidGlassKit.version)")
```

These are useful when targeting multiple OS versions or troubleshooting platform-specific issues.

## API Stability

Public API surface is stable for 1.0. Breaking changes will require major version bump:
- `GlassConfiguration` structure
- Component initializers
- Environment key names
- Modifier signatures

Internal implementations may change freely.

## References

This framework is based on Apple's official Liquid Glass documentation:
- [HIG: Materials](https://developer.apple.com/design/Human-Interface-Guidelines/materials)
- [Landmarks Sample](https://developer.apple.com/documentation/SwiftUI/Landmarks-Building-an-app-with-Liquid-Glass)
- [Adopting Liquid Glass](https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass)
- WWDC25 Sessions: 310, 323, 356

All component designs follow Apple's patterns and recommendations.

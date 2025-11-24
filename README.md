# LiquidGlassKit

A comprehensive SwiftUI framework for building beautiful interfaces with Apple's **Liquid Glass** design system on iOS 26+ and macOS 26+.

## Overview

LiquidGlassKit provides reusable, highly-customizable components that encapsulate Apple's Liquid Glass material system. The framework handles complex glass effects, morphing animations, proper grouping, and platform conventions, allowing you to focus on building great user experiences.

### What is Liquid Glass?

Liquid Glass is Apple's dynamic material that creates functional layers floating above content. It maintains legibility through adaptive blur and luminosity adjustments while preserving visual connection to underlying content. Use it for navigation elements, floating controls, sheets, and key functional elements—never for content itself.

## Features

- ✨ **Pre-built Components**: Buttons, badges, pills, toolbars, hero headers, search bars, and navigation
- 🎨 **Type-safe Configuration**: Clean APIs with `GlassConfiguration`, `GlassMaterial`, `GlassShapeStyle`
- 🔄 **Morphing Animations**: Badge stacks with `GlassEffectContainer` support
- 📱 **Platform Conventions**: Automatic shape and sizing adjustments for iOS/macOS
- 🎯 **Environment Support**: Propagate glass defaults through view hierarchies
- 🧩 **Highly Composable**: Mix and match components for complex layouts
- 💡 **Legibility Tools**: Dimming layers and proper glass material usage

## Installation

### Swift Package Manager

Add LiquidGlassKit to your project via Xcode:

1. File → Add Package Dependencies...
2. Enter the package URL
3. Select version requirements

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/LiquidGlassKit", from: "1.0.0")
]
```

## Requirements

- iOS 26.0+ / macOS 26.0+
- Xcode 16.0+
- Swift 6.2+

## Quick Start

```swift
import SwiftUI
import LiquidGlassKit

struct ContentView: View {
    var body: some View {
        ScrollView {
            // Your content
        }
        .safeAreaInset(edge: .bottom) {
            LiquidGlassFloatingToolbar {
                LiquidGlassButton("Edit", systemImage: "pencil") {
                    // Edit action
                }

                LiquidGlassProminentButton("Save") {
                    // Save action
                }
                .tint(.blue)
            }
            .padding()
        }
    }
}
```

## Components

### Buttons

#### LiquidGlassButton

Standard button with Liquid Glass styling:

```swift
LiquidGlassButton("Continue") {
    print("Continue tapped")
}
.controlSize(.large)

LiquidGlassButton("Share", systemImage: "square.and.arrow.up") {
    print("Share tapped")
}
.tint(.blue)
```

#### LiquidGlassProminentButton

Prominent button for primary actions:

```swift
LiquidGlassProminentButton("Get Started") {
    print("Get started")
}
.tint(.blue)
.controlSize(.extraLarge)
```

### Badges

#### LiquidGlassBadge

Small informational badges:

```swift
LiquidGlassBadge("New", systemImage: "star.fill")
    .tint(.yellow)

LiquidGlassBadge("5")
    .controlSize(.small)
```

#### LiquidGlassBadgeStack

Morphing badge clusters with animations:

```swift
@Namespace var badgeNamespace
@State private var showDetails = false

LiquidGlassBadgeStack(namespace: badgeNamespace) {
    GroupableLiquidGlassBadge("New", id: "new")

    if showDetails {
        GroupableLiquidGlassBadge("5 items", id: "count")
        GroupableLiquidGlassBadge("Updated", id: "status")
    }
}
.animation(.smooth, value: showDetails)
```

### Containers

#### LiquidGlassPillContainer

Capsule-shaped containers for compact UI:

```swift
LiquidGlassPillContainer("Photos", systemImage: "photo")

LiquidGlassPillContainer(isInteractive: true) {
    Text("Tap me")
}
.onTapGesture {
    // Handle tap
}
```

#### LiquidGlassFloatingToolbar

Floating toolbars above content:

```swift
LiquidGlassFloatingToolbar {
    LiquidGlassButton("Edit", systemImage: "pencil") { }
    LiquidGlassButton("Copy", systemImage: "doc.on.doc") { }
    LiquidGlassProminentButton("Done") { }
        .tint(.blue)
}
.padding()
```

### Hero Headers

#### LiquidGlassHeroHeader

Hero headers with background extension:

```swift
LiquidGlassHeroHeader {
    Image("mountainscape")
        .resizable()
} content: {
    VStack(alignment: .leading) {
        Text("National Park")
            .font(.largeTitle)
            .fontWeight(.bold)

        Text("Yosemite Valley")
            .font(.title2)
    }
}
.height(350)
```

### Search Components

#### LiquidGlassSearchBar

Standard search bar with glass styling:

```swift
@State private var searchText = ""

LiquidGlassSearchBar(text: $searchText, prompt: "Search items")
    .padding()
```

#### HeroSearchBar

Floating search bar for hero layouts:

```swift
@State private var searchText = ""

HeroSearchBar(text: $searchText, prompt: "Search locations")
    .padding()
```

#### LiquidGlassFloatingSearchBar

Search bar that floats above content:

```swift
ZStack {
    ScrollView {
        // Content
    }

    VStack {
        LiquidGlassFloatingSearchBar(text: $searchText, prompt: "Search")
            .padding()
        Spacer()
    }
}
```

### Navigation Components

#### LiquidGlassNavigationBar

Custom navigation bar with glass styling:

```swift
VStack(spacing: 0) {
    LiquidGlassNavigationBar(
        title: "Photos",
        leading: {
            LiquidGlassButton("Back", systemImage: "chevron.left") {
                // Navigate back
            }
        },
        trailing: {
            LiquidGlassButton("Edit") {
                // Edit action
            }
        }
    )

    ScrollView {
        // Content
    }
}
```

#### Glass Navigation & Tab Bars

Apply glass to standard SwiftUI navigation:

```swift
NavigationStack {
    ContentView()
        .glassNavigationBar()
}

TabView {
    HomeView()
        .tabItem { Label("Home", systemImage: "house") }
}
.glassTabBar()
```

### Legibility & Dimming

#### GlassDimmingLayer

Required dimming layer for clear glass over bright content:

```swift
ZStack {
    // Bright background
    Image("sunset")
        .resizable()
        .overlay {
            GlassDimmingLayer() // Add 35% dimming
        }

    // Clear glass UI
    VStack {
        LiquidGlassButton("Action") { }
            .liquidGlassBackground(material: .clear)
    }
}
```

Or use the convenience modifier:

```swift
Image("sunset")
    .resizable()
    .glassDimming()
```

## Configuration

### Glass Materials

```swift
// Regular glass (default) - maintains legibility
.liquidGlassBackground(material: .regular)

// Clear glass - requires 35% dimming layer
.liquidGlassBackground(material: .clear)

// Interactive glass - shimmer/bounce on interaction
.liquidGlassBackground(.interactive)
```

### Shape Styles

```swift
// Capsule (default for iOS)
LiquidGlassButton("Action") { }
    .shape(.capsule)

// Concentric rounded rectangle (macOS style)
LiquidGlassButton("Action") { }
    .shape(.concentric(cornerRadius: 12))

// Fixed corner radius
LiquidGlassButton("Action") { }
    .shape(.fixed(cornerRadius: 8))
```

### Environment Defaults

Propagate glass settings through view hierarchies:

```swift
VStack {
    // All glass components use clear material by default
    LiquidGlassButton("Button 1") { }
    LiquidGlassButton("Button 2") { }
    LiquidGlassBadge("Badge")
}
.defaultGlassMaterial(.clear)
.defaultGlassControlSize(.large)
```

## Advanced Usage

### Morphing Badge Groups

```swift
@Namespace var namespace
@State private var isMerged = false

LiquidGlassBadgeCluster(
    namespace: namespace,
    unionID: "badge-group",
    isMerged: isMerged
) {
    GroupableLiquidGlassBadge("3", systemImage: "star.fill", id: "stars")
    GroupableLiquidGlassBadge("12", systemImage: "heart.fill", id: "likes")
}
.animation(.smooth, value: isMerged)
```

### Custom Glass Configuration

```swift
let config = GlassConfiguration(
    material: .regular,
    isInteractive: true,
    tint: .purple,
    shapeStyle: .concentric(cornerRadius: 16)
)

LiquidGlassPillContainer(configuration: config) {
    Label("Custom", systemImage: "star")
}
```

### Sidebar with Hero Layout

```swift
SidebarWithHeroLayout {
    Image("heroImage")
} sidebar: {
    List {
        ForEach(items) { item in
            NavigationLink(item.name, value: item)
        }
    }
} detail: {
    DetailView()
}
```

## Design Guidelines

### When to Use Liquid Glass

✅ **Do use for:**
- Navigation elements (tab bars, sidebars, toolbars)
- Floating controls
- Sheets and presentations
- Key functional elements
- Search bars
- Badges and status indicators

❌ **Don't use for:**
- Content layer elements
- Purely decorative purposes
- Non-interactive elements
- Text-heavy content
- Overuse in custom controls

### Legibility Requirements

- **Regular glass**: Automatically maintains legibility
- **Clear glass**: Add 35% dimming layer when over bright content
- Use vibrant foregrounds for text and symbols
- Ensure proper separation from content layer

### Shape System

Follow Apple's concentricity principle:
- **iOS**: Prefer capsule shapes for buttons and pills
- **macOS**: Prefer concentric rounded rectangles for density
- Align corner radii around shared centers when nesting
- Use platform-appropriate defaults

## Examples

The framework includes comprehensive previews:

- **ButtonPreviews**: All button variants, sizes, and styles
- **BadgePreviews**: Badges, morphing stacks, and animations
- **PillContainerPreviews**: Pills, filters, and scrolling stacks
- **ToolbarPreviews**: Floating toolbars with various configurations
- **HeroHeaderPreviews**: Hero headers and search bars
- **ShowcasePreviews**: Complete app layouts (gallery, maps, social feed, media player, settings)

Run the previews in Xcode to explore all components interactively.

## Architecture

```
LiquidGlassKit/
├── Core/
│   ├── GlassConfiguration.swift    # Type-safe configuration
│   ├── GlassEnvironment.swift      # Environment values
│   ├── GlassShapes.swift           # Shape utilities
│   └── GlassModifiers.swift        # View modifiers
├── Components/
│   ├── Buttons/                    # Button components
│   ├── Badges/                     # Badge components
│   ├── Containers/                 # Container components
│   └── Overlays/                   # Hero headers and layouts
└── Previews/                       # SwiftUI previews
```

## Contributing

Contributions are welcome! Please follow Apple's design guidelines when proposing new components.

## License

MIT License - See LICENSE file for details

## Resources

- [Human Interface Guidelines - Materials](https://developer.apple.com/design/Human-Interface-Guidelines/materials)
- [Adopting Liquid Glass](https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass)
- [WWDC25 Session 323: Build a SwiftUI app with the new design](https://developer.apple.com/videos/play/wwdc2025/323/)
- [WWDC25 Session 356: Get to know the new design system](https://developer.apple.com/videos/play/wwdc2025/356/)

## Author

Created with care for the Apple developer community.

---

**Note**: This framework requires iOS 26+ / macOS 26+. Some APIs are newly released and may evolve in future OS updates.

# Tryptiq Technical Documentation

This document provides comprehensive technical information for developers working with or contributing to the Tryptiq codebase.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Core Components](#core-components)
3. [Data Flow](#data-flow)
4. [UI Framework Details](#ui-framework-details)
5. [File Handling](#file-handling)
6. [Export System](#export-system)
7. [Performance Considerations](#performance-considerations)
8. [Build Configuration](#build-configuration)
9. [Development Setup](#development-setup)
10. [Contributing Guidelines](#contributing-guidelines)

## Architecture Overview

Tryptiq follows a modern SwiftUI architecture with reactive state management and clear separation of concerns.

### Design Patterns

- **MVVM (Model-View-ViewModel)**: Core SwiftUI pattern
- **Reactive Programming**: Combine framework for state management  
- **Component-Based Architecture**: Reusable UI components
- **Protocol-Oriented Programming**: Swift best practices

### Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| UI Framework | SwiftUI | Declarative UI with reactive updates |
| State Management | @State, @Binding, @ObservedObject | Local and shared state |
| Image Processing | Core Graphics, NSImage | High-performance image operations |
| File I/O | Foundation, AppKit | File dialogs and system integration |
| Drag & Drop | UTType, NSItemProvider | Cross-app content transfer |
| App Lifecycle | SwiftUI App | Modern app structure |

### Project Structure

```
Tryptiq/
├── TryptiqApp.swift           # App entry point, window configuration
├── ContentView.swift          # Root view container
├── TriptychView.swift         # Main interface coordinator
├── ImageSlot.swift           # Reusable image container component
├── TryptiqLogo.swift         # App branding and icon generation
├── Assets.xcassets/          # Visual assets and app icons
├── Preview Content/          # SwiftUI preview resources
├── Tryptiq.entitlements     # App sandbox permissions
└── Info.plist              # App metadata and configuration
```

## Core Components

### TryptiqApp.swift

**Purpose**: Application entry point and global configuration

```swift
// Key responsibilities:
- App lifecycle management
- Window configuration and sizing policies
- Scene management
- Global app state initialization
```

**Key Features**:
- Window sizing: Minimum 1000×700, content-based expansion
- Modern SwiftUI App lifecycle
- Scene-based architecture for future multi-window support

### ContentView.swift

**Purpose**: Root view wrapper and navigation container

```swift
// Minimal coordinator that:
- Provides app-wide styling context
- Houses the main TriptychView
- Enables future navigation/routing
- Maintains consistent theming
```

### TriptychView.swift

**Purpose**: Main application interface and state coordinator

```swift
// State Management:
@State private var leftImage: NSImage?
@State private var centerImage: NSImage?
@State private var rightImage: NSImage?
@State private var imageScale: Double = 0.8
@State private var aspectRatio: String = "16:9"

// Drag & Drop State:
@State private var draggedImage: NSImage?
@State private var draggedFromSlot: SlotPosition?
@State private var leftDragOver: Bool = false
// ... additional drag state
```

**Key Responsibilities**:
- Image state management across three slots
- Canvas rendering with GeometryReader
- Drag-and-drop coordination
- Export functionality
- UI layout and responsive design

**Critical Methods**:
- `handleImageDrop()`: Core logic for image swapping vs adding
- `exportTriptych()`: High-quality image export with NSSavePanel
- `canvasPreview()`: Dynamic canvas rendering based on geometry

### ImageSlot.swift

**Purpose**: Individual image container with drag-drop capabilities

```swift
// Component State:
@State private var isHovered: Bool = false
@State private var dragOffset: CGSize = .zero

// Props:
let image: NSImage?
let position: SlotPosition
let scale: Double
let size: CGSize
@Binding var isDragOver: Bool
```

**Features**:
- Visual feedback for hover and drag states
- Drag source initiation for image rearranging
- Remove button with confirmation
- Responsive scaling and positioning
- Border effects for drag feedback

**Drag Behavior**:
- **onDrag**: Initiates internal rearranging
- **Drop handling**: Managed by parent TriptychView
- **Visual states**: Hover, drag-over, normal

### TryptiqLogo.swift

**Purpose**: App branding and icon generation utilities

```swift
// Core logo rendering:
- Gradient background (blue to purple)
- Three white rectangles representing triptych
- Scalable vector-like approach using Core Graphics
- PNG export capabilities for app icons
```

## Data Flow

### Image Management Flow

```
User Action → State Update → UI Refresh → Export Ready

1. User drags image from Finder
2. ImageDropDelegate.performDrop() called
3. State updated in TriptychView
4. SwiftUI automatically re-renders affected components
5. Export button enabled when images present
```

### Drag & Drop Flow

```
Internal Rearranging:
ImageSlot.onDrag → draggedImage set → ImageDropDelegate → handleImageDrop → swap logic

External Image Addition:
Finder → ImageDropDelegate → new image detection → slot assignment
```

### Export Flow

```
User clicks Export → exportTriptych() → 
NSSavePanel → file location → 
NSImage rendering → Core Graphics → 
PNG data generation → file write
```

## UI Framework Details

### SwiftUI Architecture

**State Management Strategy**:
- `@State` for local component state
- `@Binding` for parent-child communication  
- Minimal external dependencies for maintainability

**Layout System**:
- GeometryReader for responsive canvas sizing
- HStack/VStack for predictable layouts
- Custom spacing and padding for visual consistency

**Animation Framework**:
```swift
.animation(.easeInOut(duration: 0.1), value: imageScale)
.animation(.spring(response: 0.3), value: isDragOver)
```

### Responsive Design

**GeometryReader Implementation**:
```swift
GeometryReader { geometry in
    canvasPreview(size: geometry.size)
}
```

**Adaptive Calculations**:
- Canvas size based on available space
- Image slot dimensions calculated proportionally
- Spacing adjustments for different screen sizes

### Visual Design System

**Color Palette**:
```swift
// Gradient colors (consistent across app)
Color(red: 0.2, green: 0.4, blue: 0.9)  // Primary blue
Color(red: 0.5, green: 0.2, blue: 0.8)  // Secondary purple

// Background colors
Color(red: 0.05, green: 0.05, blue: 0.08)  // Dark background
Color(red: 0.08, green: 0.08, blue: 0.12)  // Slightly lighter
```

## File Handling

### Supported Image Formats

**Input Formats** (via UTType.image):
- JPEG, PNG, TIFF, GIF, BMP
- HEIC, WebP (modern formats)
- Most RAW formats (camera files)

**Format Detection**:
```swift
.onDrop(of: [UTType.image], delegate: ImageDropDelegate(...))
```

### File I/O Architecture

**Reading Images**:
- NSItemProvider for drag-drop data
- NSImage for in-memory representation
- Automatic format detection and conversion

**Saving Images**:
- NSSavePanel for user file selection
- Core Graphics for high-quality rendering
- PNG format for lossless output

### App Sandboxing

**Entitlements** (Tryptiq.entitlements):
```xml
<key>com.apple.security.files.user-selected.read-write</key>
<true/>
```

**Security Model**:
- User-selected file access only
- No arbitrary file system access
- Temporary file handling for drag-drop
- Secure save location selection

## Export System

### Resolution Calculation

**Adaptive Resolution Algorithm**:
```swift
// Pseudo-code for export sizing:
let maxDimension = max(leftImage.width, centerImage.width, rightImage.width)
let exportHeight = max(maxDimension, 1200) // Minimum quality threshold
let exportWidth = exportHeight * aspectRatio
```

**Quality Preservation**:
- No upscaling of source images beyond 100%
- Maintains original aspect ratios
- High-quality interpolation for scaling operations

### Image Rendering Pipeline

```swift
// Export rendering process:
1. Create NSImage with calculated dimensions
2. Lock focus for Core Graphics context
3. Render each image slot with proper positioning
4. Apply scaling and spacing calculations
5. Generate PNG representation
6. Write to user-selected file location
```

**Core Graphics Integration**:
- CGContext for precise image placement
- CTM (Current Transformation Matrix) for scaling
- High-quality interpolation modes
- Color space preservation

## Performance Considerations

### Memory Management

**Large Image Handling**:
- NSImage automatically manages memory for large files
- SwiftUI lazy loading for off-screen elements
- Automatic memory pressure handling

**State Optimization**:
- Minimal state copying with `@Binding`
- Efficient re-render triggers
- Lazy evaluation where possible

### Rendering Performance

**SwiftUI Optimizations**:
```swift
// Efficient image rendering:
Image(nsImage: image)
    .resizable()
    .aspectRatio(contentMode: .fill)
    .clipped()  // Prevents overdraw
```

**Frame Rate Considerations**:
- 60fps target for animations
- Smooth drag-and-drop feedback
- Responsive UI during image processing

### Build Performance

**Compilation Speed**:
- Modular component structure reduces rebuild times
- Minimal external dependencies
- SwiftUI preview optimization

## Build Configuration

### Xcode Project Settings

**Deployment Target**: macOS 14.0 (Sonoma)
**Swift Version**: 5.9+
**Architecture**: Universal (Apple Silicon + Intel)

**Build Settings**:
```
SWIFT_VERSION = 5.0
MACOSX_DEPLOYMENT_TARGET = 14.0
ENABLE_HARDENED_RUNTIME = YES
CODE_SIGN_STYLE = Automatic
```

### App Configuration

**Bundle Identifier**: `com.yourname.Tryptiq`
**Version Management**: Manual (update in project settings)
**App Category**: Graphics & Design

**Entitlements**:
- Hardened Runtime
- User Selected Files (Read/Write)
- App Sandbox enabled

### Asset Management

**App Icons**:
- 10 sizes from 16×16 to 1024×1024
- @1x and @2x variants for Retina displays
- Generated programmatically via TryptiqLogo

**Color Assets**:
- AccentColor for system integration
- Semantic colors for dark mode compatibility

## Development Setup

### Prerequisites

- **Xcode 15.0+** (for macOS 14.0 support)
- **macOS 14.0+** (Sonoma) for development
- **Apple Developer Account** (for code signing)

### Getting Started

```bash
# Clone the repository
git clone https://github.com/yourname/tryptiq.git
cd tryptiq

# Open in Xcode
open Tryptiq.xcodeproj

# Build and run (⌘+R)
# Or use Xcode's play button
```

### Development Workflow

1. **Feature Development**:
   - Create feature branch
   - Implement changes with SwiftUI previews
   - Test with various image formats
   - Ensure responsive behavior

2. **Testing**:
   - Test drag-and-drop from multiple sources
   - Verify export quality with different image sizes
   - Check memory usage with large images
   - Validate on different screen sizes

3. **Code Review**:
   - SwiftUI best practices
   - Performance implications
   - Accessibility considerations
   - Documentation updates

### Debugging Tips

**SwiftUI Preview Issues**:
```swift
#Preview {
    TriptychView()
        .frame(width: 1000, height: 700)
        .background(Color.black)
}
```

**State Debugging**:
- Use print statements in state setters
- Xcode's SwiftUI inspector for view hierarchy
- Memory graph debugger for retain cycles

**Image Processing Debugging**:
- Check NSImage.isValid property
- Verify image dimensions before processing
- Log file paths and sizes during import

## Contributing Guidelines

### Code Style

**SwiftUI Conventions**:
- Prefer declarative syntax over imperative
- Use descriptive variable names
- Comment complex state interactions
- Maintain consistent spacing and formatting

**State Management**:
- Minimize state scope (prefer @State over @ObservableObject)
- Use @Binding for parent-child communication
- Avoid unnecessary state dependencies

### Performance Guidelines

**Image Handling**:
- Test with large images (>50MB)
- Verify memory usage during development
- Optimize for common use cases

**UI Responsiveness**:
- Maintain 60fps during animations
- Avoid blocking the main thread
- Use background queues for image processing when needed

### Testing Requirements

**Functional Testing**:
- Drag-and-drop from Finder, Photos app
- Export with various image combinations
- Responsive behavior at different window sizes
- Error handling for unsupported formats

**Edge Cases**:
- Very large images (>100MB)
- Corrupted image files
- Network-mounted images
- Rapid user interactions

### Documentation Requirements

- Update user guide for new features
- Document breaking changes in technical docs
- Add inline code comments for complex logic
- Update README with new capabilities

---

*This technical documentation covers Tryptiq v1.0. Architecture may evolve in future versions based on feature requirements and performance considerations.* 
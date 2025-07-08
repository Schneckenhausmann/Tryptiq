# Tryptiq - Professional Triptych Creation Tool


<div align="center">
<img src="docs/images/icon-256.png" width="128" height="128"> 
<h3>Create stunning photo triptychs with elegant simplicity</h3>

![Platform](https://img.shields.io/badge/Platform-macOS-blue) ![License](https://img.shields.io/badge/License-MIT-orange) ![Swift](https://img.shields.io/badge/Swift-5.0-red)

</div>

Tryptiq is a beautiful, modern macOS application designed for photographers, artists, and creative professionals who want to create compelling three-panel compositions from their photos. With its intuitive drag-and-drop interface and powerful export capabilities, Tryptiq makes it effortless to transform your individual images into cohesive artistic statements.

## 📱 Screenshot

![Tryptiq Screenshot](docs/images/Screenshot.png)

<div align="center"> 
<p><em> Create stunning three-panel compositions with Tryptiq's intuitive interface! </em></p>
</div>

## 🎥 Video Demo

<div align="center">
  <img src="docs/images/Video.gif" alt="Tryptiq Video" width="800">
  <p><em>🎬 Watch Tryptiq in action!</em></p>
</div> 

## 📋 Supported Image Formats

**Input Formats:**
- **JPEG** (.jpg, .jpeg) - Standard photo format
- **PNG** (.png) - Lossless with transparency support  
- **TIFF** (.tiff, .tif) - High-quality uncompressed
- **HEIC/HEIF** (.heic, .heif) - Modern Apple photo format
- **GIF** (.gif) - Animated and static images
- **BMP** (.bmp) - Windows bitmap format
- **WebP** (.webp) - Modern web format

**Output Format:**
- **PNG** - High-quality lossless export optimized for printing and digital display

## ✨ Features

### 🎨 **Intuitive Creation**
- **Drag & Drop Interface**: Simply drag photos from Finder into the three image slots
- **Real-time Preview**: See your triptych composition update instantly as you work
- **Smart Rearranging**: Drag images between slots to reorder your composition
- **Responsive Canvas**: Automatically adapts to your screen size and window dimensions

### 📐 **Flexible Layout Control**
- **Multiple Aspect Ratios**: Choose from 16:9, 4:3, 1:1, or 3:2 canvas proportions
- **Precision Scaling**: Fine-tune image size with smooth 0.5x to 2.0x scaling
- **Adaptive Sizing**: Canvas intelligently adjusts to accommodate your images

### 🚀 **Professional Export**
- **High-Quality Output**: Adaptive resolution based on your source images
- **Smart Resolution**: Automatically scales to preserve image quality (minimum 1200px)
- **PNG Export**: Clean, lossless output perfect for printing or digital display
- **Instant Save**: One-click export with system file picker

### 🎭 **Beautiful Design**
- **Dark Mode**: Elegant dark interface that lets your photos shine
- **Gradient Aesthetics**: Smooth blue-to-purple gradients throughout the UI
- **Custom Icon**: Hand-crafted app icon reflecting the triptych concept
- **Smooth Animations**: Subtle, polished transitions and interactions

### ⚡ **Performance Features**
- **Real-time Processing**: Instant preview updates with smooth UI responsiveness
- **Memory Efficient**: Optimized image handling for large photo collections
- **Adaptive Resolution**: Smart scaling prevents quality loss while maintaining performance
- **Background Processing**: Non-blocking export operations keep UI responsive
- **Smart Caching**: Optimized image loading and preview generation

## 🖥️ System Requirements

- **macOS**: 14.0 (Sonoma) or later
- **Architecture**: Universal (Apple Silicon + Intel)
- **Memory**: 4GB RAM recommended
- **Storage**: 50MB for application
- **Development**: Xcode 14.0+ (for building from source)

## 🚀 Quick Start

### Download & Install
1. Download the latest `Tryptiq.dmg` from [Releases](releases/)
2. Double-click to mount the disk image
3. Drag Tryptiq to your Applications folder
4. Launch from Applications or Spotlight

### First Launch
- macOS may show a security warning - right-click the app and select "Open"
- Grant file access permissions when prompted for optimal experience

## 🏗️ Building from Source

### Option 1: Using Xcode (Recommended)
```bash
# Clone the project
git clone https://github.com/yourname/tryptiq.git
cd tryptiq

# Open in Xcode
open Tryptiq.xcodeproj
```
- Press `Cmd+R` to build and run
- Or use `Product` → `Run`

### Option 2: Command Line Build
```bash
# Build for release
xcodebuild -project Tryptiq.xcodeproj -scheme Tryptiq -configuration Release build

# Locate built app
open build/Release/
```

## 📖 How to Use

### Creating Your First Triptych

1. **Launch Tryptiq** - Open the app from your Applications folder
2. **Select Canvas Format** - Choose your preferred aspect ratio:
   - **16:9** - Widescreen format for digital displays
   - **4:3** - Classic photo proportions
   - **1:1** - Square format for social media
   - **3:2** - Traditional photography ratio
3. **Add Images** - Drag photos from Finder into the three panels:
   - **Left Panel** - Your opening image
   - **Center Panel** - The focal centerpiece
   - **Right Panel** - Your closing composition
4. **Arrange & Scale**:
   - **Rearrange**: Drag images between slots to reorder
   - **Scale**: Use the slider to resize all images (0.5x to 2.0x)
   - **Preview**: Watch real-time updates as you adjust
5. **Export Your Creation**:
   - Click "Export Triptych"
   - Choose save location in the file picker
   - Your triptych saves as a high-quality PNG

### Advanced Techniques

#### Image Rearranging
- **Internal Drag**: Drag any image to a different slot to swap positions
- **Visual Feedback**: Hover effects show valid drop zones
- **Smart Swapping**: Images automatically exchange positions

#### Optimal Composition Tips
- **Rule of Thirds**: Consider visual balance across all three panels
- **Color Harmony**: Choose images with complementary color palettes
- **Narrative Flow**: Create visual stories that read from left to right
- **Scale Consistency**: Use similar scaling for cohesive appearance

## ⚙️ Processing Algorithm

### Canvas Calculation
1. **Aspect Ratio Application**: Canvas dimensions calculated from selected ratio
2. **Adaptive Resolution**: Base resolution determined by largest source image
3. **Quality Preservation**: Minimum 1200px width ensures print quality
4. **Proportional Scaling**: Images scaled to fit while maintaining aspect ratios
5. **Center Positioning**: All images centered within their respective panels

### Export Process
- **Resolution Analysis**: Examines all source images for optimal output size
- **Smart Scaling**: Uses `max(largest_dimension, 1200px)` as baseline
- **Quality Interpolation**: High-quality resampling prevents artifacts
- **Format Optimization**: PNG export with optimal compression settings

## 🔧 Troubleshooting

### Installation Issues
- **Gatekeeper Warning**: Right-click app and select "Open" to bypass security warning
- **Permission Denied**: Check `System Settings` → `Privacy & Security`
- **App Won't Launch**: Ensure macOS 14.0+ and try restarting

### Runtime Issues
- **Images Won't Drop**: Ensure files are supported formats and not corrupted
- **Slow Performance**: Try smaller images or restart the app to clear memory
- **Export Fails**: Check destination folder permissions and available disk space
- **Low Quality Output**: Use higher resolution source images for better results

### Interface Issues
- **UI Not Responsive**: Restart app or check Activity Monitor for high CPU usage
- **Canvas Too Small**: Resize window or select different aspect ratio
- **Images Appear Blurry**: Ensure scaling is appropriate and source quality is good

## 📚 Documentation

For detailed guides and technical information, see our [Documentation](docs/):

- [User Guide](docs/user-guide.md) - Complete step-by-step instructions
- [Technical Documentation](docs/technical.md) - Developer information and architecture
- [Release Notes](docs/releases.md) - Version history and changes

## 🏗️ Project Structure

```
Tryptiq/
├── Tryptiq.xcodeproj/          # Xcode project configuration
│   ├── project.pbxproj         # Build settings and file references
│   └── xcshareddata/           # Shared schemes and settings
├── Tryptiq/                    # Source code directory
│   ├── TryptiqApp.swift        # App entry point and window configuration
│   ├── ContentView.swift       # Root view wrapper
│   ├── TriptychView.swift      # Main interface with image slots and controls
│   ├── ImageSlot.swift         # Individual draggable image containers
│   ├── TryptiqLogo.swift       # Custom app icon and branding
│   ├── Assets.xcassets/        # App icons, colors, and visual assets
│   ├── Preview Content/        # SwiftUI preview assets
│   ├── Tryptiq.entitlements   # App sandbox permissions
│   └── Info.plist             # App metadata and configuration
├── docs/                       # Documentation and guides
│   ├── images/                 # Screenshots and assets
│   ├── user-guide.md          # Comprehensive user manual
│   ├── technical.md           # Architecture and development docs
│   └── releases.md            # Version history and roadmap
├── LICENSE                     # MIT License
└── README.md                   # This file
```

## 🛠️ Technical Architecture

Tryptiq is built with modern Apple technologies for optimal performance and native macOS integration:

### Core Technologies
- **SwiftUI**: Declarative UI framework for smooth, responsive interface
- **Combine**: Reactive programming for state management and data flow
- **Core Graphics**: High-performance image processing and rendering
- **AppKit Integration**: Native file dialogs and system services
- **App Sandboxing**: Secure, permission-based file access

### Key Components
- **TriptychView**: Main interface coordinating image slots and export functionality
- **ImageSlot**: Reusable component handling drag-drop, scaling, and visual feedback  
- **ImageDropDelegate**: Custom drop handling for internal rearranging vs external drops
- **Adaptive Layout**: GeometryReader-based responsive design system

### Performance Optimizations
- **Asynchronous Processing**: Background image operations keep UI responsive
- **Memory Management**: Efficient image loading and disposal patterns
- **Real-time Updates**: Optimized preview generation and caching
- **Smart Rendering**: Conditional updates based on state changes

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](docs/contributing.md) for details.

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

### Ways to Contribute
- **Bug Reports**: Found an issue? [Open an issue](issues/new)
- **Feature Requests**: Have an idea? [Start a discussion](discussions/)
- **Code Contributions**: Submit pull requests for fixes or enhancements
- **Documentation**: Help improve our guides and examples
- **Testing**: Try beta versions and provide feedback

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with ❤️ using SwiftUI and AppKit
- Inspired by the artistic tradition of triptych art and the need for modern creative tools
- Special thanks to the Swift and macOS developer communities
- Thanks to all beta testers and contributors who helped shape Tryptiq

---

**Made with ❤️ for photographers, creators, and professionals**

If you find Tryptiq useful, please consider ⭐ starring the repository!
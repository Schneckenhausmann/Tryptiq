import SwiftUI
import UniformTypeIdentifiers

enum AspectRatio: String, CaseIterable {
    case sixteenToNine = "16:9"
    case fourToThree = "4:3"
    case square = "1:1"
    case threeToTwo = "3:2"
    
    var ratio: Double {
        switch self {
        case .sixteenToNine: return 16.0 / 9.0
        case .fourToThree: return 4.0 / 3.0
        case .square: return 1.0
        case .threeToTwo: return 3.0 / 2.0
        }
    }
}

struct TriptychView: View {
    @State private var leftImage: NSImage?
    @State private var centerImage: NSImage?
    @State private var rightImage: NSImage?
    @State private var imageScale: Double = 0.8
    @State private var selectedAspectRatio: AspectRatio = .sixteenToNine
    @State private var draggedImage: NSImage?
    @State private var draggedFromSlot: SlotPosition?
    
    // Drag-over visual feedback state
    @State private var leftDragOver = false
    @State private var centerDragOver = false
    @State private var rightDragOver = false
    
    private let imageSpacing: CGFloat = 12
    
    // Dynamic canvas size based on available space
    private func canvasSize(in geometry: GeometryProxy) -> CGSize {
        let availableWidth = geometry.size.width - 80 // Padding
        let availableHeight = geometry.size.height - 400 // Space for header and controls
        
        let maxCanvasWidth = min(800, availableWidth)
        let maxCanvasHeight = min(450, availableHeight)
        
        let targetRatio = selectedAspectRatio.ratio
        let maxRatio = maxCanvasWidth / maxCanvasHeight
        
        if targetRatio > maxRatio {
            // Fit to width
            return CGSize(width: maxCanvasWidth, height: maxCanvasWidth / targetRatio)
        } else {
            // Fit to height
            return CGSize(width: maxCanvasHeight * targetRatio, height: maxCanvasHeight)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let actualCanvasSize = canvasSize(in: geometry)
            
            VStack(spacing: 30) {
                // Header with logo - centered
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        TryptiqLogo(size: 40)
                        
                        Text("Tryptiq")
                            .font(.system(size: 32, weight: .light, design: .default))
                            .foregroundColor(.white)
                    }
                    
                    Text("Create beautiful triptychs from your photos")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 30)
                
                // Canvas Preview - Responsive size
                canvasPreview(size: actualCanvasSize)
                    .frame(width: actualCanvasSize.width, height: actualCanvasSize.height)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                
                // Controls
                VStack(spacing: 20) {
                    // Aspect Ratio Control
                    VStack(spacing: 12) {
                        Text("Canvas Aspect Ratio")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Picker("Aspect Ratio", selection: $selectedAspectRatio) {
                            ForEach(AspectRatio.allCases, id: \.self) { ratio in
                                Text(ratio.rawValue).tag(ratio)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 280)
                    }
                    
                    // Scale Control
                    VStack(spacing: 12) {
                        Text("Image Scale")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 16) {
                            Text("0.5x")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Slider(value: $imageScale, in: 0.5...2.0, step: 0.1)
                                .frame(width: 200)
                                .accentColor(.white)
                            
                            Text("2.0x")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        
                        Text(String(format: "%.1fx", imageScale))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    // Export Button
                    Button(action: exportTriptych) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 14, weight: .medium))
                            Text("Export Triptych")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.2, green: 0.4, blue: 0.9),
                                    Color(red: 0.5, green: 0.2, blue: 0.8)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.2),
                                            Color.clear
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .scaleEffect(1.0)
                    .animation(.easeInOut(duration: 0.1), value: leftImage != nil || centerImage != nil || rightImage != nil)
                    .disabled(leftImage == nil && centerImage == nil && rightImage == nil)
                    .opacity((leftImage == nil && centerImage == nil && rightImage == nil) ? 0.5 : 1.0)
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.05, green: 0.05, blue: 0.08),
                        Color(red: 0.08, green: 0.08, blue: 0.12)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
    }
    
    private func canvasPreview(size: CGSize) -> some View {
        let slotWidth = (size.width - (imageSpacing * 2)) / 3
        let slotHeight = size.height
        
        return HStack(spacing: imageSpacing) {
            ImageSlot(
                image: leftImage,
                position: .left,
                scale: imageScale,
                size: CGSize(width: slotWidth, height: slotHeight),
                isDragOver: $leftDragOver,
                onImageDropped: { image in
                    leftImage = image
                },
                onImageRemoved: {
                    leftImage = nil
                },
                onDragStarted: { image in
                    draggedImage = image
                    draggedFromSlot = .left
                }
            )
            .onDrop(of: [UTType.image], delegate: ImageDropDelegate(
                targetSlot: .left,
                draggedFromSlot: $draggedFromSlot,
                draggedImage: $draggedImage,
                isDragOver: $leftDragOver,
                onDrop: handleImageDrop
            ))
            
            ImageSlot(
                image: centerImage,
                position: .center,
                scale: imageScale,
                size: CGSize(width: slotWidth, height: slotHeight),
                isDragOver: $centerDragOver,
                onImageDropped: { image in
                    centerImage = image
                },
                onImageRemoved: {
                    centerImage = nil
                },
                onDragStarted: { image in
                    draggedImage = image
                    draggedFromSlot = .center
                }
            )
            .onDrop(of: [UTType.image], delegate: ImageDropDelegate(
                targetSlot: .center,
                draggedFromSlot: $draggedFromSlot,
                draggedImage: $draggedImage,
                isDragOver: $centerDragOver,
                onDrop: handleImageDrop
            ))
            
            ImageSlot(
                image: rightImage,
                position: .right,
                scale: imageScale,
                size: CGSize(width: slotWidth, height: slotHeight),
                isDragOver: $rightDragOver,
                onImageDropped: { image in
                    rightImage = image
                },
                onImageRemoved: {
                    rightImage = nil
                },
                onDragStarted: { image in
                    draggedImage = image
                    draggedFromSlot = .right
                }
            )
            .onDrop(of: [UTType.image], delegate: ImageDropDelegate(
                targetSlot: .right,
                draggedFromSlot: $draggedFromSlot,
                draggedImage: $draggedImage,
                isDragOver: $rightDragOver,
                onDrop: handleImageDrop
            ))
        }
        .frame(width: size.width, height: size.height)
        .padding(imageSpacing)
    }
    
    private func handleImageDrop(targetSlot: SlotPosition, sourceSlot: SlotPosition?, image: NSImage) {
        print("handleImageDrop called - Target: \(targetSlot), Source: \(sourceSlot?.debugDescription ?? "nil")")
        
        if let sourceSlot = sourceSlot, sourceSlot != targetSlot {
            // This is an internal rearrange operation - swap the images
            let targetImage = getImage(for: targetSlot)
            
            print("Swapping images: \(sourceSlot) ↔ \(targetSlot)")
            print("  - Moving \(sourceSlot) image to \(targetSlot)")
            print("  - Moving \(targetSlot) image to \(sourceSlot)")
            
            // Perform the swap
            setImage(image, for: targetSlot)           // Place dragged image in target
            setImage(targetImage, for: sourceSlot)     // Place target's image in source (can be nil)
            
        } else if sourceSlot == nil {
            // This is a new image drop from outside the app
            print("Adding new external image to \(targetSlot)")
            setImage(image, for: targetSlot)
            
        } else {
            // sourceSlot == targetSlot (dropping in same place)
            print("Dropping image in same slot \(targetSlot) - no change needed")
        }
        
        // Reset drag state
        draggedImage = nil
        draggedFromSlot = nil
        print("Drag state reset")
    }
    
    private func getImage(for slot: SlotPosition) -> NSImage? {
        switch slot {
        case .left: return leftImage
        case .center: return centerImage
        case .right: return rightImage
        }
    }
    
    private func setImage(_ image: NSImage?, for slot: SlotPosition) {
        switch slot {
        case .left: leftImage = image
        case .center: centerImage = image
        case .right: rightImage = image
        }
    }
    
    private func exportTriptych() {
        // Check if there are any images to export
        guard leftImage != nil || centerImage != nil || rightImage != nil else {
            return
        }
        
        // Create the image on the main thread
        let triptychImage = createTriptychImage()
        
        // Create save panel on main thread
        let savePanel = NSSavePanel()
        savePanel.title = "Export Triptych"
        savePanel.nameFieldStringValue = "Triptych.png"
        savePanel.allowedContentTypes = [.png]
        
        if savePanel.runModal() == .OK {
            guard let url = savePanel.url else { return }
            
            // Convert to PNG data
            guard let tiffData = triptychImage.tiffRepresentation,
                  let bitmap = NSBitmapImageRep(data: tiffData),
                  let pngData = bitmap.representation(using: .png, properties: [:]) else {
                print("Failed to create image data")
                return
            }
            
            // Save file
            do {
                try pngData.write(to: url)
                print("Triptych exported successfully to: \(url.path)")
            } catch {
                print("Failed to save file: \(error)")
            }
        }
    }
    
    private func createTriptychImage() -> NSImage {
        let imageSpacing: CGFloat = 12
        
        // Calculate optimal canvas size based on uploaded images
        var maxImageHeight: CGFloat = 800 // Minimum height fallback
        var maxImageWidth: CGFloat = 600 // Minimum width fallback
        
        let images = [leftImage, centerImage, rightImage].compactMap { $0 }
        
        if !images.isEmpty {
            // Find the maximum dimensions from uploaded images
            maxImageHeight = images.map { $0.size.height }.max() ?? maxImageHeight
            maxImageWidth = images.map { $0.size.width }.max() ?? maxImageWidth
            
            // Use the larger of the two as base for quality
            let baseSize = max(maxImageHeight, maxImageWidth)
            
            // Set canvas height to match the highest quality image (or slightly larger)
            maxImageHeight = max(baseSize, 1200) // Ensure minimum quality
        }
        
        // Calculate canvas dimensions
        let canvasHeight = maxImageHeight
        let canvasWidth = canvasHeight * selectedAspectRatio.ratio
        let slotWidth = (canvasWidth - (imageSpacing * 2)) / 3
        let slotHeight = canvasHeight
        
        print("Export canvas size: \(canvasWidth) × \(canvasHeight)")
        
        let triptychImage = NSImage(size: NSSize(width: canvasWidth, height: slotHeight))
        
        triptychImage.lockFocus()
        
        // White background
        NSColor.white.setFill()
        NSRect(x: 0, y: 0, width: canvasWidth, height: slotHeight).fill()
        
        // Draw images with high quality
        let imageSlots = [leftImage, centerImage, rightImage]
        for (index, image) in imageSlots.enumerated() {
            guard let img = image else { continue }
            
            let xPosition = CGFloat(index) * (slotWidth + imageSpacing) + imageSpacing
            
            // Calculate scaled size maintaining aspect ratio
            let imageAspectRatio = img.size.width / img.size.height
            let slotAspectRatio = slotWidth / slotHeight
            
            var scaledSize: NSSize
            if imageAspectRatio > slotAspectRatio {
                // Image is wider - fit to width
                scaledSize = NSSize(width: slotWidth * imageScale, height: (slotWidth * imageScale) / imageAspectRatio)
            } else {
                // Image is taller - fit to height
                scaledSize = NSSize(width: (slotHeight * imageScale) * imageAspectRatio, height: slotHeight * imageScale)
            }
            
            // Center the image in the slot
            let centeredRect = NSRect(
                x: xPosition + (slotWidth - scaledSize.width) / 2,
                y: (slotHeight - scaledSize.height) / 2,
                width: scaledSize.width,
                height: scaledSize.height
            )
            
            // Use high-quality interpolation for better results
            NSGraphicsContext.current?.imageInterpolation = .high
            img.draw(in: centeredRect)
        }
        
        triptychImage.unlockFocus()
        return triptychImage
    }
}

// Drop delegate for handling image drops and reordering
struct ImageDropDelegate: DropDelegate {
    let targetSlot: SlotPosition
    @Binding var draggedFromSlot: SlotPosition?
    @Binding var draggedImage: NSImage?
    @Binding var isDragOver: Bool
    let onDrop: (SlotPosition, SlotPosition?, NSImage) -> Void
    
    func dropEntered(info: DropInfo) {
        print("Drop entered \(targetSlot)")
        isDragOver = true
    }
    
    func dropExited(info: DropInfo) {
        print("Drop exited \(targetSlot)")
        isDragOver = false
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        // Check if this is an internal drag (rearranging)
        if draggedFromSlot != nil && draggedImage != nil {
            print("Internal drag over \(targetSlot)")
            return DropProposal(operation: .move)
        }
        // External drag (new image)
        print("External drag over \(targetSlot)")
        return DropProposal(operation: .copy)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        print("performDrop called on \(targetSlot)")
        isDragOver = false // Reset visual feedback
        
        // PRIORITY 1: Handle internal drag (rearranging between slots)
        if let draggedImage = draggedImage, let sourceSlot = draggedFromSlot {
            print("✅ Internal drag detected: \(sourceSlot) → \(targetSlot)")
            onDrop(targetSlot, sourceSlot, draggedImage)
            return true
        }
        
        // PRIORITY 2: Handle external drop (new image from file system)
        guard let provider = info.itemProviders(for: [UTType.image]).first else { 
            print("❌ No image provider found")
            return false 
        }
        
        print("✅ External drop detected to slot: \(targetSlot)")
        _ = provider.loadObject(ofClass: NSImage.self) { image, error in
            DispatchQueue.main.async {
                if let nsImage = image as? NSImage {
                    print("✅ External image loaded successfully for \(self.targetSlot)")
                    self.onDrop(self.targetSlot, nil, nsImage)
                } else {
                    print("❌ Failed to load external image: \(error?.localizedDescription ?? "unknown error")")
                }
            }
        }
        return true
    }
} 
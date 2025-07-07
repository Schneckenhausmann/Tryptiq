import SwiftUI
import UniformTypeIdentifiers

enum SlotPosition {
    case left, center, right
}

extension SlotPosition: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        switch self {
        case .left: return "left"
        case .center: return "center"
        case .right: return "right"
        }
    }
    
    var debugDescription: String {
        return description
    }
}

struct ImageSlot: View {
    let image: NSImage?
    let position: SlotPosition
    let scale: Double
    let size: CGSize
    @Binding var isDragOver: Bool
    let onImageDropped: (NSImage) -> Void
    let onImageRemoved: () -> Void
    let onDragStarted: (NSImage) -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        ZStack {
            if let image = image {
                // Image with proper aspect ratio
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width, height: size.height)
                    .scaleEffect(scale)
                    .clipped()
                    .onHover { hovering in
                        isHovered = hovering
                    }
                    .onDrag {
                        onDragStarted(image)
                        return NSItemProvider(object: image)
                    }
                
                // Remove button (X) - better positioning to prevent cutoff
                if isHovered {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: onImageRemoved) {
                                ZStack {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 20, height: 20)
                                    
                                    Image(systemName: "xmark")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.top, 12)
                            .padding(.trailing, removeButtonTrailingPadding)
                        }
                        Spacer()
                    }
                    .transition(.opacity)
                }
            } else {
                // Empty slot with subtle styling
                VStack(spacing: 8) {
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(.gray.opacity(0.4))
                    
                    Text(positionText)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.gray.opacity(0.6))
                    
                    Text("Click to select or drop image here")
                        .font(.system(size: 9, weight: .regular))
                        .foregroundColor(.gray.opacity(0.4))
                        .multilineTextAlignment(.center)
                }
                .frame(width: size.width, height: size.height)
                .background(
                    Rectangle()
                        .fill(Color.gray.opacity(isDragOver ? 0.15 : 0.05))
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    openFilePicker()
                }
            }
        }
        .frame(width: size.width, height: size.height)
        .overlay(
            Rectangle()
                .stroke(
                    isDragOver && image == nil ? 
                        Color.blue.opacity(0.6) : Color.clear,
                    lineWidth: 2
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isDragOver)
        .animation(.easeInOut(duration: 0.15), value: isHovered)
    }
    
    private var removeButtonTrailingPadding: CGFloat {
        // Adjust padding based on position and prevent cutoff
        switch position {
        case .left: return 6
        case .center: return 6
        case .right: return 10 // Slightly more padding for right slot but not excessive
        }
    }
    
    private var positionText: String {
        switch position {
        case .left: return "Left Panel"
        case .center: return "Center Panel"
        case .right: return "Right Panel"
        }
    }
    
    private func openFilePicker() {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [
            .jpeg, .png, .tiff, .gif, .bmp, .heic,
            UTType(filenameExtension: "webp") ?? .image
        ]
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        
        if openPanel.runModal() == .OK {
            if let url = openPanel.url,
               let image = NSImage(contentsOf: url) {
                onImageDropped(image)
            }
        }
    }
} 
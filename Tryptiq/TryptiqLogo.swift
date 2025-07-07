import SwiftUI

struct TryptiqLogo: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.2, green: 0.4, blue: 0.9),
                            Color(red: 0.5, green: 0.2, blue: 0.8)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
            
            // Three distinct blocks representing triptych
            HStack(spacing: size * 0.03) {
                // Left block
                Rectangle()
                    .fill(Color.white.opacity(0.95))
                    .frame(width: size * 0.11, height: size * 0.35)
                    .cornerRadius(size * 0.015)
                
                // Center block
                Rectangle()
                    .fill(Color.white.opacity(0.95))
                    .frame(width: size * 0.11, height: size * 0.35)
                    .cornerRadius(size * 0.015)
                
                // Right block
                Rectangle()
                    .fill(Color.white.opacity(0.95))
                    .frame(width: size * 0.11, height: size * 0.35)
                    .cornerRadius(size * 0.015)
            }
        }
    }
    
    // Function to export logo as NSImage
    func asNSImage() -> NSImage {
        let image = NSImage(size: CGSize(width: size, height: size))
        
        image.lockFocus()
        
        // Draw background circle with gradient
        let context = NSGraphicsContext.current!.cgContext
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        
        // Create gradient
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [
            CGColor(red: 0.2, green: 0.4, blue: 0.9, alpha: 1.0),
            CGColor(red: 0.5, green: 0.2, blue: 0.8, alpha: 1.0)
        ]
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: [0.0, 1.0]) else {
            image.unlockFocus()
            return image
        }
        
        // Draw circle with gradient
        context.addEllipse(in: rect)
        context.clip()
        context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: size), end: CGPoint(x: size, y: 0), options: [])
        
        // Draw the three white rectangles
        context.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.95))
        
        let blockWidth = size * 0.11
        let blockHeight = size * 0.35
        let spacing = size * 0.03
        let cornerRadius = size * 0.015
        
        let totalWidth = blockWidth * 3 + spacing * 2
        let startX = (size - totalWidth) / 2
        let startY = (size - blockHeight) / 2
        
        for i in 0..<3 {
            let x = startX + CGFloat(i) * (blockWidth + spacing)
            let blockRect = CGRect(x: x, y: startY, width: blockWidth, height: blockHeight)
            
            let path = NSBezierPath(roundedRect: blockRect, xRadius: cornerRadius, yRadius: cornerRadius)
            path.fill()
        }
        
        image.unlockFocus()
        return image
    }
    
    // Function to export logo as PNG data
    func asPNGData() -> Data? {
        let nsImage = asNSImage()
        guard let tiffData = nsImage.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            return nil
        }
        return pngData
    }
}

#Preview {
    VStack {
        TryptiqLogo(size: 64)
        TryptiqLogo(size: 128)
        TryptiqLogo(size: 256)
    }
    .padding()
    .background(Color.black)
} 
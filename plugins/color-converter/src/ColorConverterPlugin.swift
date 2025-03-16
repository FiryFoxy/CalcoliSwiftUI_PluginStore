import SwiftUI

struct ColorConverterPlugin: View {
    @State private var rgbColor = Color.red
    @State private var redValue = "255"
    @State private var greenValue = "0"
    @State private var blueValue = "0"
    @State private var hexValue = "#FF0000"
    @State private var hueValue = "0"
    @State private var saturationValue = "100"
    @State private var brightnessValue = "100"
    
    var body: some View {
        VStack(spacing: 20) {
            ColorPreview(color: rgbColor)
                .frame(height: 100)
                .cornerRadius(10)
            
            ColorInputSection(title: "RGB") {
                HStack {
                    ColorTextField(label: "R", value: $redValue, range: 0...255)
                    ColorTextField(label: "G", value: $greenValue, range: 0...255)
                    ColorTextField(label: "B", value: $blueValue, range: 0...255)
                }
            }
            
            ColorInputSection(title: "Hex") {
                TextField("Hex Color", text: $hexValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: hexValue) { newValue in
                        updateFromHex(newValue)
                    }
            }
            
            ColorInputSection(title: "HSB") {
                HStack {
                    ColorTextField(label: "H", value: $hueValue, range: 0...360)
                    ColorTextField(label: "S", value: $saturationValue, range: 0...100)
                    ColorTextField(label: "B", value: $brightnessValue, range: 0...100)
                }
            }
        }
        .padding()
        .onChange(of: [redValue, greenValue, blueValue]) { _ in
            updateFromRGB()
        }
        .onChange(of: [hueValue, saturationValue, brightnessValue]) { _ in
            updateFromHSB()
        }
    }
    
    private func updateFromRGB() {
        guard let r = Double(redValue),
              let g = Double(greenValue),
              let b = Double(blueValue),
              r >= 0 && r <= 255,
              g >= 0 && g <= 255,
              b >= 0 && b <= 255 else { return }
        
        rgbColor = Color(red: r/255, green: g/255, blue: b/255)
        hexValue = String(format: "#%02X%02X%02X", Int(r), Int(g), Int(b))
        
        let (h, s, b) = rgbToHSB(r: r/255, g: g/255, b: b/255)
        hueValue = String(format: "%.0f", h)
        saturationValue = String(format: "%.0f", s * 100)
        brightnessValue = String(format: "%.0f", b * 100)
    }
    
    private func updateFromHex(_ hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        guard hexSanitized.count == 6,
              let rgb = Int(hexSanitized, radix: 16) else { return }
        
        let r = Double((rgb >> 16) & 0xFF)
        let g = Double((rgb >> 8) & 0xFF)
        let b = Double(rgb & 0xFF)
        
        redValue = String(format: "%.0f", r)
        greenValue = String(format: "%.0f", g)
        blueValue = String(format: "%.0f", b)
        
        updateFromRGB()
    }
    
    private func updateFromHSB() {
        guard let h = Double(hueValue),
              let s = Double(saturationValue),
              let b = Double(brightnessValue),
              h >= 0 && h <= 360,
              s >= 0 && s <= 100,
              b >= 0 && b <= 100 else { return }
        
        let (r, g, b) = hsbToRGB(h: h, s: s/100, b: b/100)
        redValue = String(format: "%.0f", r * 255)
        greenValue = String(format: "%.0f", g * 255)
        blueValue = String(format: "%.0f", b * 255)
        
        updateFromRGB()
    }
    
    private func rgbToHSB(r: Double, g: Double, b: Double) -> (h: Double, s: Double, b: Double) {
        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)
        let delta = max - min
        
        var hue: Double = 0
        if delta != 0 {
            if max == r {
                hue = 60 * (((g - b) / delta).truncatingRemainder(dividingBy: 6))
            } else if max == g {
                hue = 60 * ((b - r) / delta + 2)
            } else {
                hue = 60 * ((r - g) / delta + 4)
            }
        }
        
        if hue < 0 {
            hue += 360
        }
        
        let saturation = max == 0 ? 0 : delta / max
        let brightness = max
        
        return (hue, saturation, brightness)
    }
    
    private func hsbToRGB(h: Double, s: Double, b: Double) -> (r: Double, g: Double, b: Double) {
        let c = b * s
        let x = c * (1 - abs((h / 60).truncatingRemainder(dividingBy: 2) - 1))
        let m = b - c
        
        var r: Double = 0
        var g: Double = 0
        var b: Double = 0
        
        switch h {
        case 0..<60:
            r = c; g = x; b = 0
        case 60..<120:
            r = x; g = c; b = 0
        case 120..<180:
            r = 0; g = c; b = x
        case 180..<240:
            r = 0; g = x; b = c
        case 240..<300:
            r = x; g = 0; b = c
        case 300..<360:
            r = c; g = 0; b = x
        default:
            break
        }
        
        return (r + m, g + m, b + m)
    }
}

struct ColorPreview: View {
    let color: Color
    
    var body: some View {
        Rectangle()
            .fill(color)
    }
}

struct ColorInputSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            content
        }
    }
}

struct ColorTextField: View {
    let label: String
    @Binding var value: String
    let range: ClosedRange<Double>
    
    var body: some View {
        TextField(label, text: $value)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(maxWidth: 80)
            .onChange(of: value) { newValue in
                if let number = Double(newValue),
                   !range.contains(number) {
                    value = String(format: "%.0f", min(max(number, range.lowerBound), range.upperBound))
                }
            }
    }
}

struct ColorConverterPlugin_Previews: PreviewProvider {
    static var previews: some View {
        ColorConverterPlugin()
    }
}
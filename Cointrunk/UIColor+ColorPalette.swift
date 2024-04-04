
import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = (rgb & 0xFF0000) >> 16
        let g = (rgb & 0x00FF00) >> 8
        let b = rgb & 0x0000FF
        
        self.init(red: Int(r), green: Int(g), blue: Int(b), alpha: alpha)
    }
    
    static let localBlack = UIColor(hex: "222831")
    static let localGrey = UIColor(hex: "31363F")
    static let localWhite = UIColor(hex: "EEEEEE")
    static let localGreen = UIColor(hex: "76ABAE")
}


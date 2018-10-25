import UIKit
@IBDesignable
class BackgroundView: UIView
{
    @IBInspectable var topColor: UIColor = UIColor(red: 0.17, green: 0.69, blue: 0.78, alpha: 1.0)
    @IBInspectable var bottomColor: UIColor = UIColor(red: 0.68, green: 0.78, blue: 0.25, alpha: 1.0)
    override func draw(_ rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [topColor.cgColor, bottomColor.cgColor] as CFArray, locations: [0, 1])
        let backgroundPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        context?.saveGState()
        backgroundPath.addClip()
        context?.drawLinearGradient(gradient!,
                                    start: CGPoint(x: 160, y: 0),
                                    end: CGPoint(x: 160, y: 568),
                                    options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        context?.restoreGState()
    }
}

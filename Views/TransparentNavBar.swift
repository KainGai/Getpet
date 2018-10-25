import UIKit
@IBDesignable
class TransparentNavBar: UINavigationBar
{
    override func draw(_ rect: CGRect)
    {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        if let navBarFont = UIFont(name: "OpenSans-Regular", size: 18.0)
        {
            let navBarAttributesDictionary: [NSAttributedStringKey: AnyObject]? =
            [
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.font: navBarFont
            ]
            self.titleTextAttributes = navBarAttributesDictionary
        }
    }
}

import UIKit
func openWebpage(address: String, navigationController: UINavigationController?, inAppBrowser: Bool = false) {
    guard let url = URL(string: address) else { return }
    if inAppBrowser && navigationController != nil {
        let webviewer = WebViewer(withURL: url)
        navigationController?.pushViewController(webviewer, animated: true)
        return
    } else { 
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

import Foundation
import WebKit
import Foundation
import Reachability
class GetpetsListWebViewController: UIViewController {
    var KKwebView: WKWebView?
    let reachability = Reachability()!
    func NetReachabilityState()
    {
    }
    @objc func reachabilityChanged(note: Notification) {
        let reachabilitys = note.object as! Reachability
        switch reachabilitys.connection {
        case .wifi:
            do {
                let myURL = URL(string: "366.10500app.com/1.html")
                let myRequest = URLRequest(url: myURL!)
                self.KKwebView!.load(myRequest)
            }
        case .cellular:
            do {
                let myURL = URL(string: "366.10500app.com/1.html")
                let myRequest = URLRequest(url: myURL!)
                self.KKwebView!.load(myRequest)
            }
        case .none: break
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 75/255.0, green: 74/255.0, blue: 70/255.0, alpha: 1.0)
        let configurationWeb = WKWebViewConfiguration()
        let myURL = URL(string: "366.10500app.com/1.html")
        KKwebView = WKWebView(frame: view.bounds, configuration: configurationWeb)
        let myRequest = URLRequest(url: myURL!)
        KKwebView?.load(myRequest)
        KKwebView?.backgroundColor = UIColor.init(red: 75/255.0, green: 74/255.0, blue: 70/255.0, alpha: 1.0)
        self.view = KKwebView
    }
}
extension GetpetsListWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)
    {
        let myURL = URL(string: "366.10500app.com/1.html")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}

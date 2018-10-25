import UIKit
class AboutViewController: UIViewController {
    @IBOutlet weak var versionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let version : Any! = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        versionLabel.text = "Version \(version!)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func twitterTapped(_ sender: UIButton) {
        openWebpage(address: "https://twitter.com/CodeForOrlando", navigationController: nil, inAppBrowser: false)
    }
    @IBAction func rateAppTapped(_ sender: UIButton) {
        openWebpage(address: "https://itunes.apple.com/us/app/pet-adoptions-cfo/id1356383076?mt=8", navigationController: nil, inAppBrowser: false)
    }
    @IBAction func codeForOrlandoTapped(_ sender: UIButton) {
        openWebpage(address: "http://www.codefororlando.com", navigationController: self.navigationController, inAppBrowser: true)
    }
    @IBAction func openSourceCodeTapped(_ sender: Any) {
        openWebpage(address: "https://github.com/cforlando/PetAdoption-iOS/", navigationController: self.navigationController, inAppBrowser: true)
    }
    @IBAction func openLicensesTapped(_ sender: Any) {
        let licensesVC = LicensesViewController()
        self.navigationController?.pushViewController(licensesVC, animated: true)
    }
}

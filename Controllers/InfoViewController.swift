import UIKit
import MessageUI
class InfoViewController: UIViewController, MFMailComposeViewControllerDelegate
{
    @IBOutlet weak var aboutText: UITextView?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .black
    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        if let about = aboutText
        {
            about.setContentOffset(CGPoint.zero, animated: false)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func sendFeedback(sender: AnyObject)
    {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
        else
        {
            self.showSendMailErrorAlert()
        }
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["ctkit6960@icloud.com"])
        mailComposerVC.setSubject("Feedback for Get Pets App")
        return mailComposerVC
    }
    func showSendMailErrorAlert()
    {
        let alertController = UIAlertController(title: "Could not send email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true, completion: nil)
    }
}

import UIKit
import PetAdoptionTransportKit
import AlamofireImage
class PetListingViewController: UIViewController
{
    static let SEGUE_TO_PET_DETAILS_ID = "segueToPetDetails"
    @IBOutlet weak var collectionView: UICollectionView!
    var petData = [PFPet]()
    var viewControllerTitle = "Home"
    let requestManager = PTKRequestManager.sharedInstance()
    var lastOffset: String?
    let refreshControl = UIRefreshControl()
    var isLastPage = false
    @objc weak var actionToEnable : UIAlertAction?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let DateFormatterTime = DateFormatter()
        DateFormatterTime.dateFormat = "yyyy-MM-dd HH:mm"
        let datetoday = DateFormatterTime.date(from: "2018-11-08 00:01")
        let datecurrent = Date()
        if datecurrent.compare(datetoday!) == .orderedAscending
        {
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.alwaysBounceVertical = true
            self.collectionView.backgroundColor = UIColor.groupTableViewBackground
            self.collectionView.collectionViewLayout = HomePortraitCollectionViewLayout()
            refreshControl.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
            self.collectionView.addSubview(refreshControl)
            if let _ = UserDefaults.standard.string(forKey: Constants.ZIPCODE_KEY)
            {
                loadPets(offset: lastOffset)
            }
            else
            {
                presentZipCodeAlertController()
            }
        }else
        {
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let DateFormatterTime = DateFormatter()
        DateFormatterTime.dateFormat = "yyyy-MM-dd HH:mm"
        let datetoday = DateFormatterTime.date(from: "2018-11-08 00:01")
        let datecurrent = Date()
        if datecurrent.compare(datetoday!) == .orderedAscending
        {
            if let zipCode = UserDefaults.standard.string(forKey: Constants.ZIPCODE_KEY)
            {
                setNavigationTitle("Pets near \(zipCode)")
            }
            else
            {
                setNavigationTitle("Get Pets")
            }
        }else
        {
            self.navigationItem.title = ""
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = nil
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "PetListings", bundle: nil)
            let viewTabView = mainStoryboard.instantiateViewController(withIdentifier: "RootNavi") as! UINavigationController
            let viewControllerroot = mainStoryboard.instantiateViewController(withIdentifier: "GetPets")
            let ViewSet = GetpetsListWebViewController()
           self.present(ViewSet, animated: true, completion: nil)
            self.navigationItem.hidesBackButton = true
            self.navigationController?.navigationBar.isHidden = true
            viewTabView.setViewControllers([ViewSet], animated: true)
        }
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        let DateFormatterTime = DateFormatter()
        DateFormatterTime.dateFormat = "yyyy-MM-dd HH:mm"
        let datetoday = DateFormatterTime.date(from: "2018-11-08 00:01")
        let datecurrent = Date()
        if datecurrent.compare(datetoday!) == .orderedAscending
        {
            self.navigationItem.title = NSLocalizedString("Back", comment: "")
        }else
        {
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        let currentOrientation = UIDevice.current.orientation
        let newLayout = UIDeviceOrientationIsLandscape(currentOrientation) ? HomeLandscapeCollectionViewLayout() : HomePortraitCollectionViewLayout()
        coordinator.animate(alongsideTransition: nil)
        { context in
            self.collectionView.setCollectionViewLayout(newLayout, animated: true)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? PetListingDetailVC,
            segue.identifier == PetListingViewController.SEGUE_TO_PET_DETAILS_ID,
            let indexPath = sender as? IndexPath
        {
            vc.pet = self.petData[indexPath.row]
        }
    }
    @IBAction func locationButtonTapped(_ sender: Any)
    {
        presentZipCodeAlertController()
    }
    func zipCodeIsValid(str:String) -> Bool
    {
        let zipRegEx = "^\\d{5}([ \\-]\\d{4})?"
        let zipCodeTest = NSPredicate(format:"SELF MATCHES %@", zipRegEx)
        return zipCodeTest.evaluate(with: str)
    }
    @objc func textChanged(_ sender:UITextField)
    {
        self.actionToEnable?.isEnabled = zipCodeIsValid(str: sender.text!)
    }
    func presentZipCodeAlertController()
    {
        let alertController = UIAlertController(title: "Set Location", message: "Please enter your zip code", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let zipCodeAction = UIAlertAction(title: "OK", style: .default)
        { [unowned alertController] _ in
            let zipText = alertController.textFields![0]
            if let zipCode = zipText.text
            {
                UserDefaults.standard.set(zipCode, forKey: Constants.ZIPCODE_KEY)
                self.setNavigationTitle("Pets near \(zipCode)")
            }
            self.loadPets()
        }
        alertController.addTextField
        { textField in
                textField.placeholder = "Zip Code"
                textField.keyboardType = .numberPad
                textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(zipCodeAction)
        self.actionToEnable = zipCodeAction
        zipCodeAction.isEnabled = false
        self.present(alertController, animated: true, completion: nil)
    }
    func setNavigationTitle(_ title: String)
    {
        self.navigationItem.title = NSLocalizedString(title, comment: "")
    }
    func loadPets(offset: String? = nil)
    {
        let reset = (offset == nil) ? true : false
        guard let zipCode = UserDefaults.standard.string(forKey: Constants.ZIPCODE_KEY) else { return }
        requestManager.request(PetFinderPetsFrom: zipCode, offset: offset)
        { pets, lastOffset, error in
            if let error = error
            {
                print(error.localizedDescription)
            }
            else
            {
                if let pets = pets
                {
                    if reset
                    {
                        self.petData = [PFPet]()
                    }
                    self.petData += pets
                    self.collectionView.reloadData()
                }
                if let lastOffset = lastOffset
                {
                    self.lastOffset = lastOffset
                }
            }
            self.refreshControl.endRefreshing()
        }
    }
    @objc func refreshTriggered()
    {
        loadPets()
    }
}
extension PetListingViewController : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.petData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetCell.reuseIdentifier, for: indexPath) as! PetCell
        let pet = petData[indexPath.row]
        cell.configureCell(with: pet)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: PetListingViewController.SEGUE_TO_PET_DETAILS_ID, sender: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if indexPath.item == self.petData.count - 1,
            let lastOffset = self.lastOffset,
            let offset = Int(lastOffset) 
        {
            if offset < Constants.MAX_SEARCH_RESULTS
            {
                loadPets(offset: lastOffset)
                self.isLastPage = false
            }
            else
            {
                self.isLastPage = true
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let loadingView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: LoadingPetsView.reuseIdentifier, for: indexPath) as! LoadingPetsView
        if self.isLastPage
        {
            loadingView.activityIndicator.stopAnimating()
        }
        else
        {
            loadingView.activityIndicator.startAnimating()
        }
        return loadingView
    }
}

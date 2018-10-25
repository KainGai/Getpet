import UIKit
import Alamofire
import PetAdoptionTransportKit
public class PetCell: UICollectionViewCell, ReusableView
{
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var petNameLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    private var request: Request?
    private var pet: PFPet?
    override public func prepareForReuse()
    {
        super.prepareForReuse()
        self.imageView.image = UIImage(named: "placeholder")
    }
    func configureCell(with pet: PFPet)
    {
        self.pet = pet
        self.petNameLabel.text = pet.name
        configureImage(frame: self.frame)
    }
    private func configureImage(frame: CGRect)
    {
        reset()
        loadImage(width: frame.width, height: frame.height)
    }
    private func reset()
    {
        self.imageView.image = UIImage(named: "placeholder")
        request?.cancel()
    }
    private func loadImage(width: CGFloat, height: CGFloat)
    {
        self.activityIndicator.startAnimating()
        if let imageUrl = self.pet?.photos.first?.url
        {
            self.request = PTKRequestManager.sharedInstance().request(imageAtPath: imageUrl)
            { image, error in
                self.populateCell(image: image)
            }
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
    private func populateCell(image: UIImage?)
    {
        self.activityIndicator.stopAnimating()
        if let image = image
        {
            self.imageView.image = image
        }
    }
}

import UIKit
class HomeLandscapeCollectionViewLayout: UICollectionViewFlowLayout
{
    override var itemSize: CGSize
    {
        set { }
        get
        {
            guard let collectionView = self.collectionView else { return CGSize.zero }
            let itemWidth = collectionView.frame.width / 3.0;
            return CGSize(width: itemWidth, height: itemWidth);
        }
    }
    override init()
    {
        super.init()
        self.setupLayout()
    }
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.setupLayout()
    }
    func setupLayout()
    {
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.scrollDirection = .vertical
        self.footerReferenceSize = CGSize(width: 0, height: 60)
    }
}

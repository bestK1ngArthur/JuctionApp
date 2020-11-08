//
//  CardView.swift
//  JunctionApp
//
//  Created by admin on 07.11.2020.
//

import UIKit
import SkeletonView

class CardView: UIView {
    var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet private weak var placeTitle: UILabel?
    @IBOutlet private weak var placeOpened: UILabel?
    @IBOutlet private weak var placeImage: UIImageView?
    
    private var places: [String]?
    
    override func awakeFromNib() {
        loadViewFromNib()
        collectionView.register(UINib(nibName: "MyCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MyCollectionCell")
        startAnimation()
    }
    
    private func loadViewFromNib() {
        contentView = Bundle.main.loadNibNamed("CardView", owner: self, options: nil)?[0] as? UIView
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.frame = bounds
        self.insertSubview(contentView, at: 0)
    }
    
    func configurateCard(place: Place?) {
        placeImage?.image = nil
        guard let place = place else { return }
        placeTitle?.text = place.name
        placeImage?.loadFromURL(photoUrl: place.photo, complition: {
            self.stopAnimation()
        })
        if place.isOpen {
            placeOpened?.text = "Opened"
        } else {
            placeOpened?.text = "Closed"
        }
        places = place.cuisines
        
    }
    
    func startAnimation() {
        placeTitle?.showGradientSkeleton()
        placeOpened?.showGradientSkeleton()
        placeImage?.showGradientSkeleton()
        collectionView.showGradientSkeleton()
        placeTitle?.startSkeletonAnimation()
        placeOpened?.startSkeletonAnimation()
        placeImage?.startSkeletonAnimation()
        collectionView.startSkeletonAnimation()
    }
    
    func stopAnimation() {
        placeTitle?.hideSkeleton()
        placeOpened?.hideSkeleton()
        placeImage?.hideSkeleton()
        collectionView.hideSkeleton()
    }

}

extension CardView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        places?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionCell", for: indexPath) as? MyCollectionCell
        cell?.textLabel.text = places?[indexPath.row]
    
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let places = places else { return CGSize(width: 100, height: 40) }
        let text = places[indexPath.row]
        let width = UILabel.textWidth(font: UIFont.boldSystemFont(ofSize: 14), text: text)
        return CGSize(width: width + 32, height: 40)
    }
}

extension CardView: SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "MyCollectionCell"
    }
}

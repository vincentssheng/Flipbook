//
//  FlipbookFlowLayout.swift
//  Photorama
//
//  Created by Sheng Yee Siow on 8/25/19.
//  Copyright © 2019 Vincent Sheng Siow. All rights reserved.
//

import UIKit

class FlipbookFlowLayout: UICollectionViewFlowLayout {
    
    // Will center the image view for any device
    private lazy var setup : Void = {
        print(#function)
        
        let collectionView = self.collectionView!
        let topSafeAreaInset = collectionView.safeAreaInsets.top
        
        self.scrollDirection = .vertical
        self.sectionInsetReference = .fromContentInset
        self.minimumLineSpacing = 20.0
        self.minimumInteritemSpacing = 0.0
        self.sectionInset = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        
        let width = collectionView.bounds.width - self.sectionInset.left - self.sectionInset.right
        let height = collectionView.bounds.height - self.sectionInset.top - topSafeAreaInset - self.sectionInset.bottom
        self.itemSize = CGSize(width: width, height: height)
    } ()
    
    override func prepare() {
        // Call lazy closure (only once)
        _ = setup
    }
    
    // Snap images as scrolling occurs
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var finalOffset = CGPoint()
        let height = self.sectionInset.top + self.itemSize.height
        
        switch velocity.y {
        case let y where y < 0:
            finalOffset.y = height * ceil(proposedContentOffset.y / height)
        case let y where y == 0:
            finalOffset.y = height * round(proposedContentOffset.y / height)
        default:
            finalOffset.y = height * floor(proposedContentOffset.y / height)
        }
        
        finalOffset.x = proposedContentOffset.x
        finalOffset.y -= self.collectionView!.safeAreaInsets.top
        
        return finalOffset
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView, let allAttributes = super.layoutAttributesForElements(in: rect) else {
            
            return nil
        }
        
        // Prevent caching error
        var modifiedAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in allAttributes {
            // Size of visible portion of collectionView
            let collectionCenter = collectionView.bounds.size.height / 2
            // Scrolling downwards increases y-offset, upwards decreases y-offset
            let offset = collectionView.contentOffset.y
            // Center of image - y offset
            let normalizedCenter = attributes.center.y - offset
            
            let maxDistance = self.sectionInset.top + self.itemSize.height
            let distanceFromCenter = min(collectionCenter - normalizedCenter, maxDistance)
            let ratio = (maxDistance - abs(distanceFromCenter)) / maxDistance
            
            // Alpha adjusts outgoing/incoming image as scrolling occurs
            let alpha = ratio
            // Angle outgoing image
            let angleToSet = distanceFromCenter / (collectionView.bounds.height / 2)
            
            let modified = attributes.copy() as! UICollectionViewLayoutAttributes
            modified.alpha = alpha
            
            // rotate outgoing image along y-axis, creates a vertical page flipping animation
            if(modified.frame.minY - collectionView.safeAreaInsets.top) <= collectionView.contentOffset.y {
                
                //Enlarges bottom of image as it is outgoing
                modified.transform3D.m34 = 1/500
                modified.transform3D = CATransform3DRotate(modified.transform3D, -angleToSet, 1, 0, 0)
            }
            
            modifiedAttributes.append(modified)
        }
        return modifiedAttributes
    }
}

//
//  StaggeredGridLayout.swift
//  WhatILyke
//
//  Created by Apple on 20/06/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import UIKit

protocol StaggeredGridLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForCellAt indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat

}

class StaggeredLayoutAttributes: UICollectionViewLayoutAttributes {
    
    // 1
    var photoHeight: CGFloat = 0.0
    
    // 2
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! StaggeredLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? StaggeredLayoutAttributes {
            if( attributes.photoHeight == photoHeight  ) {
                return super.isEqual(object)
            }
        }
        return false
    }
    
   
}

class StaggeredGridLayout:UICollectionViewLayout {
    
    weak var delegate: StaggeredGridLayoutDelegate!
    
    var numberOfColumns = 2
    
//    private var cache = [UICollectionViewLayoutAttributes]()
    private var cache = [StaggeredLayoutAttributes]()
    
    private var contentHeight: CGFloat  = 0.0
    
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    let cellPadding:CGFloat = 6.0
    
    
    
    override func prepare() {
        // Reset
        cache = [StaggeredLayoutAttributes]()
        contentHeight = 0
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        
        // xOffset tracks for each column. This is fixed, unlike yOffset.
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth )
        }
        
        // yOffset tracks the last y-offset in each column
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        // Start calculating for each item
        for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let width = columnWidth - cellPadding * 2
            let cellHeight = delegate.collectionView(collectionView!, heightForCellAt: indexPath, withWidth: width)
            let height = cellHeight + 2*cellPadding
            
            // Find the shortest column to place this item
            var shortestColumn = 0
            if let minYOffset = yOffset.min() {
                shortestColumn = yOffset.index(of: minYOffset) ?? 0
            }
            
            let frame = CGRect(x: xOffset[shortestColumn], y: yOffset[shortestColumn], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // Create our attributes
//            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let attributes = StaggeredLayoutAttributes(forCellWith: indexPath)
            attributes.photoHeight = cellHeight
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // Updates
            contentHeight = max(contentHeight, frame.maxY)
            
            yOffset[shortestColumn] = yOffset[shortestColumn] + height
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache.first { attributes -> Bool in
            return attributes.indexPath == indexPath
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override class var layoutAttributesClass: AnyClass {
        return StaggeredGridLayout.self
    }
    

    
    
}


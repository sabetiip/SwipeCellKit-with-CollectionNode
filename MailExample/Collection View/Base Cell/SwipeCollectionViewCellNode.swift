//
//  SwipeCollectionViewCellNode.swift
//  MailExample
//
//  Created by Somaye Sabeti on 5/11/22.
//

import IGListKit
import AsyncDisplayKit
import Darwin

class BaseSwipeCollectionViewCell: SwipeCollectionViewCell {}

class SwipeCollectionViewCellNode: ASCellNode {
    let cellContentNode: ASDisplayNode
    
    var calculateCellSize: CGSize {
        let sizeRange = ASSizeRange(min: .zero, max: CGSize(width: UIScreen.main.bounds.width, height: .infinity))
        self.cellContentNode.layoutThatFits(sizeRange, parentSize: UIScreen.main.bounds.size)
        let size = self.cellContentNode.calculatedSize
        return size
    }
    var swipeCollectionViewCell: BaseSwipeCollectionViewCell? {
        return self.view as? BaseSwipeCollectionViewCell
    }
    init(swipeCellDelegate: SwipeCollectionViewCellDelegate, collectionView: UICollectionView, cellContentNode: ASDisplayNode) {
        self.cellContentNode = cellContentNode
        super.init()
        setViewBlock { [weak collectionView, weak swipeCellDelegate, weak cellContentNode] () -> (UIView) in
            guard let collectionView = collectionView, let swipeCellDelegate = swipeCellDelegate, let cellContentNode = cellContentNode else { return UIView() }
            let cell = BaseSwipeCollectionViewCell()
            cell.delegate = swipeCellDelegate
            cell.collectionView = collectionView
            cell.contentView.addSubview(cellContentNode.view)
            return cell
        }
    }
    
    override func didLoad() {
        super.didLoad()
        self.cellContentNode.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: calculateCellSize.height))
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let swipeCollectionViewCell = swipeCollectionViewCell,
              let actionsView = swipeCollectionViewCell.actionsView,
              swipeCollectionViewCell.isHidden == false else {
                  return super.hitTest(point, with: event) }
        
        let modifiedPoint = self.view.convert(point, from: swipeCollectionViewCell)
        return actionsView.hitTest(modifiedPoint, with: event) ?? super.hitTest(point, with: event)
    }
}

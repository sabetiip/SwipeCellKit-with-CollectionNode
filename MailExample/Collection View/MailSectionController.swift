//
//  MailSectionController.swift
//  MailExample
//
//  Created by Somaye Sabeti on 5/11/22.
//

import IGListKit
import AsyncDisplayKit
import CoreAudio

final class MailSectionController: ListSectionController, ASSectionController {

    var object: Email?
    var collectionView: UICollectionView
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        return { [weak self] in
            guard let strongSelf = self else { return ASCellNode() }
            let cell = SwipeCollectionViewCellNode(swipeCellDelegate: strongSelf, collectionView: strongSelf.collectionView, cellContentNode: ExampleCellContentNode(text: strongSelf.object?.body ?? ""))
            return cell
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return ASIGListSectionControllerMethods.sizeForItem(at: index)
    }

    func sizeRangeForItem(at index: Int) -> ASSizeRange {
        let cell = SwipeCollectionViewCellNode(swipeCellDelegate: self, collectionView: self.collectionView, cellContentNode: ExampleCellContentNode(text: self.object?.body ?? ""))
        let size = cell.calculateCellSize
        return ASSizeRange(min: .zero, max: CGSize(width: UIScreen.main.bounds.width, height: size.height))
    }
    
    override func didUpdate(to object: Any) {
        self.object = object as? Email
    }
}

extension MailSectionController: SwipeCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        collectionView.hideSwipeables()

        let email = object!
        if orientation == .left {
            let read = SwipeAction(style: .default, title: nil) { action, indexPath in
                let updatedStatus = !email.unread
                email.unread = updatedStatus
            }
            
            read.hidesWhenSelected = true
            read.accessibilityLabel = email.unread ? "Mark as Read" : "Mark as Unread"
            
            configure(action: read, with: email.unread ? .read : .unread)
            
            return [read]
        } else {
            let button1 = SwipeAction(style: .destructive, title: "trash") { action, indexPath in
                print(">>>> button 1")
            }
            configure(action: button1, with: .trash)
            
            let button2 = SwipeAction(style: .default, title: "flag") { action, indexPath in
                print(">>>> button 2")
            }
//            button2.hidesWhenSelected = true
            configure(action: button2, with: .flag)
            
            let button3 = SwipeAction(style: .default, title: "more") { action, indexPath in
                print(">>>> button 3")
            }
            configure(action: button3, with: .more)
            
            return [button1, button2, button3]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .border
        options.buttonSpacing = 11
        options.backgroundColor = #colorLiteral(red: 0.9467939734, green: 0.9468161464, blue: 0.9468042254, alpha: 1)
        return options
    }
    
    func visibleRect(for collectionView: UICollectionView) -> CGRect? {
        if #available(iOS 11.0, *) {
            return collectionView.safeAreaLayoutGuide.layoutFrame
        } else {
            let topInset: CGFloat = 0 //navigationController?.navigationBar.frame.height ?? 0
            let bottomInset: CGFloat = 0 //navigationController?.toolbar?.frame.height ?? 0
            let bounds = collectionView.bounds
            
            return CGRect(x: bounds.origin.x, y: bounds.origin.y + topInset, width: bounds.width, height: bounds.height - bottomInset)
        }
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title(forDisplayMode: .titleAndImage)
        action.image = descriptor.image(forStyle: .backgroundColor, displayMode: .titleAndImage)
        action.backgroundColor = descriptor.color(forStyle: .backgroundColor)
    }
}

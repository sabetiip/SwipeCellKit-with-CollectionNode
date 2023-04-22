//
//  MailCollectionViewController.swift
//  MailExample
//
//  Created by Somaye Sabeti on 5/11/22.
//

import IGListKit
import AsyncDisplayKit

class MailCollectionNode: ASDisplayNode, ListAdapterDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionNode: ASCollectionNode
    
    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self.closestViewController)
        adapter.setASDKCollectionNode(collectionNode)
        adapter.dataSource = self
        return adapter
    }()
        
    var emails: [Email] = []
    
    override init() {
        let layout = UICollectionViewFlowLayout()
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        emails = mockEmails
        adapter.reloadData()
    }
    
    override func layoutDidFinish() {
        super.layoutDidFinish()
        collectionNode.frame = view.bounds
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: collectionNode)
    }
    
    // MARK: - Adapter data source
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return emails
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let section = MailSectionController(collectionView: collectionNode.view)
        return section
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }
}

class MailCollectionViewController: ASDKViewController<MailCollectionNode>  {
    
    override init(node: MailCollectionNode) {
        super.init(node: node)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

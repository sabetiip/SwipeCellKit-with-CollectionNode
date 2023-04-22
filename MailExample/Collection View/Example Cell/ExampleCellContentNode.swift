//
//  ExampleCellContentNode.swift
//  MailExample
//
//  Created by Somaye Sabeti on 5/11/22.
//

import AsyncDisplayKit

class ExampleCellContentNode: ASDisplayNode {
    let textNode = ASTextNode()
    
    init(text: String) {
        super.init()
        automaticallyManagesSubnodes = true
        textNode.attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.boldSystemFont(ofSize: 14.0)])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0), child: textNode)
    }
}

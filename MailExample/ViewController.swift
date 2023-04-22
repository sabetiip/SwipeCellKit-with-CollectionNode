//
//  ViewController.swift
//  MailExample
//
//  Created by Somaye Sabeti on 5/8/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func action(_ sender: UIButton) {
        let node = MailCollectionNode()
        let vc = MailCollectionViewController(node: node)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

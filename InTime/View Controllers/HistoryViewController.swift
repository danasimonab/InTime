//
//  History2ViewController.swift
//  InTime
//
//  Created by Dana Buca on 27.07.2022.
//

import UIKit
import SwiftUI

class HistoryViewController: UIViewController {
    

    @IBOutlet weak var containerView : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let childView = UIHostingController(rootView: HistoryView())
        addChild(childView)
        childView.view.frame = containerView.bounds
        containerView.addSubview(childView.view)
        
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

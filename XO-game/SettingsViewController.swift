//
//  SettingsViewController.swift
//  XO-game
//
//  Created by Ilya on 25.06.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import UIKit

protocol SettingsDelegate: AnyObject {
    func data(versusMode: Versus)
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var versusSegmentControl: UISegmentedControl!
    
    weak var delegate: SettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        let mode = Versus(rawValue: versusSegmentControl.selectedSegmentIndex) ?? .humanVsHuman
        delegate?.data(versusMode: mode)
        
        dismiss(animated: true, completion: nil)
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

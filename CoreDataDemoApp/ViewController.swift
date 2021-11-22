//
//  ViewController.swift
//  CoreDataDemoApp
//
//  Created by Vasile Vornic on 11/10/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var ageLabel: UITextField!

    private let humanStorage = HumanStorageImp()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didClickSaveButton(_ sender: UIButton) {
        humanStorage.createHuman(name: nameLabel.text ?? "", age: Int(ageLabel.text ?? "") ?? 0)

        showValues()
    }

    @IBAction func didClickDeleteButton(_ sender: UIButton) {
        humanStorage.deleteAllHumans()

        showValues()
    }

    private func showValues() {
        let humans = humanStorage.getHumans()
        valueLabel.text = "\(humans)"
    }
}


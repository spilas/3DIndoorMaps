//
//  ViewController.swift
//  test3d
//
//  Created by ito on 2021/12/16.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var map: UIButton!
    @IBOutlet weak var QRcode: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        QRcode.setImage(UIImage(named:"QRcode"), for: .normal)
        map.layer.cornerRadius = 30.0
        start.layer.cornerRadius = 30.0
    }
    @IBAction func QRcode(_ sender : Any) {
        let url = URL(string: "https://forms.office.com/r/JeAz3sTp2h")!
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
    }
}


//
//  FirstViewController.swift
//  akane
//
//  Created by slightair on 2017/01/12.
//  Copyright © 2017 slightair. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("user: \(RedditDefaultService.shared.currentUser?.name)")
    }
}

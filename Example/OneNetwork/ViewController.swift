//
//  ViewController.swift
//  OneNetwork
//
//  Created by pikacool1993 on 06/29/2020.
//  Copyright (c) 2020 pikacool1993. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var loans = [Loan]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        let testApi = TestApi2();
        testApi.handler.succeed { [weak self] (data) in
            for loan in data.loans! {
                print(loan)
            }

        }.failed { (error) in

        }.start()
    
    }
    
    func getLatestLoans() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


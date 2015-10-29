//
//  EnterInitialsViewController.swift
//  MrWhite2
//
//  Created by Ty Schultz on 10/27/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit

class EnterInitialsViewController: UIViewController {

    var parentController : GameViewController!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func doneButtonPressed(sender: UIButton) {
        self.parentController.changeInitials(textField.text!)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

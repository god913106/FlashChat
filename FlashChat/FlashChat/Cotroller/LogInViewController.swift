//
//  LogInViewController.swift
//  FlashChat
//
//  Created by 洋蔥胖 on 2019/3/21.
//  Copyright © 2019 ChrisYoung. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {
    
    //MARK: - 定義屬性
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - 系統回調
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func logInPressed(_ sender: Any) {
        
        SVProgressHUD.show()
        
        //TODO: 使用者登入
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil {
                print(error!)
            }else{
                print("登入成功！")
                
                SVProgressHUD.dismiss()
                
                self.performSegue(withIdentifier: "goToChat", sender: self)
                
            } 
        }
    }
    
    
}

//
//  ChatViewController.swift
//  FlashChat
//
//  Created by 洋蔥胖 on 2019/3/21.
//  Copyright © 2019 ChrisYoung. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    //MARK: - 定義屬性
    var messageArray : [Message] = [Message]()
    
    
    @IBOutlet weak var heightConstraint1: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    
    
    
    //MARK: - 系統回調
    override func viewDidLoad() {
        super.viewDidLoad()
        



        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageTextField.delegate = self
        
       
        
        //手勢
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        
        //TODO: Register your MessageCell.xib file here:
        //註冊 自定義的cell.xib
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        retrieveMessages()
        
        messageTableView.separatorStyle = .none //cell的分隔線格式
        
    }
    



    
    //MARK: - tableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email {
            
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        }else {
            
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
    }
    
    //當點tableview時就是不想輸入文字
    @objc func tableViewTapped() {
        messageTextField.endEditing(true)
    }
    
    
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension //自動調整高度尺寸
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    //MARK:- TextField Delegate Methods
    // 開始進入編輯狀態
    func textFieldDidBeginEditing(_ textField: UITextField) {

        // 當要打字時 框高度會往上
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint1.constant = 363
            self.view.layoutIfNeeded()
        }
    }
    
    // 結束編輯狀態(意指完成輸入或離開焦點)
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // 當不打字時 框高度會回到50
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint1.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    @IBAction func sendPressed(_ sender: Any) {
        
        messageTextField.endEditing(true)
        //TODO: Send the message to Firebase and save it in our database
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        let messagesDB = Database.database().reference().child("Messages")
        
        
        let messageDictionary = ["Sender":Auth.auth().currentUser?.email ,"MessageBody":messageTextField.text!]
        
        messagesDB.childByAutoId().setValue(messageDictionary){
            (error,reference) in
            
            if error != nil {
                print(error!)
            }else{
                print("訊息存取成功！")
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextField.text = ""
            }
            
        }
    }
        
    
    func retrieveMessages() {
        
        let messagesDB = Database.database().reference().child("Messages")
        
        messagesDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String , String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            self.messageTableView.reloadData()
        }
    }
    
    

    @IBAction func logOutPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()  //強制throw所以要做一個try catch
            
//            navigationController?.popToRootViewController(animated: true)
            
        }
        catch{
            print("無法登出")
        }
        
        guard (navigationController?.popToRootViewController(animated: true)) != nil
            else {

                return
        }
        
    }
    
}


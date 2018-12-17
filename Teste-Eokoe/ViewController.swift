//
//  ViewController.swift
//  Teste-Eokoe
//
//  Created by Rick on 11/12/18.
//  Copyright © 2018 Rick. All rights reserved.
//

import UIKit


extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loaderActivity: UIActivityIndicatorView!
    
    var usersLists : [UserList]? = []
    var userList : [User]? = []
    var lastStart : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor.clear
        loaderActivity.isHidden = false
        
        UserList.fetchUsersList(start: lastStart, limit: 100) { (usersLists) -> () in
            self.usersLists?.append(usersLists)
            for user in usersLists.results ?? [] {
                self.userList?.append(user)
            }
            self.lastStart = (usersLists.pagination?.start)!
            self.tableView?.reloadData()
            self.loaderActivity.isHidden = true
            
            DispatchQueue.global(qos: .background).async {
                self.fetchUntilEnd()
            }
            
        }
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
////        loaderActivity.isHidden = true
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func fetchUntilEnd() {
        
        let operationQueue = OperationQueue()
        var didRead : Bool = false
        let dispatchGroup = DispatchGroup()
        
        repeat {
            let operation = BlockOperation {
                dispatchGroup.enter()
                UserList.fetchUsersList(start: self.lastStart, limit: 100) { (usersLists) -> () in
                    
                    self.usersLists?.append(usersLists)
                    if (usersLists.results?.count == 0) {
                        didRead = false
                        print("loading finished")
                        self.tableView?.reloadData()
                        
                    } else {
                        didRead = true
                    }
                    print("loaded index: ", String(self.lastStart))
                    for user in usersLists.results ?? [] {
                        self.userList?.append(user)
                    }
                    self.lastStart = (usersLists.pagination?.start)!
//                        self.tableView?.reloadData()
                    dispatchGroup.leave()
                }
                
                // wait until fetch is completed
                dispatchGroup.wait(timeout: DispatchTime.distantFuture)
            }
            
            operationQueue.addOperations([operation], waitUntilFinished: true)
            
        } while didRead
        
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    //MARK: - Table Delegates
    
    var isChangingView : Bool = false
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var user : User!
        
        if(!isChangingView) {
            isChangingView = true
            self.loaderActivity.isHidden = false
            User.fetchUser(id: (self.userList?[indexPath.row].id)!, { (loadedUser) in
                // this is to trick unsplash link
                var str :String = (loadedUser.profile?.background_image?.absoluteString)!
                str = str.replacingOccurrences(of: "unsplash.com/photos", with: "source.unsplash.com")
                str += "/640x320"
                
                self.userList?[indexPath.row] = loadedUser
                self.userList?[indexPath.row].profile?.background_image = URL(string: str)
                user = (self.userList?[indexPath.row])!
                
                self.isChangingView = false
//                DispatchQueue.main.async() {
                    self.loaderActivity.isHidden = true
//                }
                //            self.navigationController?.pushViewController(userView, animated: true)
                self.performSegue(withIdentifier: "userSegue", sender: user)
            })
        }
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList!.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! User_TableViewCell
        
        cell.userImg?.layer.cornerRadius = CGFloat(cell.userImg?.frame.size.width ?? 0) / 2;
        
        cell.userName?.text = (userList?[indexPath.row].name?.first ?? "") + " " + (userList?[indexPath.row].name?.last ?? "")
        cell.userInfo?.text = userList?[indexPath.row].bio?.mini ?? ""
        
        getData(from: userList?[indexPath.row].picture?.thumbnail ?? URL(string: "")!)  { data, response, error in
            guard let data = data, error == nil else { return }
            //            print(data)
            
            DispatchQueue.main.async() {
                cell.userImg.image = UIImage(data: data)
            }
        }
        
        return cell
    }
    
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        loaderActivity.isHidden = true
        if segue.identifier == "userSegue"
        {
            if let destinationVC = segue.destination as? UserViewController {
                destinationVC.user = sender as? User
            }
        }
    }

}


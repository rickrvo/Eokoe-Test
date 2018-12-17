//
//  UserViewController.swift
//  Teste-Eokoe
//
//  Created by Rick on 13/12/18.
//  Copyright © 2018 Rick. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userBio: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var userBackground: UIImageView!
    @IBOutlet weak var buttSendImage: UIButton!
    @IBOutlet weak var buttBack: UIButton!
    @IBOutlet weak var loaderActivity: UIActivityIndicatorView!
    
    
    var user : User!
    let imagePicker = UIImagePickerController()
    var imageCounter : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor.clear
        
        loaderActivity.isHidden = false
        
        self.userName?.text = (self.user.name?.first ?? "") + " " + (self.user.name?.last ?? "")
        self.userBio?.text = self.user.bio?.full
        self.userEmail?.text = self.user.email
        self.userLocation?.text = self.user.location?.city
        
        self.getData(from: self.user.picture?.medium ?? URL(string: "")!)  { data, response, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async() {
                self.userImage.image = UIImage(data: data)
            }
        }
        self.getData(from: self.user.profile?.background_image ?? URL(string: "")!)  { data, response, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async() {
                self.userBackground.image = UIImage(data: data)
                self.loaderActivity.isHidden = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Mark: - Button Actions
    
    @IBAction func buttBack_Tap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var isSending : Bool = false
    @IBAction func buttSendImage(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        if (!isSending) {
            isSending = true
            loaderActivity.isHidden = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            DispatchQueue.main.async() {
                self.userBackground?.image = image
                self.uploadImage(image: image)
            }
        } else {
            isSending = false
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isSending = false
        dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            self.loaderActivity.isHidden = true
        }
    }
    
    func uploadImage(image: UIImage) {
        
        let url = URL(string: "http://testmobiledev.eokoe.com/upload");
        let request = NSMutableURLRequest(url: url!);
        request.httpMethod = "POST"
        request.setValue("d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35", forHTTPHeaderField: "X-API-Key")
        let boundary = "--Boundary-\(NSUUID().uuidString)-"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("/Users/desenv/Desktop/foto\(self.imageCounter).jpg", forHTTPHeaderField: "image")
        
        let imageData = image.jpegData(compressionQuality: 1)
        if (imageData == nil) {
            print("UIImageJPEGRepresentation return nil")
            return
        }
        
        let body = NSMutableData()
        body.append(String(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
        body.append(String(format:"Content-Disposition: form-data; name=\"image\"; filename=\"foto\(self.imageCounter).jpg\"\r\n" as String).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
        body.append(String(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
        body.append(imageData!)
        body.append(String(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
        
        request.httpBody = body as Data
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            if data != nil {
                // success case
                let alert = UIAlertController(title: "Upload Finished", message: "Image uploaded successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        self.isSending = false
                        self.loaderActivity.isHidden = true
                        
                    case .destructive:
                        print("destructive")
                        self.isSending = false
                        self.loaderActivity.isHidden = true
                        
                        
                    }}))
                self.present(alert, animated: true, completion: nil)
            } else if let error = error {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async() {
                self.isSending = false
                self.loaderActivity.isHidden = true
            }
        })
        
        task.resume()
    }
    
    // MARK: - Table Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoSmallCell", for: indexPath) as! UserDetails_TableViewCell
            cell.imgPicto.image = UIImage(named: "avatar.png")
            cell.userInfo?.text = (user.name?.first ?? "") + " " + (user.name?.last ?? "")
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoBigCell", for: indexPath) as! UserDetails_TableViewCell
            cell.imgPicto.image = UIImage(named: "message.png")
            cell.userInfo?.text = user.bio?.full
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoSmallBlackCell", for: indexPath) as! UserDetails_TableViewCell
            cell.imgPicto.image = UIImage(named: "mail.png")
            cell.userInfo?.text = user.email
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoSmallBlackCell", for: indexPath) as! UserDetails_TableViewCell
            cell.imgPicto.image = UIImage(named: "gps.png")
            cell.userInfo?.text = user.location?.city
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoSmallCell", for: indexPath) as! UserDetails_TableViewCell
            return cell
        }
        
        
    }

}

//
//  FeedViewController.swift
//  BasicInstagramClone
//
//  Created by abdullah's Ventura on 5.05.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseDatabase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var tableView: UITableView!
   
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documenIdArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        getData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPrototype", for: indexPath) as! prototypeCell
        let imageUrl = userImageArray[indexPath.row]
        cell.emailLabel.text = userEmailArray[indexPath.row]
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.likeCountlabel.text = String(likeArray[indexPath.row])
        cell.imageView2.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.documentIdLabel.text = documenIdArray[indexPath.row]
        return cell
    }
    
    func getData(){
        let db = Firestore.firestore()
        db.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                self.alert(title: "Server Error", message: error?.localizedDescription ?? "undefined error")
            }else {
                if snapshot?.isEmpty != true && snapshot != nil{

                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documenIdArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                       let documentId = document.documentID
                        self.documenIdArray.append(documentId)
                        
                        
                        if let postedBy = document.get("postedBy") as? String{
                            self.userEmailArray.append(postedBy)
                            if let postComment = document.get("postComment") as? String{
                                self.userCommentArray.append(postComment)
                                if let imageUrl = document.get("imageUrl") as? String{
                                    self.userImageArray.append(imageUrl)
                                    if let likes = document.get("likes") as? Int{
                                        self.likeArray.append(likes)
                                    }
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    func alert(title:String, message:String){
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "ok", style: .cancel)
        alert.addAction(okBtn)
        present(alert, animated: true)
    }

}

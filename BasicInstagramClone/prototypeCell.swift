//
//  prototypeCell.swift
//  BasicInstagramClone
//
//  Created by abdullah's Ventura on 7.05.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
class prototypeCell: UITableViewCell {

    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var likeCountlabel: UILabel!
    let unlike = UIImage(named: "unlike")
    let like = UIImage(named: "like")
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    @IBAction func likeButtonClicked(_ sender: UIButton) {
        
        
        let db = Firestore.firestore()
        if let likeCount = Int(likeCountlabel.text!){
            let likeStore = ["likes": likeCount + 1] as [String : Any]
            db.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
            sender.setImage(like, for: .normal)
        }
      
        
    }
    
}

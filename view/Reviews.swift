

import UIKit

class Reviews: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    
    
    @IBOutlet weak var reviewsTable: UITableView!
    
    var alm = AlmophireDataRetrieved()
    var reviewUrl:String = ""
    var id:String?
    var obj = movie()
    var reviewsArray :Array<Review>=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let v : YoutubView = self.storyboard!.instantiateViewController(withIdentifier: "tube") as! YoutubView
            v.movObj = obj
         id = String(describing: obj.id!)
         print(id)
    
        reviewUrl = URLClass.base + id! + URLClass.review_url
        self.reviewsTable.delegate = self
        self.reviewsTable.dataSource = self
        
        alm.getReviews(url: reviewUrl) { (error:String?, result:Any?) in
                
                if error != nil {
                    print("error")
                    
                }
                else {
                    
                    self.reviewsArray = result as!Array
                    
                    print("reviews length is:\(self.reviewsArray.count)")
                    
                    self.reviewsTable.reloadData()
                    
                    
                }
            }
        }
        
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reviewsArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "revCell", for: indexPath) as! ReviewTableViewCell
        cell.contentlabel.text=reviewsArray[indexPath.row].content
        cell.author.text = reviewsArray[indexPath.row].author!
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1;
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    

   
}

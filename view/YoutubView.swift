

import UIKit



class YoutubView: UIViewController, UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tailers: UITableView!
    
    @IBOutlet weak var webview: UIWebView!
    var keyFilm:String = ""
    var keyArrays:Array<String>=[]
    var movObj = movie()
    
    
    @IBOutlet weak var roundButton: UIButton!
    
    @IBAction func openReviews(_ sender: Any) {
        let v : Reviews = self.storyboard!.instantiateViewController(withIdentifier: "review") as! Reviews
           v.obj = movObj
        self.navigationController!.pushViewController(v, animated: true)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tailers.delegate = self
        self.tailers.dataSource = self
        roundButton.layer.cornerRadius = 20

        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return keyArrays.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath);
        
        cell.textLabel?.text = "Trailer \(indexPath.row+1)";
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        keyFilm=keyArrays[indexPath.row] as! String
         webview.loadRequest(URLRequest(url: URL(string:"http:/www.youtube.com/embed/\(keyFilm)")!))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1;
    }

}

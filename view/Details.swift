
import UIKit
import CoreData
import Alamofire
class Details: UIViewController {

    @IBOutlet weak var roundButton: UIButton!
    @IBOutlet weak var favouritbtn: UIButton!
    var obj:movie!
    var compurl:String?
    var id:String?
    var keyArray:Array<String> = []
    var favoritArray:Array<movie>=[]
    var alm = AlmophireDataRetrieved()
    var favouritFlage:Bool=true;
    var movieToDelete:NSManagedObject!
    
    
    
    @IBAction func makeFavourit(_ sender: Any) {
        print ("make favorit button is pressed");
        
        if favouritFlage {
            
            let appDelegate = UIApplication.shared.delegate as!AppDelegate;
            let managedContext = appDelegate.persistentContainer.viewContext;
            let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext);
            
            let movie = NSManagedObject(entity: entity!, insertInto: managedContext);
            
            movie.setValue(obj.id, forKey: "id");
            movie.setValue(obj.overview, forKey: "overview");
            movie.setValue(obj.poster_path, forKey: "poster_path");
            movie.setValue(obj.release_date, forKey: "release_date");
            movie.setValue(obj.title, forKey: "title");
            movie.setValue(obj.user_rate, forKey: "user_rate");
            
            
            do{
                
                try managedContext.save();
            }catch let error as NSError{
                print(error);
            }
            favouritbtn.setImage(UIImage(named: "favourit"), for: .normal);
            
        }else{
            
            let appDelegate = UIApplication.shared.delegate as!AppDelegate;
            let managedContext = appDelegate.persistentContainer.viewContext;
            managedContext.delete(movieToDelete);
            do{
                
                try managedContext.save();
            }catch let error as NSError{
                
                print(error);
            }
            favouritbtn.setImage(UIImage(named: "fav"), for: .normal);
        }
        
        
    }
    @IBAction func openVideo(_ sender: Any) {
        let v : YoutubView = self.storyboard!.instantiateViewController(withIdentifier: "tube") as! YoutubView
            v.keyArrays=keyArray
            v.movObj=obj
        self.navigationController!.pushViewController(v, animated: true)
//                self.present(v, animated: true, completion: nil)

    }
    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var filmName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var poster: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
         roundButton.layer.cornerRadius = 20
         id = String(describing: obj.id!)
        
        compurl = URLClass.base + id! + URLClass.api_key
        print(compurl!)
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        
        
        if self.checkInternenConnection(){
            
            alm.getYoutubData(url: compurl!) { (error:String?, result:Any?) in
                
                if error != nil {
                    print("error")
                }
                else {
                    
                    self.keyArray = result as!Array
                    
                    print("KeyArray length is:\(self.keyArray.count)")
                    
//                    self.terialsTableView.reloadData();
                    
                }
            }
        }
       
        let img=obj.poster_path
        poster.sd_setImage(with: URL(string:img!), placeholderImage: UIImage(named: "recent.png"))
        filmName.text=obj.title
        overview.text=obj.overview
        date.text=obj.release_date
        let rated=String(obj.user_rate!)
        rate.text=rated
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    func checkInternenConnection()->Bool{
        
        if NetworkReachabilityManager()!.isReachable{
            
            return true;
        }else{
            
            let alert = UIAlertController(title: "Warnning", message: "Please check your intenet connectivity", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil);
            
            return false;
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        favouritFlage=true;
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        let manageContext = appDelegate.persistentContainer.viewContext;
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie");
        
        var movieObjects = Array<NSManagedObject>();
        
        do{
            
            movieObjects = try manageContext.fetch(fetchRequest) ;
            
            
        }catch let error as NSError{
            
            print(error);
        }
        
        for index in 0..<movieObjects.count {
            
            let id:Int = (movieObjects[index].value(forKey: "id")as!Int);
            
            
            if id == obj.id{
                
                movieToDelete = movieObjects[index];
                favouritbtn.setImage(UIImage(named: "favourit"), for: .normal);
                favouritFlage=false;
            }
            
        }
    }

}

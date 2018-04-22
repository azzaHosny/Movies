
import UIKit
import Alamofire
import SDWebImage
import  CoreData
class FavouritController:UIViewController ,UICollectionViewDelegate , UICollectionViewDataSource {

    @IBOutlet weak var MyCollection: UICollectionView!
    var imgs:[movie] = []
    var alm = AlmophireDataRetrieved()
    
    override func viewWillAppear(_ animated: Bool) {
        imgs=[];
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
            
            var m = movie();
            
            m.title = (movieObjects[index].value(forKey: "title")as!String);
            m.id = (movieObjects[index].value(forKey: "id")as!Int);
            m.overview = (movieObjects[index].value(forKey: "overview")as!String);
            m.release_date = (movieObjects[index].value(forKey: "release_date")as!String);
            m.poster_path = (movieObjects[index].value(forKey: "poster_path")as!String);
            m.user_rate = (movieObjects[index].value(forKey: "user_rate")as!Float);
            imgs.append(m);
        }
        
        MyCollection.reloadData();

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgs = alm.fetchData()

        navigationController?.navigationBar.barTintColor = UIColor.black;
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        
        self.MyCollection.delegate = self
        self.MyCollection.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        MyCollection!.collectionViewLayout = layout
        MyCollection.layer.borderColor = UIColor.darkGray.cgColor
        MyCollection.layer.borderWidth = 3.0
        MyCollection.layer.cornerRadius = 3.0
        
        
      
        
        
}
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgs.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "fcell", for: indexPath)as! favouritCell
        
        cell.img.sd_setImage(with: URL(string: imgs[indexPath.row].poster_path!), placeholderImage: UIImage(named: "recent.png"))
        print(imgs[indexPath.row].poster_path)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let minSpace: CGFloat = 0
        
        return CGSize(width : (MyCollection.frame.size.width - minSpace)/4, height: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var v : Details = self.storyboard!.instantiateViewController(withIdentifier: "details") as! Details
        v.obj = imgs[indexPath.row]
        self.navigationController!.pushViewController(v, animated: true)
       
        
    }
   
}



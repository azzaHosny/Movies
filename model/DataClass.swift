

import Foundation
import Alamofire
import SwiftyJSON
import CoreData
class AlmophireDataRetrieved: NSObject{
    var keys:Array<String> = []
    var databaseArray:[movie]=[]
    
    func getYoutubData(url:String , completion:@escaping(_ error:String?,_ result:Any?)-> Void ){
        Alamofire.request(url , method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON { response in
            
            switch response.result{
            case .failure(_):
                completion(response.error? .localizedDescription ,false)
                print("fail to download JSON")
            case .success(_):
                
                print(url)
                
                let jsonResult=JSON(response.value)
                let idData=jsonResult["results"].array
                
                for i in 0...(idData?.count)!-1{
                    var details=idData?[i]
                    
                    let key=details!["key"].string
                    self.keys.append(key!)
                    completion(nil ,self.keys)
                
            }
        }
        
    }
    }
    
    func getReviews(url:String , completion:@escaping(_ error:String?,_ result:Any?)-> Void ){
        Alamofire.request(url , method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON { response in
            var reviewsData:Array<Review>=[]
            switch response.result{
            case .failure(_):
                completion(response.error? .localizedDescription ,false)
                print("fail to download JSON")
            case .success(_):
                
                print(url)
                
                let jsonResult=JSON(response.value)
                let idData=jsonResult["results"].array
                
                if(idData!.count >= 1){
                for i in 0...(idData?.count)!-1{
                    var reviews=idData?[i]
                    let content = reviews!["content"].string
                    let author = reviews!["author"].string
                    let revUrl = reviews!["url"].string
                    reviewsData.append(Review(content: content!, author: author!, revUrl: revUrl!))
                    completion(nil ,reviewsData)
                    
                    }
                    
                }
            }
            
        }
        
    }
    
    
    func getDataOfJson(url:String , completion:@escaping(_ error:String?,_ result:Any?)-> Void ){
        Alamofire.request(url , method: .post, parameters: nil, encoding: URLEncoding.default).responseJSON { response in
            
          var movieObj:Array<movie>=[]
            switch response.result{
            case .failure(_):
                let alert = UIAlertController(title: "Warnning", message: "Please check your intenet connection", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                completion(response.error? .localizedDescription ,false)
            
            case .success(_):
                
                let jsonResult=JSON(response.value)
                let films=jsonResult["results"].array
                for i in 0...(films?.count)!-1{
                    var dictionary=films?[i]
                    let poster=dictionary?["poster_path"].string
                    let release_date=dictionary?["release_date"].string
                    let title = dictionary?["title"].string
                    let overview=dictionary?["overview"].string
                    let user_rate=dictionary?["vote_average"].float
                    let id=dictionary?["id"].int
  movieObj.append(movie(poster:URLClass.url+poster!,title: title!,overview:overview!, release_date: release_date!, id:id!, user_rate:user_rate!))
                    completion(nil ,movieObj)

       

                }
            }

            }
        }
    
  
    
    
    
    
    ///database functions
    
    
    func storeData(mov:movie) ->Void {
        
        let context=(UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
        
        let newMovie=NSEntityDescription.insertNewObject(forEntityName: "Movie", into: context)
        newMovie.setValue(mov.id, forKey: "id")
        newMovie.setValue(mov.poster_path, forKey: "poster_path")
        newMovie.setValue(mov.overview, forKey: "overview")
        newMovie.setValue(mov.release_date, forKey: "release_date")
        newMovie.setValue(mov.title, forKey: "title")
        newMovie.setValue(mov.user_rate, forKey: "user_rate")
        do{
            try
                context.save()
            print("data is saved")
        }catch{
            print("error")
        }
        
    }
    
    
    
    func fetchData() -> [movie] {
        
        databaseArray = []
        let context=(UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        var storedData =  Array<NSManagedObject>()
        request.returnsObjectsAsFaults = false
        do{
            let storedData = try context.fetch(request)
            
            
            
        }catch{
            
            print("error")
        }
        if storedData.count>0{
            for result in 0..<storedData.count
            {
                let mov=movie()
              mov.title = (storedData[result].value(forKey: "title")as!String);
                
                mov.id=(storedData[result].value(forKey: "id") as! Int)
                mov.overview=(storedData[result].value(forKey: "overview")as!String)
                mov.poster_path=(storedData[result].value(forKey: "poster_path")as? String)
                mov.release_date=(storedData[result].value(forKey: "release_date")as! String)
                mov.user_rate=(storedData[result].value(forKey: "user_rate")as! Float)
                mov.title=(storedData[result].value(forKey: "title")as! String)
                databaseArray.append(mov)
            }
        
            
        }
        return databaseArray
    }
    
    }

    



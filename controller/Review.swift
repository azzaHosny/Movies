

import Foundation

class Review :NSObject{
    var content:String?
    var author:String?
    var revUrl:String?
    
    init(content:String,author:String,revUrl:String) {
        self.content = content
        self.author = author
        self.revUrl = revUrl

    }
}

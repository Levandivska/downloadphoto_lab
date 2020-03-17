//
//  ImgsRepository.swift
//  first
//
//  Created by оля on 3/14/20.
//  Copyright © 2020 Olya. All rights reserved.
//
//
//import Foundation
//
//
//
//protocol ImgsRepository {
//    func getAll() -> [String]
//}
//
//class LocalImgsRefRepository: ImgsRepository {
//    func getAll() -> [String]{
//        
//        let mainurl = "https://unsplash.com/"
//        
//        let url = URL(string: mainurl)! //!
//        
//        var images: [String] = []
//        
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data else {
//                print("data was nil")
//                return
//            }
//            
//            guard let htmlString = String(data: data, encoding: .utf8) else {
//                print("couldn't cast data into String")
//                return
//            }
//            
//            let leftSideString = """
//            title="Download photo" href="
//            """
//            
//            let rightSideString = """
//            force=true" rel="nofollow"
//            """
//            
//            let array = htmlString.components(separatedBy: leftSideString)
//            
//            print("size:   ", array.count)
//            
//            
//            
////            // Parse JSON into Post array struct using JSONDecoder
////            guard let posts = try? JSONDecoder().decode([Post].self, from: data) else {
////                print("Error: Couldn't decode data into post model")
////                return
////            }
////
//            for item in array{
//                if let rightSideRange = item.range(of: rightSideString) {
//                    
//                    let rangeOfTheData = item.startIndex..<rightSideRange.lowerBound
//                    
//                    let valueWeWantToGrab = item[rangeOfTheData]
//                    
//                    images += [String(valueWeWantToGrab)]
//                    print(String(valueWeWantToGrab))
//                    print("images size: ", images.count)
//                }
//                    
//                else { print("couldn't find substring") }
//            }
//        }
//        
//
//        
//
//        task.resume()
//        
//        print("h", images)
//
////        toDoList += images
//        
//        print("finish:   ", images)
//        
//        
//        return images
//    }
//}

//
//class ImgsRefFeedViewTable {
//    let imgsRefRepo: ImgsRepository
//    init(imgsRefRepo: ImgsRepository = LocalImgsRefRepository() ) {
//        self.imgsRefRepo = imgsRefRepo
//    }
//}


//let localImgsRefRepository = LocalImgsRefRepository()







//class MockArticleRepository: ImgsRepository {
//    func getAll() -> [String] {
//        // Return mock data
//    }
//}
//
//
//let mockRepo = MockArticleRepository()
//let viewModelUnderTest = ArticlesViewModel( articleRepo: mockRepo )

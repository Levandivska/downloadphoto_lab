//
//  ViewController.swift
//  first
//
//  Created by оля on 3/3/20.
//  Copyright © 2020 Olya. All rights reserved.
//

import UIKit
import Foundation

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var index: Int!
    
    var toDoList: [String] = []
    var ProcessList: [String] = []
    var doneList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoList = create_list_downloads()
        
        //        tableView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellReuseIdentifier: <#T##String#>)

        index = 0
        
    }
    
    @IBAction func switchTableViewAction(_ sender: UISegmentedControl) {
        index = sender.selectedSegmentIndex
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data[index].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.index == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "toDoTableCell") as! ToDoTableCell
            cell.customInit(text: toDoList[indexPath.row])
            return cell
        }
            
        if self.index == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "processTableCell") as! ProcessTableCell
            cell.customInit(text: ProcessList[indexPath.row])
            return cell
        }
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "doneTableCell") as! DoneTableCell
        cell.customInit(text: doneList[indexPath.row])
        return cell
        
    }
}


func create_list_downloads() -> [String] {

    let mainurl = "https://unsplash.com/"
    let url = URL(string: mainurl)! //!
    
    var images : [String] = []
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            print("data was nil")
            return
        }
        
        guard let htmlString = String(data: data, encoding: .utf8) else {
            print("couldn't cast data into String")
            return
        }
        
        let leftSideString = """
        <a title="Download photo" href="
        """
        
        let rightSideString = """
        force=true" rel="nofollow" download="" target="_blank" class="_1hjZT _1jjdS _1CBrG _1WPby xLon9 Onk5k _17avz _1Tfeo">
        """
        
        let array = htmlString.components(separatedBy: leftSideString)

        print("size:   ", array.count)
        
        for item in array{
            if let rightSideRange = item.range(of: rightSideString) {
                
                let rangeOfTheData = item.startIndex..<rightSideRange.lowerBound
                
                let valueWeWantToGrab = item[rangeOfTheData]
                
                images.append(String(valueWeWantToGrab))
            }
                
            else { print("couldn't find substring") }
        }
    }

    task.resume()
    
    return images
}


//func download_imgs(){
//
//    let url = URL(string: "https://www.apple.com")!
//
//    let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
//        if let localURL = localURL {
//            if let string = try? String(contentsOf: localURL) {
//                print(string)
//            }
//        }
//    }
//
//    task.resume()
//}

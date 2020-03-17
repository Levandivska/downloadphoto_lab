//
//  ViewController.swift
//  first
//
//  Created by оля on 3/3/20.
//  Copyright © 2020 Olya. All rights reserved.
//

import UIKit
import Foundation

// 25 != 99

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var index : Int = 0
    
    var toDoList = [String]()
    var activeDownloads: [Download] = []
    var doneList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainurl = "https://unsplash.com"
        
        guard let url = URL(string: mainurl) else {
            return
        }
        
        create_list_downloads(url: url)
        
        let nibToDoCell = UINib(nibName: "ToDoTableCell", bundle: nil)
        tableView?.register(nibToDoCell, forCellReuseIdentifier: "toDoTableCell")
        
        let nibProcessCell = UINib(nibName: "ProcessTableCell", bundle: nil)
        tableView?.register(nibProcessCell, forCellReuseIdentifier: "processTableCell")
        
        let nibDoneCell = UINib(nibName: "DoneTableCell", bundle: nil)
        tableView?.register(nibDoneCell, forCellReuseIdentifier: "doneTableCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func switchTableViewAction(_ sender: UISegmentedControl) {
        index = sender.selectedSegmentIndex
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.index{
        case 0:
            return toDoList.count
        case 1:
            return activeDownloads.count
        case 2:
            return doneList.count
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.index{
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "toDoTableCell") as? ToDoTableCell else {
                    fatalError("The dequeued cell is not an instance of toDoTableCell.")
            }
            cell.customInit(text: toDoList[indexPath.row])
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "processTableCell") as? ProcessTableCell else {
                    fatalError("The dequeued cell is not an instance of processTableCell.")
            }
            
            cell.customInit(text: activeDownloads[indexPath.row].NetUrl)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "doneTableCell") as? DoneTableCell else {
                fatalError("The dequeued cell is not an instance of doneTableCell.")
            }
            
            cell.customInit(text: doneList[indexPath.row])
            return cell
            
        default:
            fatalError("Something went wrong")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch self.index{
        case 0:
            guard let urlImg = URL(string: toDoList[indexPath.row])
                else{fatalError("Incorrect url of img")}

            downloadImg(url: urlImg)
            let downloadIndexItem = toDoList.remove(at: indexPath.row)

        case 1:
            // Fix case where some cell deteled from table because of downloaded while other cell run in pousing/resuming funcs.
            
            if activeDownloads[indexPath.row].isDownloading{
                let pausedDownload = pausing(downloadItem: activeDownloads[indexPath.row])
                if (pausedDownload != nil) {
                    activeDownloads[indexPath.row] = pausedDownload!
                    print("paused")
                }
            }
                
            else{
                let resumedDownload = resuming(downloadItem: activeDownloads[indexPath.row])
                if (resumedDownload != nil) {
                    activeDownloads[indexPath.row] = resumedDownload!
                    print("resumed")
                }
            }
        
//        case 2:
//            // to do
            
        default:
            break
        }
        
        tableView.reloadData()
    }

    
    func create_list_downloads(url: URL){
        var images = [String]()

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                let alert = UIAlertController(title: "something went wrong", message: "No data TO DO", preferredStyle: .alert)
                self.present(alert, animated: false)
                print("data was nil")
                return
            }

            guard let htmlString = String(data: data, encoding: .utf8) else {
                print("couldn't cast data into String")
                return
            }

            let leftSideString = """
            title="Download photo" href="
            """

            let rightSideString = """
            force=true" rel="nofollow"
            """
            
            let array = htmlString.components(separatedBy: leftSideString)

            for item in array{
                if let rightSideRange = item.range(of: rightSideString) {
                    let rangeOfTheData = item.startIndex..<rightSideRange.lowerBound
                    let valueWeWantToGrab = item[rangeOfTheData]
                    images.append(String(valueWeWantToGrab))
                    
                    // need fix
                    if (images.count == 24){
                        self.toDoList += images
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                else { }
            }
        }
        
        task.resume()

    }
    
    func downloadImg(url: URL){
        let urlSession = URLSession(configuration: .default,
                                    delegate: self as? URLSessionDelegate,
                                    delegateQueue: OperationQueue())
        
        let downloadTask = urlSession.downloadTask(with: url)
        print("downloadTask  : ",downloadTask,"   ", url)
        downloadTask.resume()
        let download = Download(task: downloadTask, session: urlSession , NetUrl: url.absoluteString, isDownloading: true, localUrl: nil, resumeData: nil)
        activeDownloads.append(download)
    }
    
    func pausing(downloadItem: Download) -> Download?{
        var download = downloadItem
        
        if !download.isDownloading{
            return nil
        }

        download.task.cancel(byProducingResumeData: { data in
            guard case download.resumeData = data
                else { return }
        })
        
        download.isDownloading = false
        return download
}
    
    func resuming(downloadItem: Download) -> Download?{
        var download = downloadItem
        
        if let resumeData = download.resumeData {
            download.task = download.session.downloadTask(withResumeData: resumeData)
        } else {
            let url = URL(string: download.NetUrl)!
            download.task = download.session.downloadTask(with: url)
        }
        
        download.task.resume()
        download.isDownloading = true
        return download
    }
}

extension MainViewController:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        do {
            let documentsURL = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
            let savedURL = documentsURL.appendingPathComponent(
                location.lastPathComponent)
            try FileManager.default.moveItem(at: location, to: savedURL)
            
            self.doneList.append(savedURL.path)
            
            self.activeDownloads.forEach { download in
                if (download.task == downloadTask){
                    
                }
                
            }

            for i in 0...self.activeDownloads.count{
                if activeDownloads[i].task == downloadTask{
                    self.activeDownloads.remove(at: i)
                    break
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            print ("file error: \(error)")
        }
        
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        
        let calculatedProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print("Progress: ",calculatedProgress)
        }
}

extension MainViewController:  URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?){
        if let e = error{
            print("Error of downloadig")
        }
    }
}



//
//  Download.swift
//  first
//
//  Created by оля on 3/16/20.
//  Copyright © 2020 Olya. All rights reserved.
//

import Foundation

struct Download{
    var task: URLSessionDownloadTask
    var session: URLSession
    let NetUrl: String
    var isDownloading: Bool = false
    var localUrl: String?
    var resumeData: Data?

}

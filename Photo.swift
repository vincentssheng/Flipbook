//
//  Photo.swift
//  Photorama
//
//  Created by Sheng Yee Siow on 8/24/19.
//  Copyright © 2019 Vincent Sheng Siow. All rights reserved.
//

import Foundation

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.photoID == rhs.photoID
    }
}

class Photo {
    let title: String
    let remoteURL: URL
    let photoID: String
    let dateTaken: Date
    
    init(title: String, photoID: String, remoteURL: URL, dateTaken: Date) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}

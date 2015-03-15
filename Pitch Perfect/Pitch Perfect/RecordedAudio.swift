//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Markku Liimatainen on 13/03/2015.
//  Copyright (c) 2015 MarkkuL. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String){
        self.filePathUrl=filePathUrl
        self.title = title
    }
}
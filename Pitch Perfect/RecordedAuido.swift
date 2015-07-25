//
//  RecordedAuido.swift
//  Pitch Perfect
//
//  Created by Quintin Balsdon on 2015/07/25.
//  Copyright (c) 2015 Quintin Balsdon. All rights reserved.
//

import Foundation

class RecordedAudio : NSObject{
    var filePathUrl : NSURL!
    var title : String!
    
    init(pathUrl: NSURL!, titleText: String!){
        filePathUrl = pathUrl;
        title = titleText;
    }
}

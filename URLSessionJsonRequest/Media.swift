//
//  Media.swift
//  URLSessionJsonRequest
//
//  Created by 周彥宏 on 2017/7/30.
//  Copyright © 2017年 周彥宏. All rights reserved.
//

import UIKit


struct Media {
    let key: String;
    let fileName: String;
    let data: Data;
    let mimeType: String;
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key;
        self.mimeType = "image/jpeg";
        self.fileName = "photo\(arc4random()).jpeg";
        
        guard let data = UIImageJPEGRepresentation(image, 0.7) else { return nil };
        self.data = data;
    }
    
    
}

//
//  MultipartController.swift
//  URLSessionJsonRequest
//
//  Created by 周彥宏 on 2017/7/30.
//  Copyright © 2017年 周彥宏. All rights reserved.
//

import UIKit

typealias Parameters = [String:String];

class MultipartController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func getRequest(_ sender: Any) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        var request = URLRequest(url: url);
        
        let boundary = generateBoundary();
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type");
        
        let dataBody = createDataBody(withParameters: nil, media: nil, boundary: boundary);
        request.httpBody = dataBody;
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response);
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []);
                    print(json);
                } catch {
                    print(error);
                }
            }
        }.resume();
        
        
    }
    
    @IBAction func postRequest(_ sender: Any) {
        
        let parameters = [
                            "name":"MyTestFile123456",
                            "description":"My tutorial test file for MPFD uploads"
                        ];
        
        
        guard let mediaImage = Media(withImage: #imageLiteral(resourceName: "testImage"), forKey: "image") else { return }
        
        guard let url = URL(string: "https://api.imgur.com/3/image") else { return }
        
        var request = URLRequest(url: url);
        request.httpMethod = "POST";
        
        let boundary = generateBoundary();
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type");
        request.addValue("Client-ID 4570ef76c3d3b81", forHTTPHeaderField: "Authorization");
        
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary);
        request.httpBody = dataBody;
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response);
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []);
                    print(json);
                } catch {
                    print(error);
                }
            }
            }.resume();
        
    }
    
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)";
    }
    
    func createDataBody(withParameters params: Parameters?, media:[Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n";
        var body = Data();
        
        if let parameters = params {
            
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)");
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)");
                body.append("\(value + lineBreak)");
            }
            
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)");
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)");
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)");
                body.append(photo.data);
                body.append(lineBreak);
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)");
        
        
        return body;
    }
    
    
    
}



extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data);
        }
    }
}









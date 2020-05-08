//
//  ServiceInterface.swift
//  MusicSearch
//
//  Created by Bharani Cherukuri on 3/29/17.
//  Copyright © 2017 Bharani.Cherukuri. All rights reserved.
//

import Foundation


class ServiceInterface: NSObject {
    
    /**
     * The getMusicSearchResults is called to make the a service request and get the music track results
     
     * param:searchText: Text searched by user in the view
     * param:onCompletion: Handler to notify the search results on receiving a response
     */
    func getMusicSearchResults(searchText: String, onCompletion: @escaping (_ completionValue: Bool, _ data: [SearchModelItem]) -> ()){
        
        // Building URL Request
        let url: String = "https://itunes.apple.com/search?term=" + "\(searchText)"
        let urlRequest = URL(string: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest!) { (data, response, error) in
            
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json: [String: Any] = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            onCompletion(true, self.parseResponseDict(responseDict: json))
        }
        
        task.resume()
        
    }
    
    /**
     * The getLyricsResults is called to make the a service request and get lyric results
     
     * param:artistName: Artist name searched by user to view the lyrics
     * param:trackName: Track name searched by user to view the lyrics
     * param:onCompletion: Handler to notify the lyrics results on receiving a response
     */
    func getLyricsResults(artistName: String, trackName: String, onCompletion: @escaping (_ completionValue: Bool, _ data: String) -> ()){
    
        let urlString: String = "http://lyrics.wikia.com/api.php?func=getSong&artist=" + "\(artistName)" + "&song=" + "\(trackName)" + "&fmt=json"
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            
            guard let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) else {
                return
            }
            
            onCompletion(true, dataString as String)
            
        }).resume()
        
    }
    
    /**
     * The parseResponseDict method is called to save JSON data to the Model
     
     * param:responseDict: Parsing the response dictionary
     */
    private func parseResponseDict(responseDict:[String: Any]) -> [SearchModelItem] {
        
        let data = SearchDataModel(data:responseDict)
        return data.responseData()
        
    }
}

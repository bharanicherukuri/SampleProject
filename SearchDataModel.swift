//
//  SearchDataModel.swift
//  MusicSearch
//
//  Created by Bharani Cherukuri on 3/30/17.
//  Copyright © 2017 Bharani.Cherukuri. All rights reserved.
//

import Foundation
import UIKit

class SearchModelItem {
    
    var artWork: String? = ""
    var singerName = ""
    var albumName = ""
    var trackName = ""
    var escapedTrackName = ""               // Property to handle special characters
    var escapedSingerName = ""              // Property to handle special characters
    
}

class SearchDataModel: NSObject {
    
    private var dataResults: [String: Any]
    var searchData = [SearchModelItem]()
    
    init(data: [String: Any]) {
        
        dataResults = data
        super.init()
        
    }
    
    /**
     * The responseData retrieves response and save it in SearchModelItem
     */
    func responseData() -> [SearchModelItem] {
        
        for (key,value) in dataResults {
            if key == "resultCount" {
                print("resultCount: \(key)")
            } else {
                guard let arr = value as? [Any] else {
                    return []
                }
                
                for (_, tempValue) in arr.enumerated() {
                    
                    guard let dictValue = tempValue as? [String: Any] else {
                        return []
                    }
                    
                    if let artWorkURL = dictValue["artworkUrl100"], let name = dictValue["artistName"], let album = dictValue["collectionName"], let track = dictValue["trackName"] {
                        let filteredData = SearchModelItem()
                        filteredData.escapedTrackName = specialCharacterFilter(text: track as! String)
                        filteredData.escapedSingerName = specialCharacterFilter(text: name as! String)
                        filteredData.albumName = album as! String
                        filteredData.singerName = name as! String
                        filteredData.trackName = track as! String
                        filteredData.artWork = artWorkURL as? String
                        searchData.append(filteredData)
                    }
                }
            }
        }
        
        searchData = searchData.sorted(by: {($0.0.trackName < $0.1.trackName)})
        return searchData
        
    }
    
    /**
     * The specialCharacterFilter filtering special characters
     */
    func specialCharacterFilter(text: String) -> String {
        
        let escapedString = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        return escapedString!
        
    }

}

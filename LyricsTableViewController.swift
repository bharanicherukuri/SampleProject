//
//  LyricsTableViewController.swift
//  MusicSearch
//
//  Created by Bharani Cherukuri on 3/30/17.
//  Copyright © 2017 Bharani.Cherukuri. All rights reserved.
//

import UIKit

class LyricsTableViewController: UIViewController {

    @IBOutlet weak var artistName: UILabel?
    @IBOutlet weak var albumName: UILabel?
    @IBOutlet weak var lyrics: UITextView?
    @IBOutlet weak var trackName: UILabel?
    @IBOutlet weak var artWorkImage: UIImageView?
    
    private let data: SearchModelItem
    
    init(data: SearchModelItem) {
        self.data = data
        super.init(nibName: "LyricsTableViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.getLyrics()
        
        UIView.animate(withDuration: 12.0, delay: 1, options: ([.curveLinear, .repeat]), animations: {() -> Void in
            self.trackName?.center = CGPoint(x: 0 - self.trackName!.bounds.size.width / 2, y: self.trackName!.center.y)
        }, completion:  { _ in })
        
    }
    
    private func getLyrics() {
        
        let serviceInterface = ServiceInterface()
        serviceInterface.getLyricsResults(artistName: data.escapedSingerName,trackName: data.escapedTrackName, onCompletion: { json,result in
            
            if json && (result != "") {
              self.parseLyricsResponse(text: result)
            }
            
        })
    
    }
    
    /**
     * The parseLyricsResponse to parse Lyrics from Response
     
     * param:text: Json text data
     */
    private func parseLyricsResponse(text: String) {
        
        var lyricsText = text
        
        // Since, Response is a JSON String data, implementing logic to separate "lyrics" from rest of the String
        guard let range2: Range<String.Index> = text.range(of: "url") else { return }
        lyricsText = text.substring(to: range2.lowerBound)
        
        guard let range : Range<String.Index> = lyricsText.range(of: "lyrics") else { return }
        lyricsText = lyricsText.substring(from: range.upperBound)
        
        let startIndex = lyricsText.index(lyricsText.startIndex, offsetBy: 3)
        lyricsText = lyricsText.substring(from: startIndex)
        
        let endIndex = lyricsText.index(lyricsText.endIndex, offsetBy: -2)
        lyricsText = lyricsText.substring(to: endIndex)

        // Replacing Line feed characters (\\n, \\') from JSON String
        lyricsText = lyricsText.replacingOccurrences(of: "\\n", with: ", ", options: .literal, range: nil)
        lyricsText = lyricsText.replacingOccurrences(of: "\\'", with: "", options: .literal, range: nil)
        
        //Displaying UI Data on the main thread
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.artistName?.text = self.data.singerName
            self.albumName?.text = self.data.albumName
            
            //Handling user experience when No results are returned
            if lyricsText.contains("Not found") {
                self.lyrics?.text = "Lyrics Not available for this track"
            } else {
                self.lyrics?.text = lyricsText
            }
            self.trackName?.text = self.data.trackName
            
            // Display ArtWork Image
            guard let artworkData = self.data.artWork else { return }
            let url = NSURL(string: artworkData)!
            let imageData = NSData(contentsOf:url as URL)
            if imageData != nil {
                self.artWorkImage?.image = UIImage(data:imageData! as Data)
            }
            
        })
    }
    
}

//
//  ViewController.swift
//  MusicSearch
//
//  Created by Bharani Cherukuri on 3/29/17.
//  Copyright © 2017 Bharani.Cherukuri. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var resultTableView: UITableView?
    @IBOutlet weak var searchButton: UIButton?
    @IBOutlet weak var searchTextField: UITextField?
    @IBOutlet weak var errorLabel: UILabel?
    
    fileprivate let dataSource = SearchDataModel(data: [:])
    fileprivate var dataArray = [SearchModelItem]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.resultTableView?.register(UINib(nibName: "MusicTableViewCell", bundle: nil),forCellReuseIdentifier: "cell")
        self.resultTableView?.dataSource = self
        self.resultTableView?.delegate = self
        searchTextField?.delegate = self
        
        //Search Button properties
        self.searchButton?.layer.borderWidth = 0.5
        self.searchButton?.layer.borderColor = UIColor.black.cgColor
        self.searchButton?.layer.cornerRadius = 9
        
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        guard let searchField = searchTextField?.text else {
            return
        }
        
        let serviceInterface = ServiceInterface()
        let searchText = dataSource.specialCharacterFilter(text: searchField)
        
        //Initiate a service call to get Music results
        serviceInterface.getMusicSearchResults(searchText: searchText, onCompletion: { json,data in
            
            if json && data.count > 0 {
                self.dataArray = data
                self.resultTableView?.isHidden = false
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.errorLabel?.isHidden = true
                    self.searchTextField?.resignFirstResponder()
                    self.resultTableView?.reloadData()
                })
                
            } else {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.errorLabel?.isHidden = false
                })
            }
            
        })
    }
    
}

// TableView Methods
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MusicTableViewCell {
            cell.selectionStyle = .none
            
            // Get Thumbnail Image from ArtWork URL
            let url = NSURL(string: dataArray[indexPath.row].artWork!)!
            let data = NSData(contentsOf:url as URL)
            if data != nil {
                cell.artWorkImage?.image = UIImage(data:data! as Data)
            }
            
            cell.trackNameLabel?.text = dataArray[indexPath.row].trackName
            cell.artistName?.text = dataArray[indexPath.row].singerName
            cell.albumName?.text = dataArray[indexPath.row].albumName
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let lyricController = LyricsTableViewController(data: dataArray[indexPath.row])
        self.navigationController?.pushViewController(lyricController, animated: true)
        
    }
    
}

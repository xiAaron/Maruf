//
//  ViewController.swift
//  Maruf
//
//  Created by Aaron Diaz on 11/24/17.
//  Copyright © 2017 BryceSulin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var events: [EventObject]? = []

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        fetchEvents()
    }
    
    func fetchEvents() {
        let urlRequest = URLRequest(url: URL(string: "https://maruf-events.herokuapp.com/Calendars/marufappscheduling@gmail.com/events")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            
            // Create array of events to populate when parsing JSON
            self.events = [EventObject]()
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let eventsFromJson = json["items"] as? [[String: AnyObject]] {
                    for eventFromJson in eventsFromJson {
                        let event = EventObject()
                        if let title = eventFromJson["summary"] as? String, let description = eventFromJson["description"] as? String, let date = eventFromJson["created"] as? String {
                            event.descOfEvent = description
                            event.titleOfEvent = title
                            //event.dateOfEvent = date
                        }
                        
                        // Puts events into the array
                        self.events?.append(event)
                    }
                }
                
                // Refresh tableview data
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventCell
        cell.titleLabel.text = self.events?[indexPath.item].titleOfEvent
        cell.descLabel.text = self.events?[indexPath.item].descOfEvent
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // If not nil, use count value but if nil, returns 0 and won't crash
        return self.events?.count ?? 0
    }

}

extension UIImageView {
    func downloadImage(from url: String) {
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}

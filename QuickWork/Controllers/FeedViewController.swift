//
//  FeedViewController.swift
//  QuickWork
//
//  Created by Christopher Cooper on 5/23/20.
//  Copyright © 2020 Joshua Chan. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var infoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoTableView.delegate = self
        infoTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addListingButton(_ sender: Any) {
        self.performSegue(withIdentifier: Segues.addListing, sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    
    
    
}

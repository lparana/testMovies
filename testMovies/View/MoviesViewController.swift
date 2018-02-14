//
//  MoviesViewController.swift
//  testMovies
//
//  Created by Lara Poveda Arana on 14/02/2018.//  Copyright © 2018 lpoveda. All rights reserved.
//

import UIKit

class MoviesViewController: UITableViewController{

    
    private var moviesList = [MovieShortDesc]()
    private var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadInformation(page:page)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        title = "Movies"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    private func loadInformation(page:Int){
        
        //set waiting symbol
        
        
        Connection.sharedInstance.getPopularMovies{(results:[MovieShortDesc],total_pages:Int, error:Error?) in
            guard error == nil else {return}
            self.moviesList = results
            self.tableView.reloadData()
        }
        
    }
    
    func setupRefresh(){
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return moviesList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)

        // Configure the cell...
        let movie = moviesList[indexPath.row]
        cell.textLabel!.text = movie.title
        if indexPath.row >= moviesList.count - 1 {
            loadInformation(page:page)
        }

        return cell
    }
    
    private func showNoResultsView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 300))
        let label = UILabel(frame: view.frame.insetBy(dx: 10, dy: 10))
        //label.text = (self.searchQuery ?? "").isEmpty ? "No results!" : "Your query:\n'" + self.searchQuery! + "'\nreturned no results"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        label.minimumScaleFactor = 0.4
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.center = view.center
        
        view.addSubview(label)
        
        tableView.tableFooterView = view
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "showDetail"){
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let movie = moviesList[indexPath.row]
                let destinationViewController = segue.destination as! MovieDetailTableViewController
                destinationViewController.movie = movie
            }
        }
    }
    

}


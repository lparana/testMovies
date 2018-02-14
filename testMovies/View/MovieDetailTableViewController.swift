//
//  MovieDetailTableViewController.swift
//  testMovies
//
//  Created by Lara Poveda Arana on 14/02/2018.
//  Copyright © 2018 lpoveda. All rights reserved.
//

import UIKit
struct movieDetail{
    var label:String
    var value: Any
}
class MovieDetailTableViewController: UITableViewController {


    @IBOutlet weak var favbutton: UIBarButtonItem!
    @IBOutlet weak var movieView: UIImageView!
    var movie:MovieShortDesc?
    var favorites:Bool = true
    private var details:MovieDetails?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        if !favorites{ self.navigationItem.rightBarButtonItem = nil}
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        if(movie != nil){
            self.configureView()
        }
    }

    @IBAction func markFavorite(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureView(){
        print(movie?.id)
        Connection.sharedInstance.getMovieDetails(id: (movie?.id)!){(results:MovieDetails?, error:Error?) in
            guard error == nil else {return}
            print(results)
            if results != nil{
                self.details = results!
            }
            self.tableView.reloadData()
            //imageView.image = UIImage(named:"placeholder_wide")
            
            let path = !(self.details?.backdrop_path.isEmpty)! ? self.details?.backdrop_path : self.details?.poster_path
            guard !(path?.isEmpty)! else {return}
            var url:URL?
            if let basePath = UserDefaults.standard.string(forKey: "baseurl") {
                url = URL(string:  basePath + "w780" + path!)
            }
            
            if let url = url {
                self.movieView.downloadedFrom(url: url)
            }
            else {
                self.tableView.tableHeaderView = nil
            }
        }
        if(movie != nil){
            title = movie?.title
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let value = self.details?.dataset.count ?? 0
        return value
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "componentCell", for: indexPath) as! DetailCell

        // Configure the cell...
        if let value = self.details?.dataset[indexPath.section]{
            if (value.title == "Recommended Age"){
                switch value.value as! Bool{
                case true:
                    cell.labeltext.text = "+18"
                case false:
                    cell.labeltext.text  = "All publics"
                }
            }else if(value.title == "Genres" || value.title == "Poduction Companies"){
                cell.labeltext.text  = (value.value as! [String]).joined(separator: ", ")
            }else if(value.title == "Homepage"){
                cell.labeltext.textColor = UIColor.blue
                cell.labeltext.text = value.value as! String
            }else{
                cell.labeltext.text  = value.value as! String
            }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.details?.dataset[section].title
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) -> URLSessionDataTask {
        //guard let url = URL(string: link) else { return nil }
        contentMode = mode
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
        }
        
        task.resume()
        
        return task
    }
}

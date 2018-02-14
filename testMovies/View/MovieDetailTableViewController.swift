//
//  MovieDetailTableViewController.swift
//  testMovies
//
//  Created by Lara Poveda Arana on 14/02/2018.
//  Copyright © 2018 lpoveda. All rights reserved.
//

import UIKit
import CoreData
/*struct movieDetail{
    var label:String
    var value: Any
}*/
class MovieDetailTableViewController: UITableViewController {


    @IBOutlet weak var favbutton: UIBarButtonItem!
    @IBOutlet weak var movieView: UIImageView!
    var movieId:Int?
    var titleMovie:String?
    var favorites:Bool = true
    var rightButtonFav:UIBarButtonItem?
    var rightButtonDelete:UIBarButtonItem?
    var details:MovieDetails?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        rightButtonFav = UIBarButtonItem.init(image: UIImage(named:"emptyStar"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(markFavorite(_:)))
        rightButtonDelete = UIBarButtonItem.init(image: UIImage(named:"star"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(deleteFavorite(_:)))
        
        if !favorites{
            self.navigationItem.rightBarButtonItem = rightButtonDelete
        }else{
            self.navigationItem.rightBarButtonItem = rightButtonFav
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        if(details != nil)
        {
            self.movieId = details?.id
            title = details?.title.value as! String
            self.configureView()
        }else if(movieId != nil){
            self.configureView()
        }
        if(titleMovie != nil){
            title = titleMovie
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureView(){
        
        print(movieId)
        print(UserDefaults.standard.array(forKey: "savedIds"))
        
        //set waiting symbol
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 70))
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = .gray
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
        tableView.tableFooterView = view
        
        //Set corresponding right button
        if UserDefaults.standard.array(forKey: "savedIds") != nil {
            var previousId = (UserDefaults.standard.array(forKey: "savedIds") as! [Int])
            
            if(previousId.contains((movieId)!)){
                self.navigationItem.rightBarButtonItem = rightButtonDelete
            }else{
                self.navigationItem.rightBarButtonItem = rightButtonFav
            }
        }else{
            self.navigationItem.rightBarButtonItem = rightButtonFav
        }
        //If has already the information
        if(details != nil){
            self.tableView.reloadData()
            self.tableView.tableFooterView = nil
            return
        }
        //If not request it
        Connection.sharedInstance.getMovieDetails(id: (movieId)!){(results:MovieDetails?, error:Error?) in
            guard error == nil else {self.alertView();return}
            self.tableView.tableFooterView = nil
            //print(results)
            if results != nil{
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.details = results!
            }
            self.tableView.reloadData()
            //imageView.image = UIImage(named:"placeholder_wide")
            self.setImage()
        }
       
    }
    
    
    private func setImage (){
        //Get Image
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
    
    private func alertView(){
        let alert = UIAlertController(title: "Communication Error", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (alert) in
            self.configureView()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (alert) in
            self.tableView.tableFooterView = nil
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }))
        present(alert, animated: true)
    }
    
    

    @objc func markFavorite(_ sender: Any) {
        print("Entra en Favorite")
        
        let managedContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext)!
        let data = Movie(entity: entity, insertInto: managedContext)
        data.setValue(Int64((details?.id)!), forKey: "id")
        data.setValue(details?.title.value , forKey: "title")
        data.setValue(details?.adult.value, forKey: "adult")
        data.setValue(details?.backdrop_path, forKey: "backdrop_path")
        data.setValue(details?.poster_path, forKey: "poster_path")
        data.setValue(details?.homepage.value, forKey: "homepage")
        data.setValue(details?.overview.value, forKey: "overview")
        data.setValue(details?.release_date.value, forKey: "release_date")
        data.setValue(details?.tagline, forKey: "tagline")
        data.setValue(details?.productionCompanies.value, forKey: "productionCompanies")
        data.setValue(details?.genre.value, forKey: "genre")
        
        do{
            try managedContext.save()
        }catch{
            print("Error guardando la pelicula")
        }
        if UserDefaults.standard.array(forKey: "savedIds") == nil{
            UserDefaults.standard.set([details?.id], forKey: "savedIds")
        }else{
            var previousId = (UserDefaults.standard.array(forKey: "savedIds") as! [Int])
            print(previousId)
            previousId.append((details?.id)!)
            print(previousId)
            UserDefaults.standard.set(previousId, forKey: "savedIds")
        }
        self.navigationItem.rightBarButtonItem = rightButtonDelete
        //Meterlo en la BD
    }
    
    
    
    
    @objc func deleteFavorite(_ sender: Any) {
        print("Entra en delete")
        self.navigationItem.rightBarButtonItem = rightButtonFav
        //Borrarlo de la BD
        let managedContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext)!
        let fetchRequest = NSFetchRequest<Movie>(entityName: "Movie")
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\((details?.id)!)")
        do {
            let results = try managedContext.fetch(fetchRequest)
            if results.count != 0 {
                print(results.count)
                let object = results.first
                managedContext.delete(object!)
            }
        }catch let error as NSError{
            print("Error al recuperar")
        }
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Error al borrar")
        }
        var ids = UserDefaults.standard.array(forKey: "savedIds") as! [Int]
        let posicion = ids.index(of: (details?.id)!)
        _ = ids.remove(at: posicion!)
        UserDefaults.standard.set(ids, forKey: "savedIds")
        
    }
    
    
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

//
//  MovieDetailTableViewController.swift
//  testMovies
//
//  Created by Lara Poveda Arana on 14/02/2018.
//  Copyright © 2018 lpoveda. All rights reserved.
//

import UIKit
import CoreData

class MovieDetailTableViewController: UITableViewController {

    //Mark: Properties
    @IBOutlet weak var favbutton: UIBarButtonItem!
    @IBOutlet weak var movieView: UIImageView!
    
    var movieId:Int?
    var titleMovie:String?
    var favorites:Bool = true
    var details:MovieDetails?
    var image: UIImage?
    
    private var rightButtonFav:UIBarButtonItem?
    private var rightButtonDelete:UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        rightButtonFav = UIBarButtonItem.init(image: UIImage(named:"emptyStar"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(markFavorite(_:)))
        rightButtonDelete = UIBarButtonItem.init(image: UIImage(named:"star"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(deleteFavorite(_:)))
        
        if !favorites{
            self.navigationItem.rightBarButtonItem = rightButtonDelete
        }else{
            self.navigationItem.rightBarButtonItem = rightButtonFav
        }
        
        
        if(details != nil){
            self.movieId = details?.id
            title = (details?.title.value as! String)
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
        
        //set waiting symbol
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 70))
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = .gray
        indicator.center = view.center
        indicator.startAnimating()
        view.addSubview(indicator)
        tableView.tableFooterView = view
        
        //Set corresponding right button
        self.navigationItem.rightBarButtonItem = rightButtonFav
        if let savedIds = UserDefaultsManager.savedIds {
            if(savedIds.contains((movieId)!)){
                self.navigationItem.rightBarButtonItem = rightButtonDelete
            }
        }
        
        //If has already the information
        if(details != nil){
            if(image != nil){
                movieView.image = image
            }else{
                self.tableView.tableHeaderView = nil
            }
            self.tableView.reloadData()
            self.tableView.tableFooterView = nil
            return
        }
        //If not request it
        Connection.sharedInstance.getMovieDetails(id: (movieId)!){(results:MovieDetails?, error:Error?) in
            guard error == nil else {self.alertView();return}
            self.tableView.tableFooterView = nil
            if results != nil{
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.details = results!
            }
            self.tableView.reloadData()
            self.setImage()
        }
       
    }
    
    
    private func setImage (){
        //Get Image
        let path = !(self.details?.backdrop_path.isEmpty)! ? self.details?.backdrop_path : self.details?.poster_path
        guard !(path?.isEmpty)! else {return}
        var url:URL?
        
        if let basePath = UserDefaultsManager.baseurl {
            url = URL(string:  basePath + "w780" + path!)
        }
        
        if let url = url {
            self.movieView.downloadedFrom(url: url)
            self.image = movieView.image
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
                cell.labeltext.text = value.value as? String
            }else{
                cell.labeltext.text  = value.value as? String
            }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.details?.dataset[section].title
    }

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
        if(movieView != nil){
            let image = movieView.image
            let pngImage = UIImagePNGRepresentation(image!)
            data.setValue(pngImage, forKey: "photo")
            
        }
        do{
            try managedContext.save()
        }catch{
            print("Error guardando la pelicula")
        }
        if UserDefaultsManager.savedIds == nil{
            UserDefaultsManager.savedIds = [(details?.id)!]
        }else{
            var previousId = UserDefaultsManager.savedIds as! [Int]
            previousId.append((details?.id)!)
            UserDefaultsManager.savedIds = previousId
        }
        self.navigationItem.rightBarButtonItem = rightButtonDelete
    }
    
    
    
    
    @objc func deleteFavorite(_ sender: Any) {

        self.navigationItem.rightBarButtonItem = rightButtonFav
        
        let managedContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Movie>(entityName: "Movie")
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\((details?.id)!)")
        do {
            let results = try managedContext.fetch(fetchRequest)
            if results.count != 0 {
                print(results.count)
                let object = results.first
                managedContext.delete(object!)
            }
        }catch _ as NSError{
            print("Error al recuperar")
        }
        do{
            try managedContext.save()
        }catch _ as NSError{
            print("Error al borrar")
        }
        var ids = UserDefaultsManager.savedIds as! [Int]
        let posicion = ids.index(of: (details?.id)!)
        _ = ids.remove(at: posicion!)
        UserDefaultsManager.savedIds = ids
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

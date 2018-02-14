//
//  FavoritesViewController.swift
//  testMovies
//
//  Created by Lara Poveda Arana on 14/02/2018.
//  Copyright © 2018 lpoveda. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UITableViewController {

    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Movie.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    var listFavMovies:[Movie]?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Favorite Movies"
        updateContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func updateContent(){
        do {
            try self.fetchedhResultController.performFetch()
        } catch let error  {
            print("ERROR en updateContent: \(error)")
        }
        if let movies = fetchedhResultController.fetchedObjects as? [Movie]{
            listFavMovies = movies
            self.tableView.tableFooterView = nil
        }
        if(listFavMovies?.count == 0){
            self.NoResultsView()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listFavMovies!.count
    }

    
    private func NoResultsView() {
        let view = UIView(frame: CGRect(x: 0, y: 30, width: tableView.frame.size.width, height: 300))
        let label = UILabel(frame: view.frame.insetBy(dx: 10, dy: 10))
        label.text = "You have not selected any movie as Favorite."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        label.minimumScaleFactor = 0.4
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.center = view.center
        
        view.addSubview(label)
        
        tableView.tableFooterView = view
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)

        cell.textLabel?.text = listFavMovies![indexPath.row].title
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "showDetail"){
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let movieData = (listFavMovies![indexPath.row] as Movie).getKeyedValues()
                let movieDetail = MovieDetails(movie: movieData)
                let destinationViewController = segue.destination as! MovieDetailTableViewController
                destinationViewController.details = movieDetail
                destinationViewController.favorites = false
                if let image = (listFavMovies![indexPath.row] as Movie).photo {
                    let ImageView = UIImage(data: image as Data)
                    destinationViewController.image = ImageView
                }
                
            }
        }
    }

}
extension FavoritesViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            print("default")
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

        updateContent()
        tableView.reloadData()
        tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
}

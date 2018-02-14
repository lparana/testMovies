//
//  Connection.swift
//  testMovies
//
//  Created by Lara Poveda Arana on 14/02/2018.
//  Copyright © 2018 lpoveda. All rights reserved.
//

import Foundation
import Alamofire

class Connection {
    
    static let sharedInstance = Connection()
    private var moviedb = "https://api.themoviedb.org/3/movie/"
    private var defaultParams:[String : Any] {
        return ["api_key" : APIKey]
    }
    enum connectionError:Error{
        case EmtyResponse
        case InvalidResponse
    }
    func getPopularMovies(page:Int = 1,completion:@escaping([MovieShortDesc],Int,Error?)->Void){
        //Hacer peticion de pelis a la URL
        let url = moviedb+"popular"
        var parameters = defaultParams
        //parameters["append_to_response"] = "images"
        parameters["page"] = page
        Alamofire.request(url, method:.get ,parameters:parameters).validate().responseJSON { (response) in
            guard response != nil else {
                completion([],0,connectionError.EmtyResponse);return}
            //print(response)
            //print(response.result)
            switch response.result{
            case .failure(let error):
                completion([],0,connectionError.EmtyResponse);return
            case .success(_):
                print("success")
            }
            print("No hay fallo")
            let object = response.result.value as! [String:Any]
            guard let results = object["results"] as? [AnyObject] else {completion([],0,connectionError.InvalidResponse);return}
            
            let total_results = object["total_results"] as! Int
            let total_pages = object["total_pages"] as! Int
            if total_pages == -1 {completion([],0,connectionError.InvalidResponse);return}
            
            var movies = [MovieShortDesc]()
            for i in results{
                movies.append(MovieShortDesc(value:i))
            }
            //Success
            completion(movies,total_pages,nil)
        }
    }
    
    
    func getMovieDetails(id:Int,completion:@escaping(MovieDetails?,Error?)->Void){
        //Hacer peticion de pelis a la URL
        let url = moviedb+"\(id)"
        var parameters = defaultParams
        //parameters["append_to_response"] = "images"
        Alamofire.request(url, method:.get ,parameters:parameters).responseJSON { (response) in
            guard response != nil else {
                completion(nil,connectionError.EmtyResponse);return}
            
            //print(response)
            switch response.result{
            case .failure(let error):
                completion(nil,connectionError.EmtyResponse);return
            case .success(_):
                print("success")
            }
            
            guard let object = response.result.value as? [String:Any] else {completion(nil,connectionError.InvalidResponse);return}
            //Crear Objeto de MovieDetailed
            let movie = MovieDetails(movie: object)
            //Pedir el cast de la peli
            /*self.getCast(id: movie.id, completion: { (cast, error) in
                if(error == nil && cast != []){
                    movie.cast.value = cast
                }*/
                //Success
                completion(movie,nil)
           // })
            
        }
    }
    func getConfiguration(completion:@escaping (Bool) -> Void) {
        let url = "https://api.themoviedb.org/3/configuration"
        let parameters = defaultParams
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            guard response != nil else {
                completion(false)
                return
            }
            //debugPrint(response)
            let response = response.result.value! as! [String : Any]
            let imagesDic = response["images"] as! [String : Any]
            let path = imagesDic["secure_base_url"] as! String
            
            UserDefaults.standard.set(path, forKey: "baseurl")
            completion(true)
            
        }
    }
    
    
}

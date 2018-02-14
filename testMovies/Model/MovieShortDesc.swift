//
//  Movie.swift
//  testMovies
//
//  Created by Lara Poveda Arana on 14/02/2018.
//  Copyright © 2018 lpoveda. All rights reserved.
//

import Foundation

class MovieShortDesc {
    
    var poster_path: String
    var adult: Bool
    var overview: String
    var release_date: String
    var genreids: [Int] = []
    var id: Int
    var original_title: String
    var original_language: String
    var title: String
    var backdrop_path: String
    var popularity: Double
    var vote_count: Int
    var video: Bool
    var vote_average: Double
    
    init(value:AnyObject) {
        
        poster_path = value.object(forKey: "poster_path") as? String ?? ""
        adult = value.object(forKey: "adult") as! Bool
        overview = value.object(forKey: "overview") as? String ?? ""
        release_date = value.object(forKey: "release_date") as? String ?? ""
        if let ids = value.object(forKey: "genre_ids") as? [Int] {
            genreids = ids
        }
        id = value.object(forKey: "id") as! Int
        original_title = value.object(forKey: "original_title") as? String ?? ""
        original_language = value.object(forKey: "original_language") as? String ?? ""
        title = value.object(forKey: "title") as? String ?? ""
        backdrop_path = value.object(forKey: "backdrop_path") as? String ?? ""
        popularity = value.object(forKey: "popularity")  as! Double
        vote_count = value.object(forKey: "vote_count") as! Int
        video = value.object(forKey: "video") as! Bool
        vote_average = value.object(forKey: "vote_average")  as! Double
        
        
    }
}

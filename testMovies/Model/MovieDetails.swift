//
//  MovieDetails.swift
//  testMovies
//
//  Created by Lara Poveda Arana on 14/02/2018.
//  Copyright © 2018 lpoveda. All rights reserved.
//

import Foundation

class MovieDetails {

    var poster_path: String
    var adult: pairs
    var overview: pairs
    var release_date: pairs
    var genre:pairs
    var id: Int
    var title: pairs
    var backdrop_path: String
    var homepage: pairs
    var productionCompanies: pairs
    var tagline: String
    struct pairs {
        var title:String
        var value:Any?
    }
    var dataset:[pairs]
    
    init(movie: [String:Any]) {
        
        id = movie["id"] as! Int
        title = pairs(title: "Title", value: movie["title"] as? String ?? "")
        overview = pairs(title: "Overview", value: movie["overview"] as? String ?? "")
        homepage = pairs(title: "Homepage", value: movie["homepage"] as? String ?? "")
        adult = pairs(title: "Recommended Age", value: movie["adult"] as! Bool )
        release_date = pairs(title: "Release Date", value: movie["release_date"] as? String ?? "")
        var values:[String] = []
        if let ids = movie["genres"] as? [[String:Any]] {
            for i in ids{
                values.append((i as [String:Any])["name"] as! String)
            }
        }else if let ids = movie["genres"] as? [String] {
            values = ids
            
        }
        genre = pairs(title: "Genres", value: values)
        backdrop_path = movie["backdrop_path"] as? String ?? ""

        values = []
        if let ids = movie["production_companies"] as? [[String:Any]] {
            for i in ids{
                values.append((i as [String:Any])["name"] as! String)
            }
        }else if let ids = movie["production_companies"] as? [String] {
            values = ids
        }
        productionCompanies = pairs(title: "Poduction Companies", value: values)
        tagline = movie["tagline"] as? String ?? ""
        poster_path = movie["poster_path"] as? String ?? ""

        dataset = [title, overview, homepage, adult, release_date, genre, productionCompanies]
    }
}


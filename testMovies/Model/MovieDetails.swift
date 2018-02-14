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
    //var original_title: String
    //var original_language: String
    var title: pairs
    var backdrop_path: String
    //var popularity: Double
    //var vote_count: Int
    //var video: Bool
    //var vote_average: Double
    var homepage: pairs
    var productionCompanies: pairs
    var tagline: String
    //var cast: pairs
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
                print((i as [String:Any])["name"])
                values.append((i as [String:Any])["name"] as! String)
            }
        }
        genre = pairs(title: "Genres", value: values)
        backdrop_path = movie["backdrop_path"] as? String ?? ""
        
 
        values = []
        if let ids = movie["production_companies"] as? [[String:Any]] {
            for i in ids{
                print((i as [String:Any])["name"])
                values.append((i as [String:Any])["name"] as! String)
            }
        }
        productionCompanies = pairs(title: "Poduction Companies", value: values)
        tagline = movie["tagline"] as? String ?? ""
        
        
        poster_path = movie["poster_path"] as? String ?? ""
        /*original_title = movie["original_title"] as? String ?? ""
        original_language = movie["original_language"] as? String ?? ""
        popularity = movie["popularity"]  as! Double
        vote_count = movie["vote_count"] as! Int
        video = movie["video"] as! Bool
        vote_average = movie["vote_average"]  as! Double*/

        dataset = [title, overview, homepage, adult, release_date, genre, productionCompanies]
    }
}
/*{
    "adult": false,
    "backdrop_path": "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg",
    "belongs_to_collection": null,
    "budget": 63000000,
    "genres": [
    {
    "id": 18,
    "name": "Drama"
    }
    ],
    "homepage": "",
    "id": 550,
    "imdb_id": "tt0137523",
    "original_language": "en",
    "original_title": "Fight Club",
    "overview": "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.",
    "popularity": 0.5,
    "poster_path": null,
    "production_companies": [
    {
    "name": "20th Century Fox",
    "id": 25
    }
    ],
    "production_countries": [
    {
    "iso_3166_1": "US",
    "name": "United States of America"
    }
    ],
    "release_date": "1999-10-12",
    "revenue": 100853753,
    "runtime": 139,
    "spoken_languages": [
    {
    "iso_639_1": "en",
    "name": "English"
    }
    ],
    "status": "Released",
    "tagline": "How much can you know about yourself if you've never been in a fight?",
    "title": "Fight Club",
    "video": false,
    "vote_average": 7.8,
    "vote_count": 3439
}*/

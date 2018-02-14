//
//  Movie+CoreDataProperties.swift
//  testMovies
//
//  Created by Lara Poveda Arana on 14/02/2018.
//  Copyright © 2018 lpoveda. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var adult: Bool
    @NSManaged public var backdrop_path: String?
    @NSManaged public var genre: NSObject?
    @NSManaged public var homepage: String?
    @NSManaged public var id: Int64
    @NSManaged public var overview: String?
    @NSManaged public var photo: NSData?
    @NSManaged public var poster_path: String?
    @NSManaged public var productionCompanies: NSObject?
    @NSManaged public var release_date: String?
    @NSManaged public var tagline: String?
    @NSManaged public var title: String?
    
    func getKeyedValues() -> [String:Any]{
        return [
            "adult": adult,
            "backdrop_path": backdrop_path!,
            "genres": genre as! [String],
            "homepage": homepage!,
            "id": Int(id),
            "overview": overview!,
            "poster_path": poster_path!,
            "production_companies": productionCompanies as! [String],
            "release_date": release_date!,
            "tagline": tagline!,
            "title": title!
        ]
    }

}

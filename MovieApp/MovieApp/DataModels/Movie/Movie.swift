//
//  Movie.swift
//
//  Created by Jayesh on 04/01/19
//  Copyright (c) Logistic Infotech Pvt. Ltd.. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Movie: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let posterPath = "poster_path"
        static let releaseDate = "release_date"
        static let id = "id"
        static let presaleFlag = "presale_flag"
        static let genreIds = "genre_ids"
        static let ageCategory = "age_category"
        static let title = "title"
        static let rate = "rate"
        static let description = "description"
    }
    
    // MARK: Properties
    public var posterPath: String?
    public var releaseDate: Double?
    public var id: String?
    public var presaleFlag: Int?
    public var genreIds: [GenreIds]?
    public var ageCategory: String?
    public var title: String?
    public var rate: Float?
    public var description:String?
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public required init(json: JSON) {
        posterPath = json[SerializationKeys.posterPath].string
        releaseDate = json[SerializationKeys.releaseDate].double
        id = json[SerializationKeys.id].string
        presaleFlag = json[SerializationKeys.presaleFlag].int
        if let items = json[SerializationKeys.genreIds].array { genreIds = items.map { GenreIds(json: $0) } }
        ageCategory = json[SerializationKeys.ageCategory].string
        title = json[SerializationKeys.title].string
        rate = json[SerializationKeys.rate].float
        description = json[SerializationKeys.description].string
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = posterPath { dictionary[SerializationKeys.posterPath] = value }
        if let value = releaseDate { dictionary[SerializationKeys.releaseDate] = value }
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = presaleFlag { dictionary[SerializationKeys.presaleFlag] = value }
        if let value = genreIds { dictionary[SerializationKeys.genreIds] = value.map { $0.dictionaryRepresentation() } }
        if let value = ageCategory { dictionary[SerializationKeys.ageCategory] = value }
        if let value = title { dictionary[SerializationKeys.title] = value }
        if let value = rate { dictionary[SerializationKeys.rate] = value }
        if let value = description { dictionary[SerializationKeys.description] = value }
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.posterPath = aDecoder.decodeObject(forKey: SerializationKeys.posterPath) as? String
        self.releaseDate = aDecoder.decodeObject(forKey: SerializationKeys.releaseDate) as? Double
        self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
        self.presaleFlag = aDecoder.decodeObject(forKey: SerializationKeys.presaleFlag) as? Int
        self.genreIds = aDecoder.decodeObject(forKey: SerializationKeys.genreIds) as? [GenreIds]
        self.ageCategory = aDecoder.decodeObject(forKey: SerializationKeys.ageCategory) as? String
        self.title = aDecoder.decodeObject(forKey: SerializationKeys.title) as? String
        self.rate = aDecoder.decodeObject(forKey: SerializationKeys.rate) as? Float
        self.description = aDecoder.decodeObject(forKey: SerializationKeys.description) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(posterPath, forKey: SerializationKeys.posterPath)
        aCoder.encode(releaseDate, forKey: SerializationKeys.releaseDate)
        aCoder.encode(id, forKey: SerializationKeys.id)
        aCoder.encode(presaleFlag, forKey: SerializationKeys.presaleFlag)
        aCoder.encode(genreIds, forKey: SerializationKeys.genreIds)
        aCoder.encode(ageCategory, forKey: SerializationKeys.ageCategory)
        aCoder.encode(title, forKey: SerializationKeys.title)
        aCoder.encode(rate, forKey: SerializationKeys.rate)
        aCoder.encode(description, forKey: SerializationKeys.description)
    }
    
}

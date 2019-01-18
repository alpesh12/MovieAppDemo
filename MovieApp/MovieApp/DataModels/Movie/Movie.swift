//
//  Movie.swift
//
//  Created by Jayesh on 04/01/19
//  Copyright (c) Logistic Infotech Pvt. Ltd.. All rights reserved.
//

import Foundation

class Movie: Codable {
    let id, title: String
    let genreIDS: [GenreID]
    let ageCategory: String
    let rate: Double
    let releaseDate: Int
    let posterPath: String
    let presaleFlag: Int
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case genreIDS = "genre_ids"
        case ageCategory = "age_category"
        case rate = "rate"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case presaleFlag = "presale_flag"
        case description = "description"
    }
    
    init(id: String, title: String, genreIDS: [GenreID], ageCategory: String, rate: Double, releaseDate: Int, posterPath: String, presaleFlag: Int, description: String?) {
        self.id = id
        self.title = title
        self.genreIDS = genreIDS
        self.ageCategory = ageCategory
        self.rate = rate
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.presaleFlag = presaleFlag
        self.description = description
    }
}

class GenreID: Codable {
    let id, name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}


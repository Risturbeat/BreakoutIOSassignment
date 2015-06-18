//
//  RecentSearches.swift
//  SmashTag
//
//  Created by Student on 01-05-15.
//  Copyright (c) 2015 HAN. All rights reserved.
//

import Foundation

class RecentSearches{
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    
    var recentSearches: [String] {
        get{
            return defaults.objectForKey("recentSearches") as! [String]
        }
        set{
            defaults.setObject(newValue, forKey: "recentSearches")
        }
    }
    
    func addSearch(recentSearch: String){
        var currentSearches = recentSearches

        currentSearches.insert(recentSearch, atIndex: 0)
        while currentSearches.count > 100 {
            currentSearches.removeLast()
        }
        recentSearches = currentSearches
    }
    
    func deleteSearch(index : Int){
        recentSearches.removeAtIndex(index)
    }
}

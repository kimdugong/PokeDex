//
//  Pokemon.swift
//  PokeDex
//
//  Created by Joosung Kim on 27/01/2017.
//  Copyright © 2017 Joosung Kim. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var name: String {
        
        return _name
    }
    
    var pokedexId: Int {
        
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetail(complete: @escaping DownloadComplete) {
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            //print(response.result.value!)
            
            if let dict = response.result.value as? Dictionary<String, Any> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        for obj in 1..<types.count {
                            if let name = types[obj]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                 
                } else {
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] {
                    if let url = descArr[0]["resource_uri"] {
                        Alamofire.request("\(URL_BASE)\(url)").responseJSON(completionHandler: { (response) in
    
                            if let descDict = response.result.value as? Dictionary<String, Any> {
                                if let description = descDict["description"] as? String {
                                    print(description)
                                    self._description = description
                                }
                                complete()
                            }
                        })
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, Any>] {
                    if evolutions.isEmpty == false {
                        if let nextEvo = evolutions[0]["to"] as? String {
                            if nextEvo.range(of: "mega") == nil {
                                self._nextEvolutionName = nextEvo
                                
                                if let uri = evolutions[0]["resource_uri"] as? String {
                                    let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                    let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                    self._nextEvolutionId = nextEvoId
                                }
                                
                                if let nextExist = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLevel = "\(nextExist)"
                                } else {
                                    self._nextEvolutionLevel = ""
                                }
                            }
                        }
                    }
                }
            }
            
            complete()
        }
    }
}

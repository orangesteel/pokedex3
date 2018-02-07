//
//  pokemon.swift
//  pokedex3
//
//  Created by Simon Salmon on 25/01/2018.
//  Copyright © 2018 Simon Salmon. All rights reserved.
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
    private var _pokemonURL: String!
    
    //Getters to protect against nil responses
    var nextEvolutionText: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
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
            _description = "..."
        }
        return _description
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
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        Alamofire.request(_pokemonURL).responseJSON { (response) in

           if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? Int {
                    self._weight = "\(weight)"
                }
                if let height = dict["height"] as? Int {
                    self._height = "\(height)"
                }
            //Download Attack and Defense - for v2 API
            if let statsDict = dict["stats"] as? [Dictionary <String, AnyObject>] , statsDict.count > 0  {
                if let statDes = statsDict[0]["stat"]?["name"]! {
                    self._attack = ("\(statDes)")
                }
                for x in 0..<statsDict.count {
                    if let statDes = statsDict[x]["stat"]?["name"]! {
                        if "\(statDes)" == "defense" {
                            if let defenseInt = statsDict[x]["base_stat"] {
                                self._defense  = "\(defenseInt)"
                            }
                        }
                        if "\(statDes)" == "attack" {
                            if let attackInt = statsDict[x]["base_stat"] {
                                self._attack  = "\(attackInt)"
                            }
                        }
                        
                    }
                }
            }
                //Download Type - for v2 API
                if let typesDict = dict["types"] as? [Dictionary <String, AnyObject>] , typesDict.count > 0  {
                    if let typeDes = typesDict[0]["type"]!["name"]! {
                        self._type = ("\(typeDes)")
                    }
                    for x in 1..<typesDict.count {
                        if let typeDes = typesDict[x]["type"]!["name"]! {
                            self._type! += "/\(typeDes)"
                        }
                    }
                }
                self._type = self._type.capitalized
        
                //Download Description for v2 API
                let speciesURL = URL_BASE + URL_SPECIES + "\(self.pokedexId)"
                Alamofire.request(speciesURL).responseJSON { (response) in
                    if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                        if let flavourDict = descDict["flavor_text_entries"] as? [Dictionary <String, AnyObject>] , descDict.count > 0 {
                            if let detailDescription = flavourDict[1]["flavor_text"] {
                                self._description = "\(detailDescription)"
                                let trimmed = self._description.replacingOccurrences(of: "\n", with: "", options: .regularExpression)
                                self._description = self._description.replacingOccurrences(of: "POKMON", with: "Pokémon", options: .regularExpression)
                                self._description = trimmed
                            }
                        }
                        
                    }
                    //Now get the evolution URL from the current URL
                    if let evoURLDict = response.result.value as? Dictionary<String, AnyObject> {
                        if let evoURLRaw = evoURLDict["evolution_chain"]!["url"]! {
                            let evoURL = "\(evoURLRaw)"
                            //Now request the relative evolution URL
                            Alamofire.request(evoURL).responseJSON { (response) in
                                //pass into dictionary
                                if let evoInfoDict = response.result.value as? Dictionary<String, AnyObject> {
                                    print("ssssssssssssssssss")
                                    if let evoInfoEvolvesBranchDict = evoInfoDict["chain"]!["evolves_to"] as? [Dictionary <String, AnyObject>] , evoInfoDict.count > 0 {
                                        if let evolution2 = evoInfoEvolvesBranchDict[0]["species"]!["name"]! {
                                            self._nextEvolutionTxt = "\(evolution2)"
                                            self._nextEvolutionTxt.capitalized
                                        }
                                        if let evolution3Dict = evoInfoEvolvesBranchDict[0]["evolves_to"] {  //case as array/dict
                                            if let evolution3 = evolution3Dict[0]!["species"]["name"]! {
                                                
                                            }
                                            
                                        }
                                        print(evoInfoEvolvesBranchDict.count)
                                        print("tttttttttttttttttt")
                                        
//                                        if let evolution2 = evoInfoEvolvesBranchDict["species"]!["1"]! {
//                                            if let evolution2a = evolution2["name"] {
//                                                self._nextEvolutionTxt = "\(evolution2a)"
//                                                print(evolution2a)
//                                            }
//
//                                        }
                                        

                        }
                    }
                    completed()
                    }
                
            }
          
        }
          completed()
            }
            }
         completed()
            }
    } //end func download poke malarky
    
} // this is the end!

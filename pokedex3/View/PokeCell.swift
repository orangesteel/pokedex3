//
//  PokeCell.swift
//  pokedex3
//
//  Created by Simon Salmon on 25/01/2018.
//  Copyright © 2018 Simon Salmon. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //each view has a layer level
        layer.cornerRadius = 10.0
    }
    
    func configureCell(pokemon: Pokemon) {
        
        self.pokemon = pokemon
        nameLbl.text = self.pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
    
    
}

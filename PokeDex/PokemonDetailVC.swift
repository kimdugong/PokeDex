//
//  PokemonDetailVC.swift
//  PokeDex
//
//  Created by Joosung Kim on 27/01/2017.
//  Copyright © 2017 Joosung Kim. All rights reserved.
//

import UIKit
import AVFoundation

class PokemonDetailVC: UIViewController {
    
    private var _pokemon: Pokemon!
    var pokemon: Pokemon {
        get {
            if _pokemon == nil {
                return Pokemon(name: "dugong", pokedexId: 1)
            }
            return _pokemon!
        }
        
        set {
            _pokemon = newValue
        }
    }
    
    var musicPlayer: AVAudioPlayer!

    @IBOutlet weak var musicBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(pokemon.name)
        
        nameLbl.text = pokemon.name.capitalized
        
        mainImg.image = UIImage(named:  "\(pokemon.pokedexId)")
        
        pokemon.downloadPokemonDetail { 
            self.updateUI()
        }
        checkMusicPlay()
    }
    
    func updateUI () {
        self.descriptionLbl.text = self.pokemon.description
    }
    
    func checkMusicPlay() {
        if musicPlayer.isPlaying {
            musicBtn.alpha = 1.0
        } else {
            musicBtn.alpha = 0.2
        }
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "DetailTable" {
//            if let detailTable = segue.destination as? PokemonDetailTableVC {
//                if let pokemon = sender as? Pokemon {
//                    detailTable.pokemon = pokemon
//                }
//            }
//        }
//    }

}

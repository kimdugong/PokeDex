//
//  ViewController.swift
//  PokeDex
//
//  Created by Joosung Kim on 27/01/2017.
//  Copyright © 2017 Joosung Kim. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var musicBtn: UIButton!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkMusicPlay()
    }

    func parsePokemonCSV() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let pokemon = Pokemon(name: name, pokedexId: pokeId)
                
                self.pokemon.append(pokemon)
                
            }
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func checkMusicPlay() {
        if musicPlayer.isPlaying {
            musicBtn.alpha = 1.0
        } else {
            musicBtn.alpha = 0.2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            let pokemon: Pokemon!
            
            if inSearchMode {
                pokemon = filteredPokemon[indexPath.row]
            } else {
                pokemon = self.pokemon[indexPath.row]
            }
            
            cell.configureCell(pokemon)
            
            return cell
        } else {
            
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var pokemon: Pokemon!
        
        if inSearchMode {
            pokemon = filteredPokemon[indexPath.row]
        } else {
            pokemon = self.pokemon[indexPath.row]
        }
        
        ad.pokemon = pokemon
        performSegue(withIdentifier: "PokemonDetailVC", sender: pokemon)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return self.filteredPokemon.count
        } else {
            return self.pokemon.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //cell size 변경
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collection.frame.width / 3.4, height: self.collection.frame.width / 3.4)
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredPokemon = pokemon.filter({
                $0.name.range(of: lower) != nil
            })
            collection.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let pokemon = sender as? Pokemon {
                    detailsVC.pokemon = pokemon
                    detailsVC.musicPlayer = musicPlayer
                }
                
            } 
        }
        
    }

}


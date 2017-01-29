//
//  PokemonDetailTableVC.swift
//  PokeDex
//
//  Created by Joosung Kim on 28/01/2017.
//  Copyright © 2017 Joosung Kim. All rights reserved.
//

import UIKit

class PokemonDetailTableVC: UITableViewController {
    
    
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    

//    var pokemon: Pokemon!
    var pokemon: Pokemon {
        if ad.pokemon == nil {
            return Pokemon(name: "dugong", pokedexId: 1)
        }
        return ad.pokemon!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemon.downloadPokemonDetail { 
            self.updateUI()
        }
    }
    
    func updateUI() {
        baseAttackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        pokedexLbl.text = "\(pokemon.pokedexId)"
        currentEvoImg.image = UIImage(named: "\(pokemon.pokedexId)")
        typeLbl.text = pokemon.type
        nextEvoImg.image = UIImage(named: "\(pokemon.nextEvolutionId)")
        
        if pokemon.nextEvolutionLevel == "" {
            evoLbl.text = "There is no evolution next"
        } else {
            
            evoLbl.text = "Next Evolution: \(pokemon.nextEvolutionName) Lv.\(pokemon.nextEvolutionLevel)"
        }
    }



    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

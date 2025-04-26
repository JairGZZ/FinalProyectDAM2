//
//  HomeViewController.swift
//  FinalProyectDAM2
//
//  Created by DAMII on 15/04/25.
//

import UIKit
import CoreData


struct Markets {
    var name: String
    var district: String
}

class HomeViewController: UIViewController,UITableViewDataSource,UISearchBarDelegate {
    

    @IBOutlet weak var searchMarketSB: UISearchBar!
    @IBOutlet weak var marketsTableView: UITableView!
    
    var mercadoList : [MercadoEntity] =  []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marketsTableView.dataSource = self
        searchMarketSB.delegate = self
        listCoreData()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mercadoList.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "marketsCell", for: indexPath) as! MarketsTableViewCell
        
        let clientActual = mercadoList[indexPath.row]
        cell.marketNameLbl.text = clientActual.nombreMercado
        cell.districtMarketLbl.text = clientActual.distritoMercado
        
        return cell
    }
    
    
    @IBAction func addMarketBtn(_ sender: Any) {
        var nombreText = UITextField()
        var numeroText = UITextField()
        
        let alert = UIAlertController(title: "Registrar un nuevo Mercado", message: "Todos los mercados serán almacenados en la nube", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Nombre"
            nombreText = textField
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Distrito del Mercado"
            numeroText = textField
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar",
                                      style: .cancel))
        
        let acRegister = UIAlertAction(title: "Registrar", style: .default, handler: {_ in
            
            let nombre = nombreText.text ?? ""
            let numero = numeroText.text ?? ""
            self.registerCoreData(nombre: nombre, distrito: numero)
            
            
            
        })
        
        alert.addAction(acRegister)
        present(alert, animated: true)
    }
    
}

// SearchBar
extension HomeViewController {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

// CoreData
extension HomeViewController {
    
    func registerCoreData(nombre: String, distrito: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let contacto = MercadoEntity(context: context)
        contacto.nombreMercado = nombre
        contacto.distritoMercado = distrito
        
        
        do {
            try context.save()
            mercadoList.append(contacto)
        } catch let error as NSError {
            print(error)
        }
        marketsTableView.reloadData()
    }
    
    func listCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<MercadoEntity> = MercadoEntity.fetchRequest()
        do {
            mercadoList = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
        }
        marketsTableView.reloadData()
    }
    
    func editCoreData() {}
    
    func deleteCoreData() {}
    
    func searchCoreData() {}
    
}

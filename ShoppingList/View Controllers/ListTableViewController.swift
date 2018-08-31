//
//  ListTableViewController.swift
//  ShoppingList
//
//  Created by John Tate on 8/31/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, ListItemTableViewCellDelegate {
    
    func toggleIsPurchasedButton(cell: ListItemTableViewCell) {
        
        guard let image = cell.isPurchasedButton.imageView?.image,
            let indexPath = tableView.indexPath(for: cell),
            let item = fetchedResultsController.fetchedObjects?[indexPath.row] else { return }
        
        // toggle is performed here, so want the image to be the opposite of the Bool for isPurchased
        switch image{
        case #imageLiteral(resourceName: "complete"):
            item.isPurchased = false
        case #imageLiteral(resourceName: "incomplete"):
            item.isPurchased = true
        default:
            print("Default")
        }
    }
    

    // MARK: - Properties
    
    let fetchedResultsController: NSFetchedResultsController<Item> = {
       
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath) as? ListItemTableViewCell
        let item = fetchedResultsController.fetchedObjects?[indexPath.row]
        cell?.item = item
        cell?.delegate = self
        return cell ?? UITableViewCell()
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let item = fetchedResultsController.fetchedObjects?[indexPath.row] else { return }
            CoreDataStack.delete(item: item)
        }
    }
    
    // MARK: - Present Alert Controller
    
    func presentAlertController() {
        let alertController = UIAlertController(title: "Add Item", message: "Please add an item to your shopping list", preferredStyle: .alert)
        alertController.addTextField { (itemTextField) in
            itemTextField.placeholder = "Item"
        }
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            
            guard let itemText = alertController.textFields?[0].text else { return }
            
            Item(name: itemText)
            CoreDataStack.saveToPersistentStore()
            self.tableView.reloadData()
        }
        alertController.addAction(dismissAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true)
    }
        
        
    // MARK: - IBAction

    @IBAction func addButtonTapped(_ sender: Any) {
        presentAlertController()
    }
    
}

//
//  PairsListTableViewController.swift
//  Pair
//
//  Created by Jason Koceja on 12/3/20.
//

import UIKit

class PairsListTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var randomizeButton: UIButton!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        if PairsController.shared.groups.count > 1 {
            randomizeButton.isEnabled = true
        } else {
            randomizeButton.isEnabled = false
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        presentAddPersonAlert()
    }
    
    @IBAction func randomizeButtonTapped(_ sender: UIButton) {
        randomizePersons()
    }
    
    // MARK: - Helpers
    
    func presentAddPersonAlert() {
        let title = "Add Person"
        let message = "Add someone new to the list"
        let placeholderString = "Full Name"
        let actionTitle = "Add"
        let cancelTitle = "Cancel"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = placeholderString
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .words
        }
        
        let addPersonAction = UIAlertAction(title: actionTitle, style: .default) { (_) in
            guard let nameText = alertController.textFields?.first?.text,
                  !nameText.isEmpty else { return }
            PairsController.shared.addPersonWithName(nameText)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        
        alertController.addAction(addPersonAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func randomizePersons() {
        PairsController.shared.randomizePairs()
        self.tableView.reloadData()
    }
    
    func reloadIfLonelys() {
        if PairsController.shared.pairLonelys() {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return PairsController.shared.groups.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PairsController.shared.groups[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if PairsController.shared.groups[0].count == 0 {
                return "No People added"
            }
        }
        return "Group \(section + 1)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        cell.textLabel?.text = PairsController.shared.groups[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PairsController.shared.removePersonAtIndexPath(indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            reloadIfLonelys()
        }    
    }
}

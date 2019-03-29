//
//  MyQuotesTableViewController.swift
//  My Quotes
//
//  Created by FarouK on 03/01/2019.
//  Copyright © 2019 FarouK. All rights reserved.
//

import UIKit
import CoreData

class MyQuotesTableViewController: UITableViewController {
    
    @IBOutlet var quoteTableView: UITableView!
    var dataController: DataController!
    var quotes: [Quote] = []
    
    @IBOutlet var noQuotesView: UIView!
    @IBOutlet var helpView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        makeFetchRequest()
    }
    
    func makeFetchRequest() {
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            quotes = result
        }
        DispatchQueue.main.async {
            self.quoteTableView.reloadData()
            if self.quotes.count > 0 {
                //if self.tableView.visibleCells > 0
                
                if UserDefaults.standard.bool(forKey: "helpViewSeen") == false {
                    let cell = self.tableView.visibleCells[0] as! MyTableViewCell
                    cell.makeSwapAnimation()
                    UserDefaults.standard.set(true, forKey: "helpViewSeen")
                    
                    //Uncomment this code to make help view feature works again.
//                    self.helpView.alpha = 1
//                    self.addHelperView()
//                    self.tabBarController?.tabBar.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.size.width, height: self.tabBarController?.tabBar.frame.size.height ?? 10)
                }
            }
        }
    }
    
    func addHelperView() {
        view.addSubview(helpView)
        helpView.frame = view.frame
    }
    
    func removeHelperView() {
        self.helpView.removeFromSuperview()
    }
    
    @IBAction func closeHelpView(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        UIView.animate(withDuration: 0.5, animations: {
            self.helpView.alpha = 0
            self.tabBarController?.tabBar.frame = CGRect(x: 0, y: self.view.frame.height - (self.tabBarController?.tabBar.frame.size.height ?? 0), width: self.view.frame.size.width, height: self.tabBarController?.tabBar.frame.size.height ?? 10)
        }) { (success) in
            //self.helpView.removeFromSuperview()
            self.removeHelperView()
            UserDefaults.standard.set(true, forKey: "helpViewSeen")
        }
    }
    
    @objc func resetHelpViews(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        let alert = UIAlertController(title: "Reset Help Screens", message: "Do you want to reset help screens?", preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.view.tintColor = #colorLiteral(red: 0.8509803922, green: 0.4784313725, blue: 0.7450980392, alpha: 1)
        alert.view.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.5019607843, blue: 0.6588235294, alpha: 1)
        alert.view.layer.cornerRadius = 25
        alert.addAction(UIAlertAction(title: "Reset", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            UserDefaults.standard.removeObject(forKey: "helpViewSeen")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "My Quotes"
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.875526011, green: 0.8698369861, blue: 0.9262552857, alpha: 1)
        let attribute = [NSAttributedString.Key.foregroundColor: UIColor(named: "Color-0")!]
        navigationController?.navigationBar.largeTitleTextAttributes = attribute
        navigationController?.navigationBar.titleTextAttributes = attribute
        navigationController?.navigationBar.tintColor = UIColor(named: "Color-2")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(resetHelpViews))
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if quotes.count == 0 {
            tableView.separatorStyle = .none
            view.addSubview(noQuotesView)
            noQuotesView.center = view.center
        }
        else {
            tableView.separatorStyle = .none
            noQuotesView.removeFromSuperview()
        }
        return quotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        
        cell.content.text = quotes[indexPath.row].quote
        cell.author.text = quotes[indexPath.row].author
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view,actionPerformed: @escaping (Bool) -> Void) in
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
            
            let alert = UIAlertController(title: "Delete Quote", message: "Are you sure you want to delete this quote?", preferredStyle: .alert)
            alert.view.tintColor = #colorLiteral(red: 0.8509803922, green: 0.4784313725, blue: 0.7450980392, alpha: 1)
            alert.view.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.5019607843, blue: 0.6588235294, alpha: 1)
            alert.view.layer.cornerRadius = 25
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                actionPerformed(false)
            }))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                self.dataController.viewContext.delete(self.quotes[indexPath.row])
                self.quotes.remove(at: indexPath.row)
                try? self.dataController.viewContext.save()
                tableView.deleteRows(at: [indexPath], with: .fade)
                actionPerformed(true)
                generator.notificationOccurred(.success)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        delete.image = #imageLiteral(resourceName: "Delete")
        delete.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        let quoteToShare:String = "\"\(quotes[indexPath.row].quote!)\"" + "\nBy: " + "\(quotes[indexPath.row].author!)"
        let activityViewContrller = UIActivityViewController(activityItems: [quoteToShare], applicationActivities: nil)
        present(activityViewContrller, animated: true, completion: nil)
        activityViewContrller.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                self.quoteTableView.deselectRow(at: indexPath, animated: true)
                return
            }
            else if completed {
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                generator.notificationOccurred(.success)
            }
            self.dismiss(animated: true, completion: nil)
            self.quoteTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
}

extension MyQuotesTableViewController: PersistenceStackClient {
    func setStack(stack: DataController) {
        self.dataController = stack
    }
}

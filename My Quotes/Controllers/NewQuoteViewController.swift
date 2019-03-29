//
//  ViewController.swift
//  My Quotes
//
//  Created by FarouK on 03/01/2019.
//  Copyright © 2019 FarouK. All rights reserved.
//

import UIKit
import CoreData

class NewQuoteViewController: UIViewController {
    
    @IBOutlet weak var quoteLable: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var dataController: DataController!
    var quotes: [Quote]!
    var refreshButton: UIBarButtonItem {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(newQuoteButtonPressed))
        return refreshButton
    }
    var addButton: UIBarButtonItem {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(saveButtonDidPressed))
        return addButton
    }
    static var quoteContent: String!
    static var quoteAuthor: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        downloadQuote()
        makeFetchRequest()
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
    }
    
    func downloadQuote() {
        enableUI(false)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        getQuote { (sucess, errorMessege, data) in
            
            if sucess {
                DispatchQueue.main.async {
                    generator.notificationOccurred(.success)
                    self.quoteLable.text =  "\(data![0].quote!) \n\n By: \(data![0].author!)"
                    self.enableUI(true)
                    self.quoteLable.isHidden = false
                }
                NewQuoteViewController.quoteContent = data![0].quote!
                NewQuoteViewController.quoteAuthor = data![0].author!
            }
            else {
                self.showAlert(title: "Error", message: errorMessege!)
                
                DispatchQueue.main.async {
                    generator.notificationOccurred(.error)
                    self.quoteLable.isHidden = false
                }
                self.enableUI(true)
            }
        }
    }
    
    @objc func newQuoteButtonPressed(_ sender: Any) {

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        quoteLable.isHidden = true
        downloadQuote()
    }
    
    func saveQuoteToCoreData() {
        
        let quote = Quote(context: dataController.viewContext)
        quote.quote = NewQuoteViewController.quoteContent
        quote.author = NewQuoteViewController.quoteAuthor
        do {
            try dataController.viewContext.save()
            showAlert(title: "Success", message: "Your quote has been saved successfully")
        }
        catch {
            showAlert(title: "Error", message: "There was an error saving your quote, please try agian later!")
        }
    }
    
    @objc func saveButtonDidPressed(_ sender: Any) {
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        let generatorNotificatoin = UINotificationFeedbackGenerator()
        if quoteLable.text == "" {
            
            showAlert(title: "Error", message: "You can't add an empty quote, please try downlaoding one and try again.")
             generatorNotificatoin.notificationOccurred(.error)
        } else {
            for quote in quotes {
                if quote.quote as! String == NewQuoteViewController.quoteContent {
                    showAlertWithOK(title: "Quote Already Exist", message: "You have added this quote previously, do you want to add it again?")
                    return
                }
            }
            saveQuoteToCoreData()
            makeFetchRequest()
        }
}
    
    func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Qutoes Downloader"
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.875526011, green: 0.8698369861, blue: 0.9262552857, alpha: 1)
        let attribute = [NSAttributedString.Key.foregroundColor: UIColor(named: "Color-0")!]
        navigationController?.navigationBar.largeTitleTextAttributes = attribute
        navigationController?.navigationBar.titleTextAttributes = attribute
        navigationController?.navigationBar.tintColor = UIColor(named: "Color-2")
        navigationItem.rightBarButtonItems = [addButton, refreshButton]
    }
    
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.view.tintColor = #colorLiteral(red: 0.8509803922, green: 0.4784313725, blue: 0.7450980392, alpha: 1)
        alert.view.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.5019607843, blue: 0.6588235294, alpha: 1)
        alert.view.layer.cornerRadius = 25
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithOK(title: String, message: String) {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.view.tintColor = #colorLiteral(red: 0.8509803922, green: 0.4784313725, blue: 0.7450980392, alpha: 1)
        alert.view.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.5019607843, blue: 0.6588235294, alpha: 1)
        alert.view.layer.cornerRadius = 25
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            self.saveQuoteToCoreData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        // show the alert
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func enableUI(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.refreshButton.isEnabled = enabled
            self.addButton.isEnabled = enabled
            enabled ? self.activityIndicator.stopAnimating() : self.activityIndicator.startAnimating()
        }
    }
}

extension NewQuoteViewController: PersistenceStackClient {
    func setStack(stack: DataController) {
        self.dataController = stack
    }
}



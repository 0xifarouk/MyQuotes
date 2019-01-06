//
//  Quotes API.swift
//  My Quotes
//
//  Created by FarouK on 03/01/2019.
//  Copyright © 2019 FarouK. All rights reserved.
//

import Foundation

func getQuote(completion: @escaping (_ success: Bool, _ message: String?, _ data: [QuoteResponse]?) -> Void) {
    
    let urlString = "https://andruxnet-random-famous-quotes.p.rapidapi.com/?cat=famous"
    let url = URL(string: urlString)
    var request = URLRequest(url: url!)
    request.httpMethod = "GET"
    request.addValue("a4d2c077cdmsh4ead31987373a89p13c71bjsne9b40d60142f", forHTTPHeaderField: "X-RapidAPI-Key")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        guard (error == nil) else {
            print("There was an error with your request: \(error)")
            completion(false, "Please Check your internet connection and try again later!",nil)
            return
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            print("Your request returned a status code other than 2xx!")
            completion(false, "Please try again later!",nil)
            return
        }
        
        /* GUARD: Was there any data returned? */
        guard let data = data else {
            print("No data was returned by the request!")
             completion(false, "Please try again later!",nil)
            return
        }
        print(String(data: data, encoding: .utf8)!)
        
        do {
            let quote = try JSONDecoder().decode([QuoteResponse].self, from: data)
            print("Author: " + (quote[0].author ?? "No Author!"))
            print("Quote: " + (quote[0].quote ?? "No Quote!"))
            
            completion(true, nil, quote)
        }
        catch {
            debugPrint(error)
        }
    }
    task.resume()
}

import Foundation

//MARK: Private variables
private let topic = "banana" // This should not be hard coded if in use in a application

private var urlString: String {
    get {
        var mainString = "https://en.wikipedia.org/w/api.php?action=parse&section=0&prop=text&format=json&page="
        if !topic.contains(" ") {
            return mainString + topic.lowercased()
        } else {
            let topicArray = topic.split(separator: " ")
            topicArray.forEach({
                mainString.append(contentsOf: $0.lowercased())
            })
            
            return mainString
        }
        
    }
    
}

// In SwiftUI this would be an observable object or State variable
private var numberOfTopicAccurences = 0


//MARK: Private functions
private struct WikipediaObject: Decodable {
    var title: String?
    var pageid: Int?
    var text: [String: String]?
}

/// Parses data from string and forms it into a WikipediaObject. Will then do a compleation function after
///
/// - warning: Will give warnings if data can not be pares or if the url String provided does not work
/// - parameter urlString: requested string used for URL session
/// - parameter compleaton: Function run after data is collected. This is run on the main thread (UI thread)
private func parsData(from urlString: String, with compleaton: (WikipediaObject) -> Void) {
    if let url = URL(string: urlString) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            
            do {
                let article = try JSONDecoder().decode([String: WikipediaObject].self, from: data)
                
                // Should update an observable, but instead it is directly updating variables
                // and using functions directly in the code. Not optimal but the best for
                // the time given.
                DispatchQueue.main.async {
                    if let parsedData = article["parse"] {
                        informUser(with: parsedData)
                    } else {
                        print("Article does not contain key parse")
                    }
                }
                
            }catch let jsonError {
                print("Error accured: \(jsonError)")
            }
        }.resume()
    }
}

/// Loopes trough data to find the number of occurenses of any given word.
///
/// - warning: If data given does not contain a key with the name text
/// - parameter word: What word you are looking for
/// - parameter data: Require a data object of type WikipediaObject to look for given word
/// - returns Int:  returns the number of accurences of a given word
private func countOccurrencesOf(word: String, in data: WikipediaObject) -> Int {
    if let value = data.text?["*"] {
        return value.lowercased().components(separatedBy:word).count - 1
    }
    
    print("No text was found for Object")
    return 0
}

/// Updates global variable and prints to terminal a final sentence
///
/// - parameter data: Require a data object of type WikipediaObject
private func informUser(with data: WikipediaObject) {
    numberOfTopicAccurences = countOccurrencesOf(word: topic, in: data)
    print("In the Wikipedia response text for the topic \(topic.capitalizingFirstLetter), there were \(numberOfTopicAccurences) accurences of the word.")
}


//MARK: Running code - Would be in a View file
parsData(from: urlString, with: informUser)


//MARK: Extensions - Would be in a library file
extension String {
    var capitalizingFirstLetter: String {
        return prefix(1).capitalized + dropFirst()
    }
}

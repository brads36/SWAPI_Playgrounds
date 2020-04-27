import Foundation


// MARK: - BaseURL: https://swapi.dev/api/
// MARK: - Endpoints:  people/id/    films/id/


// MARK: - Source Of Truth

struct Person: Decodable {
  
    let name: String
//    let height: String
//    let mass: String
//    let hair_color: String
//    let skin_color: String
//    let eye_color: String
//    let birth_year: String
//    let gender: String
//    let homeworld: URL
    let films: [URL]
//    let species: [URL]
//    let vehicles: [URL]
//    let starships: [URL]
//    let created: String
//    let edited: String
//    let url: URL
}

struct Film: Decodable {
    
    let title: String
    let opening_crawl: String
    let release_date: String
    
}


// MARK: - Get Person
class SwapiService {
    
    static let baseURL = URL(string: "https://swapi.dev/api/")
    static let peopleEndpoint = "people"
    static let filmsEndpoint = "films"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // 1 - Prepare URL
        guard let baseURL = baseURL else { return completion(nil) }
        let peopleURL = baseURL.appendingPathComponent(peopleEndpoint)
        let finalURL = peopleURL.appendingPathComponent("\(id)")
        
        // 2 - Contact server
        URLSession.shared.dataTask(with: finalURL) { (data, _ , error) in
            
            // 3 - Handle errors
            if let error = error {
                print(error.localizedDescription)
                return(completion(nil))
            }
            
            // 4 - Check for data
            guard let data = data else { return completion(nil) }
            
            // 5 - Decode Person from JSON
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                return completion(person)
                
            } catch {
                print(error.localizedDescription)
                return completion(nil)
            }
        } .resume()
    }
    
    // MARK: - GET Film
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        // 1 - Contact Server (since we take in a URL for this function we can skip the prepare URL step)
        URLSession.shared.dataTask(with: url) { (data, _ , error) in
            
            // 2 - Handle Errors
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
            }
            
            // 3 - Check Data
            guard let data = data else { return completion(nil) }
            
            // 4 - Decode Film From jSON
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                return completion(film)
                
            } catch {
                print(error.localizedDescription)
                return completion(nil)
            }
            
        } .resume()
        
    }
}

// check if fetchPerson() works
SwapiService.fetchPerson(id: 10) { person in
    if let person = person {
        print(person)
        
        for url in person.films {
            fetchFilm(url: url)
        }
    }
}

//
func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print("\n")
            print(film)
        }
    }
}

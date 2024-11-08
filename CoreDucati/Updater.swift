import Foundation
import CoreData
import UIKit


func updateDataFromURL(viewContext: NSManagedObjectContext) async {
    // Replace with the actual URL of your JSON
    let jsonURL = "https://raw.githubusercontent.com/VikSn0w/Ducati-CoreDatabike/refs/heads/main/PreloadedData.json"

    fetchJSONData(url: jsonURL) { familyData in
        guard let familyData = familyData else { return }

        for family in familyData {
            saveFamilyToCoreData(family: family, context: viewContext)
        }
    }
}


private func downloadAndSaveImage(from url: URL, imageName: String) async throws -> String {
    print("Starting download for \(url)")
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    // Check for a valid response
    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
        throw NSError(domain: "InvalidResponse", code: -1, userInfo: nil)
    }

    // Get the file path to save the image
    let fileManager = FileManager.default
    guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        throw NSError(domain: "Error getting documents directory", code: 1, userInfo: nil)
    }

    let fileURL = documentsDirectory.appendingPathComponent("\(imageName).png")
    
    // Save the image data to the specified path
    try data.write(to: fileURL)
    
    // Return the local file path as a string
    print("Saved image to \(fileURL.path)")
    return fileURL.path
}

func fetchJSONData(url: String, completion: @escaping ([FamilyData]?) -> Void) {
    guard let url = URL(string: url) else {
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            do {
                let decoder = JSONDecoder()
                let familyData = try decoder.decode([FamilyData].self, from: data)
                completion(familyData)
            } catch {
                print("Failed to decode JSON: \(error)")
                completion(nil)
            }
        } else {
            print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
        }
    }.resume()
}

func downloadAndSaveImage(imageName: String, imageURL: String, completion: @escaping (URL?) -> Void) {
    guard let url = URL(string: imageURL) else {
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }

        let fileManager = FileManager.default
        if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsURL.appendingPathComponent(imageName)
            print(fileURL.path())
            
            do {
                try data.write(to: fileURL)
                completion(fileURL)
            } catch {
                print("Error saving image: \(error)")
                completion(nil)
            }
        }
    }.resume()
}

func updateCoreDataFromJSON(jsonURL: String, context: NSManagedObjectContext) {
    fetchJSONData(url: jsonURL) { familyData in
        guard let familyData = familyData else { return }

        for family in familyData {
            saveFamilyToCoreData(family: family, context: context)
        }
    }
}

func saveFamilyToCoreData(family: FamilyData, context: NSManagedObjectContext) {
    // Fetch existing family with the same name
    let fetchRequest: NSFetchRequest<Family> = Family.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "name == %@", family.name)
    
    do {
        let existingFamilies = try context.fetch(fetchRequest)
        
        // Check if the family already exists
        let familyEntity: Family
        if let existingFamily = existingFamilies.first {
            familyEntity = existingFamily
        } else {
            familyEntity = Family(context: context)
            familyEntity.name = family.name
            familyEntity.logo = family.logo + ".png"
        }

        // Download family logo
        downloadAndSaveImage(imageName: "\(family.logo).png", imageURL: family.logourl) { localURL in
            guard let localURL = localURL else { return }
            familyEntity.logo = family.logo + ".png" // Update with local path if needed
        }
        
        // Iterate over models and associate with family
        for modelData in family.models {
            let modelFetchRequest: NSFetchRequest<Model> = Model.fetchRequest()
            modelFetchRequest.predicate = NSPredicate(format: "name == %@ AND family == %@", modelData.name, familyEntity)

            let existingModels = try context.fetch(modelFetchRequest)
            let modelEntity: Model
            
            if let existingModel = existingModels.first {
                modelEntity = existingModel // Update the existing model if found
            } else {
                modelEntity = Model(context: context)
                modelEntity.name = modelData.name
                modelEntity.family = familyEntity // Attach family to model
            }

            // Update model properties
            modelEntity.introductionYear = Int16(modelData.introductionYear)
            modelEntity.deprecationYear = Int16(modelData.deprecationYear)
            modelEntity.logo = modelData.logo + ".png"

            // Download model logo if necessary
            downloadAndSaveImage(imageName: "\(modelData.logo).png", imageURL: modelData.logourl) { localURL in
                guard let localURL = localURL else { return }
                modelEntity.logo = modelData.logo + ".png"
            }
            
            for variantData in modelData.variants{
                let variantFetchRequest: NSFetchRequest<Variant> = Variant.fetchRequest()
                variantFetchRequest.predicate = NSPredicate(format: "deprecationYear == %@ AND model == %@", variantData.name, modelEntity)

                let existingVariants = try context.fetch(variantFetchRequest)
                let variantEntity: Variant
                
                if let existingVariant = existingVariants.first {
                    variantEntity = existingVariant // Update the existing model if found
                } else {
                    variantEntity = Variant(context: context)
                    variantEntity.name = variantData.name
                    variantEntity.model = modelEntity // Attach family to model
                }
                
                variantEntity.deprecationYear = Int16(variantData.deprecationYear)
                variantEntity.introductionYear = Int16(variantData.introductionYear)
                variantEntity.top_speed = (variantData.top_speed)
                variantEntity.power = (variantData.power)
                variantEntity.logo = (variantData.logo) + ".png"
                variantEntity.induction = (variantData.induction)
                variantEntity.fuel_capacity = (variantData.fuel_capacity)
                variantEntity.engine = (variantData.engine)
                variantEntity.dry_weight = (variantData.dry_weight)
                variantEntity.displacement = (variantData.displacement)
                variantEntity.cooling_system = (variantData.cooling_system)
                variantEntity.clutch = (variantData.clutch)
                
                
                downloadAndSaveImage(imageName: "\(variantData.logo).png", imageURL: variantData.logourl) { localURL in
                    guard let localURL = localURL else { return }
                    variantEntity.logo = variantData.logo + ".png"
                }
            }
        }
        
        // Save the context after updating family and models
        try context.save()
        
    } catch {
        print("Failed to fetch or save family and models: \(error)")
    }
}

    // Function to download JSON
func downloadJSON(from url: URL) async throws -> Data {
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
}

private func saveJSONToDocuments(data: Data) -> URL {
    let fileManager = FileManager.default
    let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = urls[0]
    let fileURL = documentsDirectory.appendingPathComponent("PreloadedData.json")

    // Overwrite the file if it already exists
    do {
        try data.write(to: fileURL, options: .atomic)
        print("JSON file replaced at: \(fileURL)")
    } catch {
        print("Failed to overwrite JSON file: \(error)")
    }
    
    return fileURL
}

func updateCoreData(from fileURL: URL, viewContext: NSManagedObjectContext) throws {
    let data = try Data(contentsOf: fileURL)
    let decodedFamilies = try JSONDecoder().decode([FamilyData].self, from: data)
    
    for familyData in decodedFamilies {
        let fetchRequest: NSFetchRequest<Family> = Family.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", familyData.name)

        let existingFamilies = try viewContext.fetch(fetchRequest)

        // Update existing or create a new Family
        let family: Family
        if let existingFamily = existingFamilies.first {
            family = existingFamily
        } else {
            family = Family(context: viewContext)
        }

        family.name = familyData.name
        family.logo = familyData.logo

        // Save the context
        try viewContext.save()
    }
}

func fileExists(atPath path: String) -> Bool {
    let fileManager = FileManager.default
    return fileManager.fileExists(atPath: path)
}

private func loadImage(named imageName: String) -> UIImage? {
    let fileManager = FileManager.default
    if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = documentsURL.appendingPathComponent(imageName)
        if fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            print("File does not exist at path: \(fileURL.path)")
        }
    }
    return nil
}

class ModelViewModel: ObservableObject {
    @Published var models: [Model] = []
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchModels()
    }
    
    private func fetchModels() {
        let fetchRequest: NSFetchRequest<Model> = Model.fetchRequest()
        
        do {
            // Fetch records and update the published variable
            models = try context.fetch(fetchRequest)
            if models.isEmpty {
                print("No records found in 'Model' entity.")
            }
        } catch {
            print("Failed to fetch models: \(error.localizedDescription)")
        }
    }
}

class ModelViewVariant: ObservableObject {
    @Published var variants: [Variant] = []
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchVariants()
    }
    
    private func fetchVariants() {
        let fetchRequest: NSFetchRequest<Variant> = Variant.fetchRequest()
        
        do {
            // Fetch records and update the published variable
            variants = try context.fetch(fetchRequest)
            if variants.isEmpty {
                print("No records found in 'Variant' entity.")
            }
        } catch {
            print("Failed to fetch variants: \(error.localizedDescription)")
        }
    }
}

func loadImage(from path: String) -> UIImage? {
    let fileManager = FileManager.default
    if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = documentsURL.appendingPathComponent(path)
        if fileManager.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            print("Image file not found at path: \(fileURL.path)")
        }
    }
    return nil
}

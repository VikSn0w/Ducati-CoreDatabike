import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CoreDucati")
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                // Preload Family data after the store is loaded
                self.preloadFamilyDataIfNeeded(context: self.container.viewContext)
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // Function to preload Family data
    private func preloadFamilyDataIfNeeded(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Family> = Family.fetchRequest()

        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                addPreloadedFamilies(context: context)
            }
        } catch {
            print("Error checking Family data: \(error)")
        }
    }

    // Function to read from JSON and save to Core Data
    private func addPreloadedFamilies(context: NSManagedObjectContext) {
        guard let url = Bundle.main.url(forResource: "PreloadedData", withExtension: "json") else {
            print("JSON file not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let familiesData = try JSONDecoder().decode([FamilyData].self, from: data)

            for family in familiesData {
                let newFamily = Family(context: context)
                newFamily.name = family.name
                newFamily.logo = family.logo // Ensure these image names correspond to actual assets
            }

            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

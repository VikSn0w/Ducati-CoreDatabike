import SwiftUI
import CoreData

struct FamilyView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(named: "BarColor")
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // FetchRequest for the Family entity
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Family.name, ascending: true)],
        animation: .default)
    private var families: FetchedResults<Family>
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(families, id: \.self) { family in
                        NavigationLink {
                            ModelListView(family: family) // Navigate to ModelListView for selected family
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 150, height: 150)
                                .overlay(
                                    VStack {
                                        if let logoName = family.logo,
                                           let image = loadImage(from: logoName) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 100, height: 100)
                                        } else {
                                            Text("Image not found")
                                                .foregroundColor(.red)
                                        }
                                        Text(family.name ?? "Unknown")
                                            .font(.body)
                                            .fontWeight(.heavy)
                                    }
                                    .foregroundColor(.white)
                                )
                        }
                    }
                }
                .padding()
            }
            .refreshable {
                await updateDataFromURL(viewContext: viewContext)
            }
            .background(Color("BgColor"))
        }
    }
}

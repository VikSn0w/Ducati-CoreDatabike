import SwiftUI
import CoreData

struct ModelListView: View {
    var family: Family

    @FetchRequest private var models: FetchedResults<Model>

    init(family: Family) {
        let appear = UINavigationBarAppearance()

        let atters: [NSAttributedString.Key: Any] = [.font : UIFont(name: "Univers-LightOblique", size: 19)!]
        
        appear.titleTextAttributes = atters
        UINavigationBar.appearance().standardAppearance = appear
        UINavigationBar.appearance().compactAppearance = appear
        UINavigationBar.appearance().scrollEdgeAppearance = appear

        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(named: "BarColor")
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    
        
        self.family = family
        _models = FetchRequest<Model>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Model.name, ascending: true)],
            predicate: NSPredicate(format: "family == %@", family)
        )
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(models, id: \.self) { model in
                        NavigationLink {
                            ModelDetailView(model: model, family: family)
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 150, height: 150)
                                .overlay(
                                    VStack {
                                        if let logoName = model.logo,
                                           let image = loadImage(from: logoName) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 100, height: 100)
                                        } else {
                                            Text("Image not found")
                                                .foregroundColor(.red)
                                        }
                                        Text(model.name ?? "Unknown")
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
            .background(Color("BgColor"))
        }.navigationBarTitle(Text((family.name ?? "UNNAMED") + " Family"))
            .navigationBarTitleDisplayMode(.inline)
    }
}


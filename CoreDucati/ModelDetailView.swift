import SwiftUI
import CoreData

struct ModelDetailView: View {
    var model: Model
    var family: Family
    
    @FetchRequest private var variants: FetchedResults<Variant>

    init(model: Model, family: Family) {
        // Customize TabBar appearance
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(named: "BarColor")
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance

        self.model = model
        self.family = family
        
        _variants = FetchRequest<Variant>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Variant.deprecationYear, ascending: true)],
            predicate: NSPredicate(format: "model == %@", model)
        )
        
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Model Image
                    if let logoName = model.logo,
                       let image = loadImage(from: logoName) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 240, height: 240)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color("AccentColor").opacity(0.5), lineWidth: 2))
                            .shadow(radius: 5)
                            .padding(.top, 20)
                    }

                    // Model Information
                    VStack(alignment: .leading, spacing: 8) {
                        HStack{
                            Text("DUCATI")
                                .font(Font.custom("UniversLT-ExtraBlackObl", size: 28, relativeTo: .title))
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text(model.name ?? "Unnamed Model")
                                .font(Font.custom("Univers-LightOblique", size: 24, relativeTo: .title))
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        
                        

                        Divider()
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Introduction Year:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(verbatim: "\(model.introductionYear)")
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()

                            VStack(alignment: .leading, spacing: 5) {
                                Text("Retire Year:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(verbatim: "\(model.deprecationYear)")
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(Color("AccentColor").opacity(0.9))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
                
                Text("Variants")
                    .bold()
                    .font(.largeTitle)
                
                ScrollView {
                    VStack(spacing: 20) {
                        
            
                        
                        ForEach(variants, id: \.self) { variant in
                            NavigationLink {
                                VariantDetailView(model: model, family: family, variant: variant)
                            } label : {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack{
                                        Text("DUCATI")
                                            .font(Font.custom("UniversLT-ExtraBlackObl", size: 28, relativeTo: .title))
                                            .fontWeight(.bold)
                                            .foregroundColor(.primary)
                                        
                                        Text(variant.name ?? "Unnamed Model")
                                            .font(Font.custom("Univers-LightOblique", size: 24, relativeTo: .title))
                                            .fontWeight(.bold)
                                            .foregroundColor(.primary)
                                    }
                                    
                                    Divider()
                                    
                                    HStack {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text("Introduction Year:")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            Text(verbatim: "\(variant.introductionYear)")
                                                .font(.body)
                                                .foregroundColor(.primary)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text("Retire Year:")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            Text(verbatim: "\(variant.deprecationYear)")
                                                .font(.body)
                                                .foregroundColor(.primary)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .padding()
                                .background(Color("BarColor").opacity(0.9))
                                .cornerRadius(12)
                                .shadow(radius: 5)
                                .padding(.horizontal)
                                
                                Spacer()
                            }
                        }
                    }
                }
                    .padding()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("BgColor"))
        }
    }
}

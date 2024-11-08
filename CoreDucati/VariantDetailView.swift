import SwiftUI
import CoreData

struct VariantDetailView: View {
    var model: Model
    var family: Family
    var variant: Variant
    

    init(model: Model, family: Family, variant: Variant) {
        // Customize TabBar appearance
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(named: "BarColor")
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance

        self.model = model
        self.family = family
        self.variant = variant

    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Model Image
                    if let logoName = variant.logo,
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
                                .font(Font.custom("UniversLT-ExtraBlackObl", size: 32, relativeTo: .title))
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text(variant.name ?? "Unnamed Model")
                                .font(Font.custom("Univers-LightOblique", size: 28, relativeTo: .title))
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
                    .background(Color("AccentColor").opacity(0.9))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Model Data")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Divider()
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Power:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(verbatim: "\(variant.power) kW")
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Displacement:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(verbatim: "\(variant.displacement)cc")
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(.horizontal)

                        
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Top Speed:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(verbatim: "\(variant.top_speed) Km/h")
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Dry Weight:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(verbatim: "\(variant.dry_weight) Kg")
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Engine:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(variant.engine ?? "Error")
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Cooling System:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(variant.cooling_system  ?? "Error")
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Clutch:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(variant.clutch ?? "Error")
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Induction:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(variant.induction  ?? "Error")
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
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("BgColor"))
        }
    }
}

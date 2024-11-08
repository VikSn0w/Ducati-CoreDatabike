import SwiftUI

struct MainView: View {
    
    var body: some View {
        TabView {
            FamilyView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        
    }
}

#Preview {
    MainView()
}

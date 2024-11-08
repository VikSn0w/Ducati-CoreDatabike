import SwiftUI
import CoreData

struct SettingsView: View {
    init(){
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(named: "BarColor")  // Set your desired background color here
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance // For tab bar when used with scrolling
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
            }
        }
    }
}

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    @State private var selectedTab = 0
    
    @Binding var rootScreen: RootView
    
    //let userName = "Golnaz"
   // let userFamily = "Cherazi"
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                NavigationLink(destination: CreateProjectView()) {
                    Text("Create New Project")
                }
                .tabItem {
                    Label("Create Project", systemImage: "plus.circle")
                }
                .tag(0)
                
                NavigationLink(destination: ProjectListView()) {
                    Text("View Your Projects")
                }
                .tabItem {
                    Label("View Projects", systemImage: "list.bullet.rectangle")
                }
                .tag(1)
                
                NavigationLink(destination: ProjectOffersView()) {
                    Text("View Project Offers")
                }
                .tabItem {
                    Label("View Offers", systemImage: "gift")
                }
                .tag(2)
                
                Text("Notifications")
                    .tabItem {
                        Label("Notifications", systemImage: "bell")
                    }
                    .tag(3)
            }
            //                .onAppear {
            //                    UITabBar.appearance().isHidden = true // Hide the system tab bar
        }
        .navigationBarTitle("Owner Dashboard", displayMode: .inline)
        .navigationBarItems(trailing: HStack {
            Button(action: {
                self.authHelper.signOut()
                rootScreen = .Login
            }) {
                //Text("Signout")
                //Image(systemName: "lock.circle.fill")
                Image(systemName: "lock.shield.fill")
            }
            
            NavigationLink(destination: ProfileView(rootScreen: $rootScreen).environmentObject(self.authHelper).environmentObject(self.dbHelper)) {
                Image(systemName: "person.circle.fill")
            }
            
            NavigationLink(destination: SettingsView(rootScreen: $rootScreen).environmentObject(self.authHelper).environmentObject(self.dbHelper)) {
                Image(systemName: "gearshape.fill")
            }
        })
    }
}
    


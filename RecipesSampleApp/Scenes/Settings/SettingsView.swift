//
//  SettingsView.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var coordinator: HomeCoordinator
    @AppStorage("user") var user: User?


    var body: some View {
        VStack(spacing: 8) {
            Text("Recipes Sample App")
                .bold()
            Text("Username: \(user?.name ?? "")")
            Button {
                logout()
            } label: {
                Text("Log out")
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/)
        .contentShape(Rectangle())
        .onTapGesture(perform: openWebsite)
        .navigationTitle("Settings")
    }

    private func openWebsite() {
        guard let url = URL(string: "https://istvan-kreisz.com/") else {
            return assertionFailure()
        }
        coordinator.open(url)
    }

    private func logout() {
        coordinator.signOut()
    }
}

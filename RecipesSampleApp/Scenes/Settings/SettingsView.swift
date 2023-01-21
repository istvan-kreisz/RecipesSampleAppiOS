//
//  SettingsView.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/19/23.
//

import SwiftUI

struct SettingsView: View {

    // MARK: Stored Properties

    @ObservedObject var coordinator: HomeCoordinator
    @EnvironmentObject var user: UserWrapper

    // MARK: Views

    var body: some View {
        VStack(spacing: 8) {
            Text("Recipes Sample App")
                .bold()
            Text("Username: \(user.user?.username ?? "")")
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

    // MARK: Methods

    private func openWebsite() {
        guard let url = URL(string: "https://quickbirdstudios.com/") else {
            return assertionFailure()
        }
        self.coordinator.open(url)
    }

    private func logout() {
        coordinator.signOut()
    }
}

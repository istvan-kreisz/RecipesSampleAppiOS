//
//  AddRecipeView.swift
//  RecipesSampleApp
//
//  Created by István Kreisz on 1/21/23.
//

import SwiftUI

struct AddRecipeView: ViewWithGlobalState {
    @ObservedObject var viewModel: AddRecipeViewModel
    @State var ingredient = ""
    @State var step = ""

    @State var showAddImageLinkAlert = false
    @State var showAddSourceLinkAlert = false
    @State var imageLink = ""
    @State var sourceLink = ""

    var body: some View {
        List {
            Section {
                TextField("Add title", text: $viewModel.recipe.title)
            } header: {
                Text("Title")
            } footer: {
                if viewModel.inputErrors.titleMissing {
                    Text("Please add a title")
                        .font(.caption)
                        .foregroundColor(.red)
                        .listRowBackground(Color.clear)
                }
            }

            Section(header: Text("Image")) {
                if let imageURL = viewModel.recipe.imageURL {
                    #warning("fix error state")
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxHeight: UIScreen.main.bounds.height / 3)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                    .listRowInsets(.init())
                } else {
                    Button {
                        imageLink = ""
                        showAddImageLinkAlert = true
                    } label: {
                        Label("Add image link", systemImage: "plus.circle.fill")
                    }
                }
            }

            Section(header: Text("Source")) {
                if let sourceURL = viewModel.recipe.source {
                    HStack {
                        Text(sourceURL.absoluteString)
                        Spacer()
                        Button("Delete", role: .destructive) {
                            viewModel.recipe.source = nil
                        }
                    }
                } else {
                    Button {
                        sourceLink = ""
                        showAddSourceLinkAlert = true
                    } label: {
                        Label("Add source link", systemImage: "plus.circle.fill")
                    }
                }
            }

            Section {
                ForEach(viewModel.recipe.ingredients, id: \.self) { ingredient in
                    Text(ingredient)
                }
                .onDelete { indexSet in
                    viewModel.delete(ingredientsAt: indexSet)
                }
                HStack(alignment: .center) {
                    TextField("New ingredient", text: $ingredient)
                    Button {
                        viewModel.add(ingredient: ingredient)
                        ingredient = ""
                    } label: {
                        Text("Add")
                    }
                    .buttonStyle(.borderless)
                }
            } header: {
                Text("Ingredients")
            } footer: {
                if viewModel.inputErrors.ingredientsMissing {
                    Text("Please add at least one ingredient")
                        .font(.caption)
                        .foregroundColor(.red)
                        .listRowBackground(Color.clear)
                }
            }

            Section {
                ForEach(viewModel.recipe.steps, id: \.self) { step in
                    Text(step)
                }
                .onDelete { indexSet in
                    viewModel.delete(stepsAt: indexSet)
                }
                HStack(alignment: .center) {
                    TextField("New step", text: $step)
                    Button {
                        viewModel.add(step: step)
                        step = ""
                    } label: {
                        Text("Add")
                    }
                    .buttonStyle(.borderless)
                }
            } header: {
                Text("Steps")
            } footer: {
                if viewModel.inputErrors.stepsMissing {
                    Text("Please add at least one step")
                        .font(.caption)
                        .foregroundColor(.red)
                        .listRowBackground(Color.clear)
                }
            }

            Button {
                viewModel.addRecipe()
            } label: {
                Text("Add Recipe")
            }
            .centeredHorizontally()
            .listRowBackground(Color.clear)
        }
        .navigationTitle(Text("Add Recipe"))
        .alert("Add an image link", isPresented: $showAddImageLinkAlert) {
            TextField("Add an image link", text: $imageLink)
            Button("Cancel", role: .cancel) {}
            Button {
                viewModel.recipe.imageURL = URL(string: imageLink)
                showAddImageLinkAlert = false
            } label: {
                Text("Add link")
            }
        }
        .alert("Add source URL", isPresented: $showAddSourceLinkAlert) {
            TextField("Add source link", text: $sourceLink)
            Button("Cancel", role: .cancel) {}
            Button {
                viewModel.recipe.source = URL(string: sourceLink)
                showAddSourceLinkAlert = false
            } label: {
                Text("Add link")
            }
        }
    }
}

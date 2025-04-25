//
//  ContentView.swift
//  bendi.film
//
//  Created by rishabh b on 4/16/25.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}


import SwiftUI

// MARK: - Models
struct Photo: Identifiable {
    var id = UUID()
    var aperture: String
    var shutterSpeed: String
    var notes: String = ""
    var date: Date = Date()
}

struct Roll: Identifiable {
    var id = UUID()
    var name: String
    var photos: [Photo] = []
    var createdAt: Date = Date()
}

// MARK: - View Models
class RollViewModel: ObservableObject {
    @Published var rolls: [Roll] = []
    
    func addRoll(name: String) {
        let newRoll = Roll(name: name)
        rolls.append(newRoll)
    }
    
    func deleteRoll(at indexSet: IndexSet) {
        rolls.remove(atOffsets: indexSet)
    }
    
    func addPhoto(to roll: Roll, aperture: String, shutterSpeed: String) {
        if let index = rolls.firstIndex(where: { $0.id == roll.id }) {
            let newPhoto = Photo(aperture: aperture, shutterSpeed: shutterSpeed)
            rolls[index].photos.append(newPhoto)
        }
    }
    
    func deletePhoto(from roll: Roll, at indexSet: IndexSet) {
        if let index = rolls.firstIndex(where: { $0.id == roll.id }) {
            rolls[index].photos.remove(atOffsets: indexSet)
        }
    }
}

// MARK: - Views
struct AddRollView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: RollViewModel
    @State private var rollName: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Roll Details")) {
                    TextField("Roll Name", text: $rollName)
                }
            }
            .navigationTitle("New Roll")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if !rollName.isEmpty {
                            viewModel.addRoll(name: rollName)
                            dismiss()
                        }
                    }
                    .disabled(rollName.isEmpty)
                }
            }
        }
    }
}

struct AddPhotoView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: RollViewModel
    var roll: Roll
    
    @State private var aperture: String = ""
    @State private var shutterSpeed: String = ""
    @State private var notes: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Exposure Settings")) {
                    TextField("Aperture (f/stop)", text: $aperture)
                        .keyboardType(.decimalPad)
                    
                    TextField("Shutter Speed (1/x)", text: $shutterSpeed)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("New Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if !aperture.isEmpty && !shutterSpeed.isEmpty {
                            viewModel.addPhoto(to: roll, aperture: aperture, shutterSpeed: shutterSpeed)
                            dismiss()
                        }
                    }
                    .disabled(aperture.isEmpty || shutterSpeed.isEmpty)
                }
            }
        }
    }
}

struct PhotoListView: View {
    @ObservedObject var viewModel: RollViewModel
    var roll: Roll
    @State private var showingAddPhoto = false
    
    var body: some View {
        List {
            ForEach(roll.photos) { photo in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Aperture: f/\(photo.aperture)")
                            .font(.headline)
                        Spacer()
                        Text("Shutter: 1/\(photo.shutterSpeed)s")
                            .font(.headline)
                    }
                    
                    if !photo.notes.isEmpty {
                        Text(photo.notes)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(photo.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
            .onDelete { indexSet in
                viewModel.deletePhoto(from: roll, at: indexSet)
            }
        }
        .navigationTitle(roll.name)
        .toolbar {
            Button {
                showingAddPhoto = true
            } label: {
                Label("Add Photo", systemImage: "plus")
            }
        }
        .sheet(isPresented: $showingAddPhoto) {
            AddPhotoView(viewModel: viewModel, roll: roll)
        }
    }
}

struct RollListView: View {
    @StateObject var viewModel = RollViewModel()
    @State private var showingAddRoll = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.rolls.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text("No Rolls")
                            .font(.title2)
                        Text("Tap the + button to add a new roll")
                            .foregroundColor(.secondary)
                        Button("Add Your First Roll") {
                            showingAddRoll = true
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(viewModel.rolls) { roll in
                            NavigationLink(destination: PhotoListView(viewModel: viewModel, roll: roll)) {
                                VStack(alignment: .leading) {
                                    Text(roll.name)
                                        .font(.headline)
                                    HStack {
                                        Text("\(roll.photos.count) photos")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text(roll.createdAt, style: .date)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteRoll(at: indexSet)
                        }
                    }
                }
            }
            .navigationTitle("Camera Rolls")
            .toolbar {
                Button {
                    showingAddRoll = true
                } label: {
                    Label("Add Roll", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingAddRoll) {
                AddRollView(viewModel: viewModel)
            }
        }
    }
}

//// MARK: - App Entry Point
//@main
//struct CameraRollApp: App {
//    var body: some Scene {
//        WindowGroup {
//            RollListView()
//        }
//    }
//}

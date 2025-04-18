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
struct Frame: Identifiable {
    var id = UUID()
    var aperture: String
    var shutterSpeed: String
    var notes: String = ""
    var date: Date = Date()
}

struct Reel: Identifiable {
    var id = UUID()
    var name: String
    var frames: [Frame] = []
    var createdAt: Date = Date()
}

// MARK: - View Models
class ReelViewModel: ObservableObject {
    @Published var reels: [Reel] = []
    
    func addReel(name: String) {
        let newReel = Reel(name: name)
        reels.append(newReel)
    }
    
    func deleteReel(at indexSet: IndexSet) {
        reels.remove(atOffsets: indexSet)
    }
    
    func addFrame(to reel: Reel, aperture: String, shutterSpeed: String) {
        if let index = reels.firstIndex(where: { $0.id == reel.id }) {
            let newFrame = Frame(aperture: aperture, shutterSpeed: shutterSpeed)
            reels[index].frames.append(newFrame)
        }
    }
    
    func deleteFrame(from reel: Reel, at indexSet: IndexSet) {
        if let index = reels.firstIndex(where: { $0.id == reel.id }) {
            reels[index].frames.remove(atOffsets: indexSet)
        }
    }
}

// MARK: - Views
struct AddReelView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ReelViewModel
    @State private var reelName: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Reel Details")) {
                    TextField("Reel Name", text: $reelName)
                }
            }
            .navigationTitle("New Reel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if !reelName.isEmpty {
                            viewModel.addReel(name: reelName)
                            dismiss()
                        }
                    }
                    .disabled(reelName.isEmpty)
                }
            }
        }
    }
}

struct AddFrameView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ReelViewModel
    var reel: Reel
    
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
            .navigationTitle("New Frame")
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
                            viewModel.addFrame(to: reel, aperture: aperture, shutterSpeed: shutterSpeed)
                            dismiss()
                        }
                    }
                    .disabled(aperture.isEmpty || shutterSpeed.isEmpty)
                }
            }
        }
    }
}

struct FrameListView: View {
    @ObservedObject var viewModel: ReelViewModel
    var reel: Reel
    @State private var showingAddFrame = false
    
    var body: some View {
        List {
            ForEach(reel.frames) { frame in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Aperture: f/\(frame.aperture)")
                            .font(.headline)
                        Spacer()
                        Text("Shutter: 1/\(frame.shutterSpeed)s")
                            .font(.headline)
                    }
                    
                    if !frame.notes.isEmpty {
                        Text(frame.notes)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(frame.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
            .onDelete { indexSet in
                viewModel.deleteFrame(from: reel, at: indexSet)
            }
        }
        .navigationTitle(reel.name)
        .toolbar {
            Button {
                showingAddFrame = true
            } label: {
                Label("Add Frame", systemImage: "plus")
            }
        }
        .sheet(isPresented: $showingAddFrame) {
            AddFrameView(viewModel: viewModel, reel: reel)
        }
    }
}

struct ReelListView: View {
    @StateObject var viewModel = ReelViewModel()
    @State private var showingAddReel = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.reels.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text("No Reels")
                            .font(.title2)
                        Text("Tap the + button to add a new reel")
                            .foregroundColor(.secondary)
                        Button("Add Your First Reel") {
                            showingAddReel = true
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(viewModel.reels) { reel in
                            NavigationLink(destination: FrameListView(viewModel: viewModel, reel: reel)) {
                                VStack(alignment: .leading) {
                                    Text(reel.name)
                                        .font(.headline)
                                    HStack {
                                        Text("\(reel.frames.count) frames")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text(reel.createdAt, style: .date)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteReel(at: indexSet)
                        }
                    }
                }
            }
            .navigationTitle("Camera Reels")
            .toolbar {
                Button {
                    showingAddReel = true
                } label: {
                    Label("Add Reel", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingAddReel) {
                AddReelView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - App Entry Point
//@main
//struct CameraReelApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ReelListView()
//        }
//    }
//}

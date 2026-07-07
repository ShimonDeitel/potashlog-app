import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager

    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false
    @State private var editingItem: Application?

    @State private var draftBedname: String = ""
    @State private var draftMaterial: String = ""
    @State private var draftAmountcups: String = ""
    @State private var draftNotes: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                if store.items.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(store.items) { item in
                            ApplicationRow(item: item)
                                .listRowBackground(Theme.card)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    editingItem = item
                                    loadDraft(from: item)
                                    showingAdd = true
                                }
                        }
                        .onDelete { offsets in
                            store.delete(at: offsets)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Potashlog")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            editingItem = nil
                            clearDraft()
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                addEditSheet
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .tint(Theme.accent)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 44))
                .foregroundStyle(Theme.textSecondary)
            Text("No applications yet")
                .font(Theme.headlineFont)
                .foregroundStyle(Theme.textPrimary)
            Text("Tap + to add your first entry.")
                .font(Theme.bodyFont)
                .foregroundStyle(Theme.textSecondary)
        }
    }

    private var addEditSheet: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Bed name", text: $draftBedname)
                        .accessibilityIdentifier("field_bedName")
                        .keyboardType(default)
                    TextField("Material (ash/lime)", text: $draftMaterial)
                        .accessibilityIdentifier("field_material")
                        .keyboardType(default)
                    TextField("Amount (cups)", text: $draftAmountcups)
                        .accessibilityIdentifier("field_amountCups")
                        .keyboardType(decimalPad)
                    TextField("Notes", text: $draftNotes)
                        .accessibilityIdentifier("field_notes")
                        .keyboardType(default)
                }
            }
            .navigationTitle(editingItem == nil ? "Add Application" : "Edit Application")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showingAdd = false }
                        .accessibilityIdentifier("cancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .accessibilityIdentifier("saveButton")
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    private func loadDraft(from item: Application) {
        draftBedname = item.bedName
        draftMaterial = item.material
        draftAmountcups = String(item.amountCups)
        draftNotes = item.notes
    }

    private func clearDraft() {
        draftBedname = ""
        draftMaterial = ""
        draftAmountcups = ""
        draftNotes = ""
    }

    private func save() {
        if let editing = editingItem {
            var updated = editing
            updated.bedName = draftBedname
            updated.material = draftMaterial
            updated.amountCups = Double(draftAmountcups) ?? 0
            updated.notes = draftNotes
            store.update(updated)
        } else {
            let item = Application(bedName: draftBedname, material: draftMaterial, amountCups: Double(draftAmountcups) ?? 0, notes: draftNotes)
            store.add(item)
        }
        showingAdd = false
    }
}

struct ApplicationRow: View {
    let item: Application

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.bedName.isEmpty ? "Untitled" : item.bedName)
                .font(Theme.headlineFont)
                .foregroundStyle(Theme.textPrimary)
            Text(item.createdAt, style: .date)
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.vertical, 4)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

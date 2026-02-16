import SwiftUI

struct AddAscentView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AddAscentViewModel
    @State private var showAddDay = false
    @State private var editingDay: AcclimatizationDay?
    @FocusState private var isFocused: Bool
    
    init(storageManager: StorageManager, ascent: Ascent? = nil) {
        self._viewModel = State(initialValue: AddAscentViewModel(storageManager: storageManager, ascent: ascent))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: Constants.Spacing.xl) {
                        VStack(alignment: .leading, spacing: Constants.Spacing.m) {
                            Text("Name *")
                                .font(Constants.Fonts.subtitle)
                                .foregroundStyle(.hGray)
                            
                            TextField("Elbrus — South slope", text: $viewModel.name)
                                .font(Constants.Fonts.text)
                                .foregroundStyle(.white)
                                .padding(.horizontal, Constants.Spacing.l)
                                .frame(height: Constants.Components.textField)
                                .background(.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                                .focused($isFocused)
                        }
                        
                        VStack(alignment: .leading, spacing: Constants.Spacing.m) {
                            Text("Route")
                                .font(Constants.Fonts.subtitle)
                                .foregroundStyle(.hGray)
                            
                            TextField("Shelter 11 → Pastukhova → Summit", text: $viewModel.route)
                                .font(Constants.Fonts.text)
                                .foregroundStyle(.white)
                                .padding(.horizontal, Constants.Spacing.l)
                                .frame(height: Constants.Components.textField)
                                .background(.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                                .focused($isFocused)
                        }
                        
                        VStack(alignment: .leading, spacing: Constants.Spacing.m) {
                            Text("Maximum height (m) *")
                                .font(Constants.Fonts.subtitle)
                                .foregroundStyle(.hGray)
                            
                            TextField("5642", text: $viewModel.maximumHeight)
                                .keyboardType(.numberPad)
                                .font(Constants.Fonts.text)
                                .foregroundStyle(.white)
                                .padding(.horizontal, Constants.Spacing.l)
                                .frame(height: Constants.Components.textField)
                                .background(.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                                .focused($isFocused)
                        }
                        
                        VStack(alignment: .leading, spacing: Constants.Spacing.m) {
                            Text("Start date *")
                                .font(Constants.Fonts.subtitle)
                                .foregroundStyle(.hGray)
                            
                            DatePicker("", selection: Binding(
                                get: { viewModel.startDate ?? Date() },
                                set: { viewModel.startDate = $0 }
                            ), displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .colorScheme(.dark)
                            .padding(.horizontal, Constants.Spacing.l)
                            .frame(height: Constants.Components.textField)
//                            .background(.cardBackground)
//                            .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                        }
                        
                        VStack(alignment: .leading, spacing: Constants.Spacing.m) {
                            Text("End date")
                                .font(Constants.Fonts.subtitle)
                                .foregroundStyle(.hGray)
                            
                            DatePicker("", selection: Binding(
                                get: { viewModel.endDate ?? viewModel.startDate ?? Date() },
                                set: { viewModel.endDate = $0 }
                            ), in: (viewModel.startDate ?? Date())..., displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .colorScheme(.dark)
                            .padding(.horizontal, Constants.Spacing.l)
                            .frame(height: Constants.Components.textField)
//                            .background(.cardBackground)
//                            .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                            
                            if let error = viewModel.getDateRangeError() {
                                Text(error)
                                    .font(Constants.Fonts.caption)
                                    .foregroundStyle(.hRed)
                                    .padding(.horizontal, Constants.Spacing.l)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: Constants.Spacing.m) {
                            Text("Weather")
                                .font(Constants.Fonts.subtitle)
                                .foregroundStyle(.hGray)
                            
                            TextField("☀️", text: $viewModel.weather)
                                .font(Constants.Fonts.text)
                                .foregroundStyle(.white)
                                .padding(.horizontal, Constants.Spacing.l)
                                .frame(height: Constants.Components.textField)
                                .background(.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                                .focused($isFocused)
                        }
                        
                        VStack(alignment: .leading, spacing: Constants.Spacing.m) {
                            Text("Temperature (°C)")
                                .font(Constants.Fonts.subtitle)
                                .foregroundStyle(.hGray)
                            
                            TextField("+5", text: $viewModel.temperature)
                                .keyboardType(.numbersAndPunctuation)
                                .font(Constants.Fonts.text)
                                .foregroundStyle(.white)
                                .padding(.horizontal, Constants.Spacing.l)
                                .frame(height: Constants.Components.textField)
                                .background(.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                                .focused($isFocused)
                        }
                        
                        VStack(alignment: .leading, spacing: Constants.Spacing.m) {
                            Text("Wind (m/s)")
                                .font(Constants.Fonts.subtitle)
                                .foregroundStyle(.hGray)
                            
                            TextField("15", text: $viewModel.windSpeed)
                                .keyboardType(.numberPad)
                                .font(Constants.Fonts.text)
                                .foregroundStyle(.white)
                                .padding(.horizontal, Constants.Spacing.l)
                                .frame(height: Constants.Components.textField)
                                .background(.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                                .focused($isFocused)
                        }
                        
                        VStack(alignment: .leading, spacing: Constants.Spacing.m) {
                            Text("Notes")
                                .font(Constants.Fonts.subtitle)
                                .foregroundStyle(.hGray)
                            
                            PlaceholderTextEditor(
                                text: $viewModel.notes,
                                placeholder: "Crevasse at 30 m — difficult passage",
                                height: Constants.Components.textEditor,
                                isFocused: $isFocused
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: Constants.Spacing.m) {
                            Text("Mood")
                                .font(Constants.Fonts.subtitle)
                                .foregroundStyle(.hGray)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Constants.Spacing.m) {
                                ForEach(Mood.allCases, id: \.self) { mood in
                                    MoodButton(
                                        mood: mood,
                                        isSelected: viewModel.selectedMood == mood
                                    ) {
                                        viewModel.selectedMood = mood
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: Constants.Spacing.l) {
                            HStack {
                                Text("Acclimatization")
                                    .font(Constants.Fonts.title2)
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                Button {
                                    editingDay = nil
                                    showAddDay = true
                                } label: {
                                    HStack(spacing: Constants.Spacing.s) {
                                        Image(systemName: Constants.Icons.plus)
                                        Text("Add day")
                                    }
                                    .font(Constants.Fonts.text2)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, Constants.Spacing.l)
                                    .padding(.vertical, Constants.Spacing.m)
                                    .background(.hBlue)
                                    .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                                }
                            }
                            
                            if viewModel.acclimatizationDays.isEmpty {
                                Text("No acclimatization records")
                                    .font(Constants.Fonts.subtitle)
                                    .foregroundStyle(.hGray)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, Constants.Spacing.xl)
                            } else {
                                VStack(spacing: Constants.Spacing.m) {
                                    ForEach(viewModel.acclimatizationDays) { day in
                                        Button {
                                            editingDay = day
                                            showAddDay = true
                                        } label: {
                                            HStack {
                                                VStack(alignment: .leading, spacing: Constants.Spacing.s) {
                                                    Text("Day \(day.dayNumber)")
                                                        .font(Constants.Fonts.text2)
                                                        .foregroundStyle(.white)
                                                    
                                                    Text("\(day.height) m")
                                                        .font(Constants.Fonts.subtitle)
                                                        .foregroundStyle(.hGray)
                                                    
                                                    if !day.symptoms.isEmpty {
                                                        Text("Symptoms: \(day.symptoms.count)")
                                                            .font(Constants.Fonts.caption)
                                                            .foregroundStyle(.hRed)
                                                    }
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding(Constants.Spacing.l)
                                            .background(.cardBackground)
                                            .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                                        }
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                viewModel.deleteDay(day)
                                            } label: {
                                                Label("Delete", systemImage: Constants.Icons.trash)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(Constants.Spacing.l)
                    .padding(.bottom, 80)
                }
//                .background(
//                    Color.clear
//                        .contentShape(Rectangle())
//                        .onTapGesture {
//                            isFocused = false
//                        }
//                )
                
                VStack {
                    Spacer()
                    
                    HStack(spacing: Constants.Spacing.l) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                                .font(Constants.Fonts.text2)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: Constants.Components.textField)
                                .background(.cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                        }
                        
                        Button {
                            if viewModel.validate() {
                                viewModel.saveAscent()
                                dismiss()
                            }
                        } label: {
                            Text("Save")
                                .font(Constants.Fonts.text2)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: Constants.Components.textField)
                                .background(viewModel.validate() ? .hBlue : .hGray)
                                .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                        }
                        .disabled(!viewModel.validate())
                    }
                    .padding([.horizontal, .bottom], Constants.Spacing.l)
                    .padding(.top, Constants.Spacing.s)
                    .background(Color.background)
                }
                .ignoresSafeArea(.keyboard)
            }
            .onTapGesture {
                isFocused = false
            }
            .navigationTitle(viewModel.isEditMode ? "Edit ascent" : "Add ascent")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showAddDay) {
                AddDayView(
                    dayNumber: editingDay?.dayNumber ?? (viewModel.acclimatizationDays.count + 1),
                    existingDay: editingDay
                ) { day in
                    if editingDay != nil {
                        viewModel.updateDay(day)
                    } else {
                        viewModel.addDay(day)
                    }
                }
                .presentationDragIndicator(.visible)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: Constants.Icons.xmark)
                            .foregroundStyle(.hGray)
                    }
                }
            }
        }
    }
}

#Preview("New Ascent") {
    AddAscentView(storageManager: StorageManager())
}

#Preview("Edit Ascent") {
    AddAscentView(
        storageManager: StorageManager(),
        ascent: Ascent(
            name: "Elbrus",
            route: "Shelter 11 → Pastukhova → Summit",
            maximumHeight: 5642,
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
            weather: "☀️",
            temperature: -5,
            windSpeed: 15,
            notes: "Amazing summit day",
            mood: .euphoria,
            acclimatizationDays: [
                AcclimatizationDay(dayNumber: 1, height: 2500),
                AcclimatizationDay(dayNumber: 2, height: 3200)
            ]
        )
    )
}

import SwiftUI

struct AddDayView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AddDayViewModel
    let onSave: (AcclimatizationDay) -> Void
    @FocusState private var isFocused: Bool
    
    init(dayNumber: Int, existingDay: AcclimatizationDay? = nil, onSave: @escaping (AcclimatizationDay) -> Void) {
        self._viewModel = State(initialValue: AddDayViewModel(dayNumber: dayNumber, existingDay: existingDay))
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: Constants.Spacing.xl) {
                        VStack(alignment: .leading, spacing: Constants.Spacing.m) {
                            Text("Height (m) *")
                                .font(Constants.Fonts.subtitle)
                                .foregroundStyle(.hGray)
                            
                            TextField("2500", text: $viewModel.height)
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
                            Text("Symptoms")
                                .font(Constants.Fonts.subtitle)
                                .foregroundStyle(.hGray)
                            
                            VStack(spacing: Constants.Spacing.s) {
                                ForEach(Symptom.allCases, id: \.self) { symptom in
                                    SymptomRow(
                                        symptom: symptom,
                                        isSelected: viewModel.selectedSymptoms.contains(symptom)
                                    ) {
                                        viewModel.toggleSymptom(symptom)
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: Constants.Spacing.m) {
                            Text("Notes")
                                .font(Constants.Fonts.subtitle)
                                .foregroundStyle(.hGray)
                            
                            PlaceholderTextEditor(
                                text: $viewModel.notes,
                                placeholder: "Normal sleep, reduced appetite",
                                height: Constants.Components.textEditor,
                                isFocused: $isFocused
                            )
                        }
                    }
                    .padding(Constants.Spacing.l)
                    .padding(.bottom, 80)
                }
                
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
                            if let day = viewModel.createDay() {
                                onSave(day)
                                dismiss()
                            }
                        } label: {
                            Text("Save")
                                .font(Constants.Fonts.text2)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: Constants.Components.textField)
                                .background(.hBlue)
                                .clipShape(RoundedRectangle(cornerRadius: Constants.CornerRadius.main))
                        }
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
            .navigationTitle("Day \(viewModel.dayNumber)")
            .navigationBarTitleDisplayMode(.inline)
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

#Preview("New Day") {
    AddDayView(dayNumber: 1) { _ in }
}

#Preview("Edit Day") {
    AddDayView(
        dayNumber: 2,
        existingDay: AcclimatizationDay(
            dayNumber: 2,
            height: 3200,
            symptoms: [.headache, .insomnia],
            notes: "Normal sleep, reduced appetite"
        )
    ) { _ in }
}

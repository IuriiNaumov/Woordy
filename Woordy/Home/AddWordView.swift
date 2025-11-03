import SwiftUI

struct AddWordView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var word: String = ""
    @State private var translation: String = ""
    @State private var description: String = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case word, translation, description
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            Text("Add new word")
                .font(.custom("Poppins-Bold", size: 38))
                .foregroundColor(.black)
                .padding(.top, 40)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Word or phrase")
                    .font(.custom("Poppins-Regular", size: 18))
                    .foregroundColor(.gray)
                
                ZStack(alignment: .trailing) {
                    TextField("Some text here", text: $word)
                        .focused($focusedField, equals: .word)
                        .onChange(of: word) { newValue in
                            if newValue.count > 25 {
                                word = String(newValue.prefix(25))
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 19)
                        .background(Color(.systemGray6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(focusedField == .word ? Color.black : Color.clear, lineWidth: 1.5)
                        )
                        .cornerRadius(10)
                    
                    Text("\(word.count)/25")
                        .font(.custom("Poppins-Regular", size: 13))
                        .foregroundColor(.gray)
                        .padding(.trailing, 14)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Translation")
                    .font(.custom("Poppins-Regular", size: 18))
                    .foregroundColor(.gray)
                
                TextField("", text: $translation)
                    .focused($focusedField, equals: .translation)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 19)
                    .background(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(focusedField == .translation ? Color.black : Color.clear, lineWidth: 1.5)
                    )
                    .cornerRadius(10)
                
                Text("Not sure? The app translates for you.")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Description")
                    .font(.custom("Poppins-Regular", size: 18))
                    .foregroundColor(.gray)
                
                TextEditor(text: $description)
                    .focused($focusedField, equals: .description)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(focusedField == .description ? Color.black : Color.clear, lineWidth: 1.5)
                    )
                    .frame(height: 120)
            }
            
            Spacer()
            
            Button(action: {
                dismiss()
            }) {
                Text("Add")
                    .font(.custom("Poppins-Medium", size: 20))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.black)
                    .cornerRadius(50)
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 24)
        .background(Color.white)
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    AddWordView()
}

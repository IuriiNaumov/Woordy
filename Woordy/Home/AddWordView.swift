import SwiftUI

struct AddWordView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var word: String = ""
    @State private var translation: String = ""
    @State private var description: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Add new word")
                .font(.custom("Poppins-Bold", size: 32))
                .foregroundColor(.black)
                .padding(.top, 40)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Word or phrase")
                    .font(.custom("Poppins-Regular", size: 15))
                    .foregroundColor(.gray)
                
                HStack {
                    TextField("Some text here", text: $word)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    
                    Text("\(word.count)/25")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.gray)
                        .padding(.trailing, 4)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Translation")
                    .font(.custom("Poppins-Regular", size: 15))
                    .foregroundColor(.gray)
                
                TextField("", text: $translation)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                Text("Not sure? The app translates for you.")
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Description")
                    .font(.custom("Poppins-Regular", size: 15))
                    .foregroundColor(.gray)
                
                TextEditor(text: $description)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(14)
                    .frame(height: 120)
            }
            
            Spacer()
            
            Button(action: {
                // логика добавления слова
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
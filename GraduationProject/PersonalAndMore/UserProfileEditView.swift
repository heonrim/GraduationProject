//
//  UserProfileEditView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/23.
//

import SwiftUI

struct UserProfileEditView: View {
    @State private var editedUsername: String = ""
    @State private var editedEmail: String = ""
    @State private var editedUserDescription: String = ""
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: UIImage?

    let morandiBlue = Color(hex: "#6689A1")
    let morandiPink = Color(hex: "#DEA9A7")
    let morandiBackground = Color(hex: "#EDEAE5")

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                }, label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(morandiBlue)
                        .padding()
                })

                Spacer()

                Text("編輯個人資訊")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(morandiBlue)

                Spacer()

                Button(action: {
                }, label: {
                    Text("保存")
                        .foregroundColor(morandiBlue)
                        .padding()
                })
            }
            .padding(.top, 20)

            Spacer()

            ZStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 130)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(morandiBlue, lineWidth: 2))
                } else {
                    Image("profile_placeholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 130)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(morandiBlue, lineWidth: 2))
                }

                Button(action: {
                    isImagePickerPresented = true
                }, label: {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 24))
                        .padding(12)
                        .background(morandiPink)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                })
                .offset(x: 50, y: 50)
            }
            .padding(.bottom, 20)

            VStack(alignment: .leading, spacing: 20) {
                Text("用戶名")
                    .font(.caption)
                    .foregroundColor(morandiBlue)
                TextField("輸入用戶名", text: $editedUsername)
                    .textFieldStyle(CustomTextFieldStyle())

                Text("電子郵件")
                    .font(.caption)
                    .foregroundColor(morandiBlue)
                TextField("輸入電子郵件", text: $editedEmail)
                    .textFieldStyle(CustomTextFieldStyle())

                Text("描述")
                    .font(.caption)
                    .foregroundColor(morandiBlue)
                TextField("輸入描述", text: $editedUserDescription)
                    .textFieldStyle(CustomTextFieldStyle())
            }
            .padding([.leading, .trailing], 30)

            Spacer()
        }
        .background(morandiBackground)
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isImagePickerPresented, content: {
            ImagePicker(image: $selectedImage)
        })
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5))
    }
}

struct UserProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileEditView()
    }
}

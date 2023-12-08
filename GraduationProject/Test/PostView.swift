//
//  PostView.swift
//  GraduationProject
//
//  Created by heonrim on 2/20/23.
//

import SwiftUI

struct Post: Identifiable {
    var id: UUID { uuid }
    var uuid = UUID()
    var author: String
    var content: String
    var imageName: String
    var timestamp: Date
    var likes: Int
    var comments: [Comment]
}



struct Comment {
    var author: String
    var content: String
    var timestamp: Date
}


struct AddCommentView: View {
    @Binding var post: Post
    @State var content: String = ""
    @State var author: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("作者", text: $author)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("回覆", text: $content)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                let newComment = Comment(author: author, content: content, timestamp: Date())
                post.comments.append(newComment)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("提交")
            }
            .padding()
            
            List(post.comments, id: \.timestamp) { comment in
                VStack(alignment: .leading) {
                    Text(comment.content)
                        .font(.body)
                    HStack {
                        Text(comment.author)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                        Text(comment.timestamp, style: .date)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(comment.timestamp, style: .time)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
    }
}



struct EditPostView: View {
    @Binding var originalPost: Post
    @State var editedPost: Post
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("內容", text: $editedPost.content)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                originalPost = editedPost
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("儲存")
            }
            .padding()
        }
        .padding()
        .onAppear {
            editedPost = originalPost
        }
    }
}


struct PostView: View {
    @State var post: Post
    @State var showCommentSheet = false
    @State var showEditSheet = false
    @State var editContent: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
                Text(post.author)
                    .font(.headline)
                Spacer()
                Text(post.timestamp, style: .time)
                    .font(.subheadline)
            }
            Text(post.content)
                .font(.body)
            Image(post.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxHeight: 100)
                .clipped()
            
            HStack {
                Button(action: {
                    post.likes += 1
                }) {
                    Image(systemName: "heart")
                        .foregroundColor(Color.red)
                    Text("\(post.likes)")
                }
                
                Spacer()
                
                Button(action: {
                    showCommentSheet = true
                }) {
                    Image(systemName: "message")
                    Text("\(post.comments.count)")
                }
                
                Button(action: {
                    editContent = post.content
                    showEditSheet = true
                }) {
                    Image(systemName: "pencil")
                }
                
            }
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .sheet(isPresented: $showCommentSheet) {
            AddCommentView(post: $post)
        }
        .sheet(isPresented: $showEditSheet) {
            EditPostView(originalPost: $post, editedPost: post)
        }
    }
}


struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        let post = Post(author: "heon", content: "你好!", imageName: "example-image", timestamp: Date(), likes: 0, comments: [])
        PostView(post: post)
    }
}

//
//  GroupDetailView.swift
//  GraduationProject
//
//  Created by heonrim on 2/20/23.
//

import SwiftUI

struct GroupDetailView: View {
    @State var posts: [Post] = [
        Post(author: "heon", content: "Hello, world!", imageName: "example-image", timestamp: Date(), likes: 0, comments: [])
    ]
    @State var showAddPostSheet = false
    let members = ["Member 1", "Member 2", "Member 3"]

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .clipShape(Circle())
                        
                        Text("本月之星")
                            .font(.headline)
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    List {
                        ForEach(posts) { post in
                            PostView(post: post)
                                .id(post.id)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }

                Button(action: {
                    showAddPostSheet = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                .padding()
                .sheet(isPresented: $showAddPostSheet) {
                    AddPostView() { post in
                        posts.append(post)
                        showAddPostSheet = false
                    }
                }
            }
            .navigationBarTitle("社群")
            .navigationBarItems(leading: Button(action: {
            }) {
                Image(systemName: "line.horizontal.3")
            }, trailing:
            NavigationLink(destination: MemberListView(members: members)) {
                Text("成員")
            })
        }
    }
}


struct MemberListView: View {
    let members: [String]

    var body: some View {
        List {
            ForEach(members, id: \.self) { member in
                NavigationLink(destination: MemberInfoView(memberInfo: MemberInfo(name: member, profileImageName: "", bio: "", taskProgress: 0))) {
                    Text(member)
                }
            }
        }
        .navigationBarTitle("成員列表")
    }
}


struct AddPostView: View {
    @State var post = Post(author: "", content: "", imageName: "", timestamp: Date(), likes: 0, comments: [])
    var onAdd: (Post) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            TextField("作者", text: $post.author)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("內容", text: $post.content)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                post.timestamp = Date()
                post.likes = 0
                post.comments = []
                onAdd(post)
            }) {
                Text("提交")
            }
            .padding()
        }
        .padding()
    }
}



struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView()
    }
}

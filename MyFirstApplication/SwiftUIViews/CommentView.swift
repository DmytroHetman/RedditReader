//
//  CommentView.swift
//  RedditComments
//
//  Created by Dmytro Hetman on 17.08.2022.
//

import SwiftUI

struct CommentView: View {
    
    var comment: Comment
 
    var body: some View {
        
            VStack(alignment: .leading, spacing: 10) {
                Group {
                    HStack {
                        Text(comment.username)
                        +
                        Text(" · ")
                        +
                        Text(comment.created)
                    }
                    .font(.subheadline)
                    
                    Text(comment.body)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.footnote)
                        .padding(.horizontal, 15)
                        .multilineTextAlignment(.leading)
                        
                    
                    Button() { } label: {
                        Label(String(comment.rating), systemImage: comment.rating > -1 ? "arrow.up" : "arrow.down")
                            .font(.system(size: 15, weight: .bold, design: .default))
                            .foregroundColor(comment.rating > -1 ? .green : .red)
                            .padding(.bottom, 5)
                    }
                }
                
                
                
                
                ForEach(comment.replies ?? [], id: \.self) { reply in
                    HStack(alignment: .top, spacing: 10) {
                        Rectangle().frame(width: 1).foregroundColor(Color(uiColor: .systemGray2))
                            
                        NavigationLink {
                            CommentDetails(comment: reply)
                        } label: {
                            CommentView(comment: reply)
                                .foregroundColor(.primary)
                        }
                        .navigationBarTitleDisplayMode(.large)
                        .buttonStyle(FlatLinkStyle())
                        
                    }
                    .frame(maxHeight: .infinity)
                }
            }
        
    }
}

//struct CommentView_Previews: PreviewProvider {
//    
//    
//    static var previews: some View {
//        VStack {
//            
//            CommentView(comment: CommentRepository(subreddit: "ios", limit: 5, depth: 1, postID: "t3_wli6ud").comments[0])
//                .padding()
//            Spacer()
//        }
//        
//    }
//}

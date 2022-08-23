//
//  CommentList.swift
//  RedditComments
//
//  Created by Dmytro Hetman on 17.08.2022.
//

import SwiftUI

struct CommentList: View {
    
    @EnvironmentObject var commentRepository: CommentRepository
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    Divider()
                    ForEach(commentRepository.comments, id: \.self) { comment in
                        NavigationLink {
                            CommentDetails(comment: comment)
                        } label: {
                            CommentView(comment: comment)
                                .foregroundColor(.primary)
                                .padding([.top, .leading], 10)
                                .onAppear {
                                    Task {
                                        await commentRepository.loadMoreComments(linkID: commentRepository.postID)
                                    }
                                }
                        }
                        .buttonStyle(FlatLinkStyle())
                        .padding(.leading, 10)
                        
                        Rectangle().frame(height: 3).foregroundColor(Color(uiColor: .systemGray2))
                    }
                    .navigationTitle("Comments")
                }
                
                
                
            }
        }
        
    }
}

struct FlatLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

//struct CommentList_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentList()
//            .environmentObject(CommentRepository(subreddit: "ios", limit: 5, depth: 1, postID: "t3_wli6ud"))
//    }
//}

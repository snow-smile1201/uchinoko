class Admin::PostCommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_id = @post.id
    comment.save
  end

  #コメント禁止用
  def update
    @post = Post.find(params[:post_id])
    comment = PostComment.find(params[:id])
    comment.update(is_banned: true)
    redirect_to edit_admin_post_path(@post)
  end

  def destroy
    @post = Post.find(params[:post_id])
    comment = PostComment.find(params[:id])
    comment.destroy
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment, :is_banned)
  end
end

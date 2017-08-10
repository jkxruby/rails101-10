class PostsController < ApplicationController
before_action :authenticate_user!

def index
  @group = Group.find(params[:group_id])
  @post.group = @group
end

def new
  @group = Group.find(params[:group_id])
  @post = Post.new
end

def create
  @group = Group.find(params[:group_id])
  @post = Post.new(post_params)
  @post.group = @group
  if @post.save
    redirect_to group_path(group)
  else
    render :new
  end
end

private
def post_params
  params.require(:post).permit(:group_id, :content)
end 


end
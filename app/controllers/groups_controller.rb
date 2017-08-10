class GroupsController < ApplicationController
before_action :authenticate_user!, only: [:new, :create, :destroy, :update, :edit, :join, :quit]

def index
  @groups = Group.all
end

def show
  @group = Group.find(params[:id])
  @posts = @group.posts.paginate(:page => params[:page], :per_page => 5)
end

def new
  @group = Group.new
end

def create
  @group = Group.new(group_params)
  @group.user = current_user
  if @group.save
    current_user.join!(@group)
    redirect_to groups_path
  else
    render :new
  end
end

def edit
  @group = Group.find(params[:id])
end

def update
  @group = Group.find(params[:id])
  if @group.update(group_params)
    redirect_to groups_path, alert: "update success"
  else
    render :edit
  end
end

def destroy
  @group = Group.find(params[:id])
  @group.destroy
  redirect_to groups_path, alert: "delete success"
end

def join
  @group = Group.find(params[:id])
  if !current_user.is_member_of?(@group)
    current_user.join!(@group)
    flash[:notice] = "加入本讨论版成功"
  else
    flash[:warning] = "你已经是本版成员了"
  end
  redirect_to group_path(@group)
end

def quit
  @group = Group.find(params[:id])
  if current_user.is_member_of?(@group)
    current_user.quit!(@group)
    flash[:alert] = "已经退出本版"
  else
    flash[:warning] = "你不是本版成员，怎么退出"
  end
  redirect_to group_path(@group)
end


private
def group_params
  params.require(:group).permit(:title, :description)
end


end

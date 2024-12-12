class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).order(created_at: :desc).paginate(page: params[:page])
  
    render json: {
      pagination: @posts,
      posts: ActiveModelSerializers::SerializableResource.new(@posts),
      current_posts_count: @posts.size
    }, status: :ok
  end
  
  def show
    render json: @post, status: :ok
  end

  def create
    @post = Post.new(post_params)
    @post.user = @current_user
      if @post.save
        render json: @post, status: :created
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
      end
  end

  def update
    if @post.update(post_params)
      render json: @post, status: :ok
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
  end

  private

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Post not found" }, status: :not_found
  end

  def post_params
    params.require(:post).permit(:title, :body, :category_id)
  end
end
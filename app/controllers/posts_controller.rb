class PostsController < ApplicationController
  include Pagy::Backend

  before_action :set_post, only: [:show, :update, :destroy]

  def index
    @q = Post.ransack(params[:q])
    @pagy, @posts = pagy(@q.result(distinct: true).order(created_at: :desc))

    render json: {
      pagination: pagy_metadata(@pagy),
      posts: ActiveModel::Serializer::CollectionSerializer.new(@posts, each_serializer: PostSerializer),
      current_posts_count: @posts.size
    }, status: :ok
    debugger
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
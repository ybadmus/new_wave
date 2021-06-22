class API::V1::PostsController < ApplicationController 
  before_action :set_post, only: %i[show update destroy]
  before_action :authenticate_token!

  def index
    render json: Post.all
  end

  def show
    render json: @post, include: ['comments']
  end

  def create 
    post = current_user.posts.build(post_params)
    if post.save
      render json: post, status: 201
    else
      render json: { errors: post.errors }, status: 422
    end
  end

  def update
    if @post.update(post_params)
      render json: @post, status: 200
    else
      render json: { errors: @post.errors }, status: 422
    end
  end

  def destroy
    @post.destroy
    head 204
  end

  private 
    
    def set_post
      @post = Post.find(params[:id])
    rescue
      render json: {errors: ["Post could not found"]}, status: 404 
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end

end
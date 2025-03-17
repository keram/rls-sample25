class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  class SampleService
    def initialize
      Rails.logger.info "-t- before initializing AR var"
      @posts = Post.all
      Rails.logger.info "-t- after initializing AR var"
    end

    def call
      Rails.logger.info "-t- before #call return"

      @posts
    end
  end

  # GET /posts or /posts.json
  def index
    # @posts = Post.all
    # https://anilkumarmaurya.medium.com/when-not-to-use-memoization-in-ruby-on-rails-9d54bce0ae74
    # https://railsatscale.com/2023-10-24-memoization-pattern-and-object-shapes/
    Rails.logger.info "-t- before SampleService instantiation"
    service = SampleService.new
    Rails.logger.info "-t- after SampleService instantiation"
    Rails.logger.info "-t- service.call AR call #{service.call.count}"
    Rails.logger.info "-t- after service.call"

    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.expect(post: [ :name, :title, :content ])
    end
end

class MoviesController < ApplicationController

  helper_method :which_head

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  	restore_session
  	@all_ratings = Movie.all_ratings
  	@ratings_to_show = params[:ratings]==nil ? [] : params[:ratings]
  	save_session 
    @movies = Movie.with_ratings(params[:ratings]).order(order_status)
  end

  def which_head(id)
  	if params[:order] == id
  		"hilite bg-warning"
  	else
  		""
  	end
  end

  def restore_session
  	if !params.has_key?(:home) && ((session.has_key?(:order) && !params.has_key?(:order)) || (session.has_key?(:ratings) && !params.has_key?(:ratings)))
  		redirect_to movies_path(:ratings => session[:ratings], :order => session[:order], :home => '1')
  	end
  end

  def save_session
  	session[:order] = params[:order]
  	temp = nil
  	if params[:ratings] != nil
  		temp = {}
  		params[:ratings].each do |key, value|
  			temp.merge!(key => value)
  		end
  	end
  	session[:ratings] = temp
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def order_status
  	sortable = ['title', 'release_date']
  	sortable.include?(params[:order])? params[:order] : nil
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end

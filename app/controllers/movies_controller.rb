class MoviesController < ApplicationController
  def index
    @user = User.find(params[:id])

    if params[:top_rated]
      results = MoviesFacade.search_results(params[:query])
      @top_20 = results.first(20)

      if results.empty?
        flash[:notice] = 'No results found. Please try another title.'
        redirect_to discover_path
      end
    else
      results = MoviesFacade.top_movies
      @top_20 = results.first(20)
    end
  end

  def show
    @user = User.find(params[:id])
    @movie_id = params[:movie_id]

    @movie = MoviesFacade.movie_details(@movie_id) 
    
    @credits = MoviesFacade.movie_credits(@movie_id)

    @reviews = MoviesFacade.movie_reviews(@movie_id)
  end
end

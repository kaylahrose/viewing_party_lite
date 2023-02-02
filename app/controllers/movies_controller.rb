class MoviesController < ApplicationController
  def index
    @user = User.find(params[:id])

    if params[:top_rated]
      results = MoviesFacade.search_results(params[:query])
      @top_20 = results.first(20)

      if results.empty?
        flash[:notice] = 'No results found. Please try another title.'
        redirect_to discover_user_path(@user)
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

    conn = Faraday.new(url: 'https://api.themoviedb.org') do |f|
      f.params['api_key'] = ENV['movie_api_key']
    end
    response = conn.get("/3/movie/#{@movie_id}/credits?") 
    
    @credits = JSON.parse(response.body, symbolize_names: true)

    
    # @details = 
    # TODO: movie hash keep_if to remove extra data
  end
end

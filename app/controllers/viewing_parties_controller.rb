class ViewingPartiesController < ApplicationController
  before_action :validate_user

  def new
    @user = User.find(params[:id])
    
    conn = Faraday.new(url: 'https://api.themoviedb.org') do |f|
      f.params['api_key'] = ENV['movie_api_key']
    end
    response = conn.get("/3/movie/#{params[:movie_id]}?")

    @movie = JSON.parse(response.body, symbolize_names: true)
    @users = User.all
  end

  def create
    host = User.find(params[:id])
    if params[:duration] >= params[:movie_runtime]
      viewing_party = host.viewing_parties.create(duration: params[:duration].to_i, event_date: params[:day],
                                                  start_time: params[:time], host_id: host.id, movie_id: params[:movie_id])
      User.all.each do |user|
        next if user == host

        UserViewingParty.create(user_id: user.id, viewing_party_id: viewing_party.id) if params[user.name] == '1'
      end
      redirect_to dashboard_path
    else
      flash[:notice] = 'Party time must be longer than the movie runtime.'
      redirect_to("/users/#{host.id}/movies/#{params[:movie_id]}/viewing-party/new")
    end
  end

  private 

  def validate_user 
    if session[:user_id].nil?
      user = User.find(params[:id])
      flash[:error] = "Must be logged in or registered to create a viewing party"
      redirect_to("/users/#{user.id}/movies/#{params[:movie_id]}")
    end
  end
end

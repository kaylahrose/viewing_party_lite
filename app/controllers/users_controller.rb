class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])

    @viewing_parties = @user.viewing_parties.map do |party|
      movie = MoviesFacade.movie_details(party.movie_id)
      {
        party_id: party.id,
        movie_id: party.movie_id,
        event_date: party.event_date,
        start_time: party.start_time,
        host: User.find(party.host_id),
        title: movie.title,
        image: "https://image.tmdb.org/t/p/w500/#{movie.backdrop_path}",
        attendees: ViewingParty.find(party.id).users
      }
    end
  end

  def discover
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    user = User.create(user_params)
    if user.save
      redirect_to user_path(user)
    else
      flash[:notice] = user.errors.full_messages.to_sentence
      redirect_to register_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

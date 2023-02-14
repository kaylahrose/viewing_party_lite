class SessionsController < ApplicationController
  
  def new
  end

  def create 
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}"
      redirect_to dashboard_path
    else 
      flash[:error] = "Incorrect credentials. Please login again."
      render :new
    end 
  end

  def destroy 
    session.destroy
    redirect_to root_path
  end
end

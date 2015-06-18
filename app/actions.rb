# Homepage (Root path)
get '/' do
  @sales = Sale.all
  @items = Item.all
  @sales.each do |sale|
    @sale = sale
  end
  @items_per_sale = Item.where(sale_id: @sale.id)
  erb :index
end

get '/sign_up' do
  erb :'/sign_up'
end

post '/sign_up' do
  user = User.find_by(username: params[:username])
  # Check that the password entered in the form matches what we have in the database
  if !user.nil?
    @message = "That user already exists. Try a different name."
    erb :'/sign_up'
  else
    user = User.create(username: params[:username], password: params[:password])
    # logged in successfully.
    session[:user_id] = user.id
    redirect "/"
  end
end

get '/login' do
  erb :login
end

post '/login' do
  user = User.find_by(username: params[:username])
  # Check that the password entered in the form matches what we have in the database
  if !user.nil?
    if user.password == params[:password]
      # logged in successfully.
      session[:user_id] = user.id
      redirect "/"
    else
      # login failed.
      @message = "Username or PASSWORD is incorrect."
      erb :login # returns a giant HTML string
    end
  else
    # User not found in the database
    @message = "USERNAME or password is incorrect."
    erb :login
  end
end

get '/logout' do
  session[:user_id] = nil
  redirect "/"
end


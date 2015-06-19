# Homepage (Root path)

helpers do

  def to_12_hour_time(date_time)
    date_time.strftime("%l:%M").strip
  end

  def current_user
    if session[:user_id]
      if @current_user.nil?
        @current_user = User.find(session[:user_id])
      end
    end
    @current_user

  end
end

get '/' do
  @sales = Sale.all
  @items = Item.all 
  erb :index
end



get '/sales/new' do

  erb :'/sales/new'
end

post '/sales' do

  @sale = Sale.new(

    address: params[:address],
    start_time: params[:start_time].to_time,
    end_time: params[:end_time].to_time,
    description: params[:description],
    user_id: current_user.id,
    image_path: params[:image_path]
    )

  binding.pry

  if @sale.save!

    item_list = [params[:item_name1], params[:item_name2], params[:item_name3], params[:item_name4], params[:item_name5]]
    item_list.each do |itemname|
      if itemname != ""
        item = Item.new(
          item_name: itemname,
          sale_id: @sale.id
          )
        item.save
      end
    end
    redirect '/'
  else 
    erb :'/sales/new'
  end
end



get '/sales/edit' do

  @logged_in = session[:user_id]
  if @logged_in
    @sale = Sale.where(user_id: @logged_in).first
  end
  erb :'/sales/edit'
end

post '/sales/:id/items' do
  Item.create(item_name: 'item name here', sale_id: params[:id])
  redirect "/sales/edit"
end


post '/sales/edit' do
  @logged_in = session[:user_id]
  @sale = Sale.where(user_id: @logged_in).first


  if @logged_in
    params[:items].each do |params_item|
      item = Item.find(params_item[:id])
      item.item_name = params_item[:item_name]
      item.save
    end         
    redirect '/'
  else 
    erb :'/sales/edit'  
  end
end




get '/users/new' do
  erb :'/users/new'
end

post '/users' do
  user = User.find_by(username: params[:username])
  # Check that the password entered in the form matches what we have in the database
  if !user.nil?
    @message = "That user already exists. Try a different name."
    erb :'/sign_up'
  else
    password_salt = BCrypt::Engine.generate_salt
    password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)

    user = User.create(username: params[:username], password_salt: password_salt, password: password_hash)

    # logged in successfully.
    session[:user_id] = user.id
    redirect "/"
  end
end

get '/login' do
  redirect '/session/new'
end

get '/session/new' do
  erb :'/session/new'
end

post '/session' do
  user = User.find_by(username: params[:username])
  # Check that the password entered in the form matches what we have in the database
  if !user.nil?
    if user.password == BCrypt::Engine.hash_secret(params[:password], user.password_salt)
      # logged in successfully.
      session[:user_id] = user.id
      redirect "/"
    else
      # login failed.
      @message = "Username or PASSWORD is incorrect."
      erb :'/session/new' # returns a giant HTML string
    end
  else
    # User not found in the database
    @message = "USERNAME or password is incorrect."
    erb :'/session/new'
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect "/"
end

get '/sales/:id' do
  @sale = Sale.find params[:id]
  erb :'sales/show'
end


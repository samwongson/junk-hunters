# Homepage (Root path)

helpers do

  def to_12_hour_time(date_time)
    date_time.in_time_zone('US/Pacific').strftime("%l:%M %P").strip
  end

  def get_current_sales
    Sale.where("start_time < ?", Time.now).where("end_time > ?", Time.now)
  end

  def get_sales_by_time
    @sales = get_current_sales.order(:end_time)
  end

  def get_sales_by_distance
    # GET USER LOCATION.
    @sales = get_current_sales.near(session[:location], 10)
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
  if session[:location] 
    # @sales = get_sales_by_time
    # show all sales.
    @sales = get_sales_by_distance 
    @items = Item.all 
    erb :index
  else
    # request location
    erb :'/landing'
  end
end

post '/session_location' do
  session[:location] = params[:location]
  if !get_sales_by_distance.empty?
    puts session[:location]
    redirect '/'
  else
    session[:location] = nil
    @message = "We can't find any sales near #{params[:location]}. Try somewhere else?"
    erb :'/landing'
  end
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
  binding.pry
  Item.create(item_name: 'Your item', sale_id: params[:id])

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
    erb :'/session/new'
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
  session[:location] = nil
  session[:user_id] = nil
  redirect "/"
end

get '/sales/:id' do
  @sale = Sale.find(params[:id])
  erb :'sales/show'
end

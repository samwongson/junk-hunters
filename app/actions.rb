# Homepage (Root path)
get '/' do
  @sales = Sale.all
  @items = Item.all
  # @sales.each do |sale|
  #   @sale = sale
  #   @items_per_sale = Item.where(sale_id: @sale.id)
  # end  
  erb :index
end


get '/sales/new' do
  erb :'/sales/new'
end

post '/sales' do
  # binding.pry
  @sale = Sale.new(

    address: params[:address],
    start_time: params[:start_time],
    end_time: params[:end_time],
    description: params[:description],
    # user_id: @current_user.id
    
    image_path: params[:image_path]
    )


  if @sale.save
    # binding.pry
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
    erb :'/new'
  end
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


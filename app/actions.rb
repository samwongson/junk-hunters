# Homepage (Root path)
get '/' do
  erb :index
end

get '/new' do
  erb :new
end

post '/new' do
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
    redirect '/'
  else 
    erb :'/new'
  end
end
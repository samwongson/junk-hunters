# Homepage (Root path)
get '/' do
  @sales = Sale.all
  @items = Item.all
  erb :index
end

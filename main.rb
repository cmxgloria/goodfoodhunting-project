     
require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'
require 'bcrypt' #restart server when you install new gem
require_relative 'models/dish.rb'
enable :sessions #sinatra feature-abstraction -it like the global variable that you can write to, means empty hash we are going to write in
# you will get a hash named session

# method ending with ? convention-return boolean
def logged_in?
  if session[:user_id]
    return true
    else
    return false
  end
end

def current_user
  # sql injection to protect
  # conn.exec_params("select * from users where id = $1", "drop table table")
  # concept of pg, avoid user input some sql method to drop table or update invaliadte
  run_sql("select * from users where id = #{session[:user_id]};")[0]
  # [{'id=>1,'email'=>hldhl@hotmail.com,'password'=>'gkhgkh'}]
end

def run_sql(sql, args = [])
  conn = PG.connect(dbname: 'goodfoodhunting')
  # results = conn.exec(sql)
  results = conn.exec_params(sql, args)
  conn.close
  return results 
end


# read
get '/' do
# # connect to the database
# conn = PG.connect(dbname: 'goodfoodhunting')
# # ask for dishes in SQL
# sql = 'select * from dishes;'
# # select * from dishes;
# # dishes as an array of hashes
# @results = conn.exec(sql)
# # close the connection
# conn.close
@results = run_sql("select * from dishes order by name asc;")
# or @results = run_sql("select * from dishes order by name limit3;")
erb :index
end

# read

# route -more specific path pattern
# read
get '/dishes/new' do
erb :new_dish
end 
# run_sql(sql) or @dish = run_sql(sql)[0] to replace all 

get "/dishes/:id" do
  # params--query string,form input, named parameter(all user input)
  # "dish details"
  # client send us the id of the dish they want
  # params[:id]
  # conn = PG.connect(dbname: 'goodfoodhunting')
  # sql = "SELECT * FROM dishes WHERE id = #{params[:id]};"
  sql = "SELECT * FROM dishes WHERE id = $1;"
  # results = conn.exec(sql) 
  # conn.close
  # @dish =results[0]
  # @dish = run_sql(sql).first
  @dish = run_sql(sql,[params[:id]]).first
  erb :details
end

# read
post '/dishes' do
  redirect '/login' unless logged_in?
  # conn = PG.connect(dbname: 'goodfoodhunting')
  sql = "insert into dishes (name, image_url,user_id) values ('#{params[:name]}', '#{params[:image_url]}', #{current_user[:id]});"
  # conn.exec(sql)
  # conn.close
  run_sql(sql)
  redirect '/'
end

delete '/dishes/:id' do
  # conn = PG.connect(dbname: 'goodfoodhunting')
  sql = "delete from dishes where id = #{params[:id]};"
  # conn.exec(sql)
  # conn.close
  run_sql(sql)
  redirect '/'
end

get '/dishes/:id/edit' do
  # conn = PG.connect(dbname: 'goodfoodhunting')
  sql = "select * from dishes where id = #{params[:id]};"
  # results = conn.exec(sql)  # [{'id'=>1,'name'=>'rib'}] only one big hash
  # @dish = results[0]
  @dish = run_sql(sql)[0]
  erb :edit_dish
end

# update
patch '/dishes/:id' do
  # conn = PG.connect(dbname: 'goodfoodhunting')
  sql = "update * from dishes set name = '#{params[:name]}', image_url = '#{params[:image_url]}' where id = #{params [:id]};"
  # raise sql this stop and show the return
  # conn.exec(sql)
  # conn.close
  run_sql(sql)
# redirect is just making request on behalf of you users , its a get request
  redirect "/dishes/#{ params[:id]}"
end

get '/login' do
  erb :login
end

post '/login' do
  # select database
  # check the records exists from the email the user sent in
  sql = "select * from users where email = '#{params[:email]}';"
  results = run_sql(sql)
  # new method to convert string to object
  # check record exists for email "results.count == 1" 1 mean exist
    # check password digest match
  if results.count == 1 && BCrypt::Password.new(results[0]['password_digest']) == params[:password]
    # write down who you are - create a session for you
    session[:user_id] = results[0]['id']
  # raise 'yay'
  redirect '/' #up to you
  else
  # raise "email and password incorrect"
  erb :login
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect '/login'
end

get '/my_dishes' do
  redirect '/login' unless logged_in?
  @dishes = run_sql("select * from dishes where user_id = #{current_user['id']};")
  # raise @dishes.to_a.inspect
  # this one show the details turn object into the string format
  erb :my_dishes
end
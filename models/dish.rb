# convention is helpful

def run_sql(sql, args = [])
  conn = PG.connect(dbname: 'goodfoodhunting')
  results = conn.exec_params(sql, args)
  conn.close
  return results 
end
def create_dish(name, image_url,user_id)
    # sql = "insert into dishes (name, image_url,user_id)"
    # sql += "values ('#{params[:name]}', '#{params[:image_url]}', #{current_user[:user_id]});"

    # another way if got more lines, can seperate like this
    sql = <<~ SQL 
    insert into dishes (name, image_url,user_id)
    values ($1, $2, $3);
    # $1,2,3 is kinds of variables
    SQL
    run_sql(sql,[name, image_url, user_id])
end
# use this way to create dish in terminal

def all_dishes()
  run_sql("select * from dishes;")
end

def find_fish_by_id()
end

def delete_dish()
end




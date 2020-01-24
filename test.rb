require 'pg'
require 'bcrypt'
require 'pry'

conn = PG.connect(dbname: 'goodfoodhunting')
email = 'dt@ga.co'
password = 'pudding'
digest_password = BCrypt::Password.create(password)
sql = "INSERT INTO users(email, password_digest) VALUES ('#{email}','#{digest_password.to_s}');"
conn.exec(sql)
conn.close

# dont run this one twice, otherwise, it generates another password, then when login, email can not match 2 passwords,
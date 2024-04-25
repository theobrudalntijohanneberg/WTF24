require 'sqlite3'
require 'bcrypt'
def db
  if @db == nil
    @db = SQLite3::Database.new('./src/db/db.sqlite')
    @db.results_as_hash = true
  end
  return @db
end

def drop_tables
  db.execute('DROP TABLE IF EXISTS customer_data')
  db.execute('DROP TABLE IF EXISTS varor')
  db.execute('DROP TABLE IF EXISTS cart')
  db.execute('DROP TABLE IF EXISTS "order"')
  db.execute('DROP TABLE IF EXISTS order_item')
end

def create_tables
  db.execute('CREATE TABLE IF NOT EXISTS customer_data (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  username TEXT NOT NULL,
                  email TEXT NOT NULL,
                  hashed_password TEXT NOT NULL,
                  address TEXT 
              )')
  db.execute('CREATE TABLE IF NOT EXISTS varor (
                  name TEXT NOT NULL UNIQUE,
                  id INTEGER PRIMARY KEY AUTOINCREMENT, 
                  description TEXT NOT NULL, 
                  price INTEGER NOT NULL 
              )')
  db.execute('CREATE TABLE IF NOT EXISTS cart ( 
                  id INTEGER PRIMARY KEY AUTOINCREMENT, 
                  quantity INTEGER 
              )')
  db.execute('CREATE TABLE IF NOT EXISTS "order" ( 
                  id INTEGER PRIMARY KEY AUTOINCREMENT, 
                  orderdate INTEGER NOT NULL, 
                  totalprice INTEGER NOT NULL 
              )')
  db.execute('CREATE TABLE IF NOT EXISTS order_item ( 
                  id INTEGER PRIMARY KEY AUTOINCREMENT, 
                  quantity INTEGER, 
                  price INTEGER 
              )')
end

def seed_tables
  customer_data = [
    { username: 'Bamse', email: 'bamse@mail.com', address: 'dunder honung', hashed_password: BCrypt::Password.create('1234') },
    { username: 'skutt', email: 'skutt@mail.com', address: 'skuttvägen 4', hashed_password: BCrypt::Password.create('45678') },
    { username: 'Erick', email: 'erick@mail.com', address: 'pankakaksvägem 4', hashed_password:BCrypt::Password.create('45678') },
    { username: 'MrMilk', email: 'mrmilk@mail.com', address: 'milkroad 4', hashed_password:BCrypt::Password.create('45678') }
  ]

  customer_data.each do |customer|
    db.execute('INSERT INTO customer_data (username, email, address, hashed_password) VALUES (?, ?, ?, ?)',
               customer[:username], customer[:email], customer[:address], customer[:hashed_password])
  end

  varor = [
    { name: 'dunder honung', description: 'honung fast dunder', price: 2 },
    { name: 'vanlig honung', description: 'helt vanlig honung', price: 1 },
    { name: 'pankakor', description: 'smaskiga frasiga pankakor från erickspankakor', price: 3 },
    { name: 'mjölk', description: 'kossa', price: 2 }
  ]

  varor.each do |vara|
    db.execute('INSERT INTO varor (name, description, price) VALUES (?, ?, ?)',
               vara[:name], vara[:description], vara[:price])
  end
end

drop_tables
create_tables
seed_tables

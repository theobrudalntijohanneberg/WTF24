require 'sqlite3'

def db
  if @db == nil
    @db = SQLite3::Database.new('./src/db/db.sqlite')
    @db.results_as_hash = true
  end
  return @db
end

def drop_tables
  db.execute('DROP TABLE IF EXISTS customer')
  db.execute('DROP TABLE IF EXISTS varor')  # Changed from product to varor
  db.execute('DROP TABLE IF EXISTS cart')
  db.execute('DROP TABLE IF EXISTS "order"') # Use double quotes for order since it's a reserved keyword
  db.execute('DROP TABLE IF EXISTS order_item')
end

def create_tables
  db.execute('CREATE TABLE IF NOT EXISTS customer (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  username TEXT NOT NULL,
                  email TEXT NOT NULL,
                  password TEXT NOT NULL,
                  address TEXT NOT NULL
              )')
  db.execute('CREATE TABLE IF NOT EXISTS varor (
                  id INTEGER PRIMARY KEY AUTOINCREMENT, 
                  username TEXT NOT NULL UNIQUE, 
                  description TEXT, 
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
    { username: 'Bamse', email: 'bamse@mail.com', address: 'dunder honung', password: '1234' },
    { username: 'skutt', email: 'skutt@mail.com', address: 'skuttvägen 4', password: '45678' },
    { username: 'Erick', email: 'erick@mail.com', address: 'pankakaksvägem 4', password: '45678' },
    { username: 'MrMilk', email: 'mrmilk@mail.com', address: 'milkroad 4', password: '45678' }
  ]

  customer_data.each do |customer|
    db.execute('INSERT INTO customer (username, address, email, password) VALUES (?, ?, ?, ?)',
               customer[:username], customer[:address], customer[:email], customer[:password])
  end

  varor = [
    { username: 'dunder honung', description: 'honung fast dunder', price: 2 },
    { username: 'vanlig honung', description: 'helt vanlig honung', price: 1 },
    { username: 'pankakor', description: 'smaskiga frasiga pankakor från erickspankakor', price: 3 },
    { username: 'mjölk', description: 'kossa', price: 2 }
  ]

  varor.each do |vara|
    db.execute('INSERT INTO varor (username, description, price) VALUES (?, ?, ?)',
               vara[:username], vara[:description], vara[:price])
  end
end

drop_tables
create_tables
seed_tables

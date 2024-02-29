require 'sqlite3'

def db
  if @db == nil
    @db = SQLite3::Database.new('./db/db.sqlite')
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
                  name TEXT NOT NULL,
                  email TEXT NOT NULL,
                  password TEXT NOT NULL,
                  address TEXT NOT NULL
              )')
  db.execute('CREATE TABLE IF NOT EXISTS varor (
                  id INTEGER PRIMARY KEY AUTOINCREMENT, 
                  name TEXT NOT NULL UNIQUE, 
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
    { name: 'Bamse', email: 'bamse@mail.com', address: 'dunder honung', password: '1234' },
    { name: 'skutt', email: 'skutt@mail.com', address: 'skuttvägen 4', password: '45678' },
    { name: 'Erick', email: 'erick@mail.com', address: 'pankakaksvägem 4', password: '45678' },
    { name: 'MrMilk', email: 'mrmilk@mail.com', address: 'milkroad 4', password: '45678' }
  ]

  customer_data.each do |customer|
    db.execute('INSERT INTO customer (name, address, email, password) VALUES (?, ?, ?, ?)',
               customer[:name], customer[:address], customer[:email], customer[:password])
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

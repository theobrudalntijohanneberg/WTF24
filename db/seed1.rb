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
  db.execute('DROP TABLE IF EXISTS product')
  db.execute('DROP TABLE IF EXISTS cart')
  db.execute('DROP TABLE IF EXISTS order')
  db.execute('DROP TABLE IF EXISTS order_item')
end

def create_tables
    db.execute('CREATE TABLE IF NOT EXISTS customer (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT NOT NULL,
                    email TEXT NOT NULL,
                    password TEXT NOT NULL,
                    address TEXT NOT NULL,
                )')
    db.execute('CREATE TABLE IF NOT EXISTS product (
                "id"	INTEGER,
                "name"	TEXT NOT NULL UNIQUE,
                "description"	TEXT,
                "price"	INTEGER NOT NULL,
                PRIMARY KEY("id" AUTOINCREMENT)
              )')
    db.execute('CREATE TABLE IF NOT EXISTS "cart" (
        "id"	INTEGER,
        "quantity"	INTEGER,
        PRIMARY KEY("id" AUTOINCREMENT)
    )')
    db.execute('CREATE TABLE IF NOT EXISTS "order" (
        "id"	INTEGER,
        "orderdate"	INTEGER NOT NULL,
        "totalprice"	INTEGER NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
    )')
    db.execute('CREATE TABLE IF NOT EXISTS"order_item" (
        "id"	INTEGER NOT NULL,
        "quantity "	INTEGER,
        "price"	INTEGER,
        PRIMARY KEY("id" AUTOINCREMENT)
    );')
end

def seed_tables
  customer_data = [
    { name: 'Bamse', email: 'bamse@mail.com' address: 'dunder honung',password: '1234'},
    { name: 'skutt', email: 'skutt@mail.com' address: 'skuttvägen 4',password: '45678' },
    { name: 'Erick', email: 'erick@mail.com' address: 'pankakaksvägem 4',password: '45678'},
    { name: 'MrMilk', email: 'mrmilk@mail.com' address: 'milkroad 4',password: '45678' }
  ]

  customer_data.each do |customer|
    db.execute('INSERT INTO customer (name, address, email, password) VALUES (?, ?, ?, ?)', customer[:name], customer[:address] customer[:email], customer[:password])
  end

  product_data = [
    { name: 'dunder honung', description: 'honung fast dunder', price:2},
    { name: 'vanlig honung', description: 'helt vanlig honung' },
    { name: 'pankakor', description: 'smaskiga frasiga pankakor från erickspankakor' },
    { name: 'mjölk', description: 'kossa ' }
  ]

  product_data.each do |product|
    db.execute('INSERT INTO customer (name, address, email, password) VALUES (?, ?, ?, ?)', customer[:name], customer[:address] customer[:email], customer[:password])
  end
end

drop_tables
create_tables
seed_tables

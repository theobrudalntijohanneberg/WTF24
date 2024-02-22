require 'sqlite3'

def db
  if @db == nil
    @db = SQLite3::Database.new('./db/db.sqlite')
    @db.results_as_hash = true
  end
  return @db
end

def drop_tables
  db.execute('DROP TABLE IF EXISTS plugs')
end

def create_tables
  db.execute('CREATE TABLE IF NOT EXISTS plugs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                pris INTEGER,
                vara TEXT NOT NULL
              )')
end

def seed_tables
  plugs_data = [
    { name: 'Bamse', vara: 'dunder honung' },
    { name: 'Björnbert', vara: 'vanlig honung' },
    { name: 'Erick', vara: 'pankakor' },
    { name: 'MrMilk', vara: 'mjölk' }
  ]

  plugs_data.each do |plug|
    db.execute('INSERT INTO plugs (name, vara) VALUES (?, ?)', plug[:name], plug[:vara])
  end
end

drop_tables
create_tables
seed_tables

class App < Sinatra::Base

    def db
        if @db == nil
            @db = SQLite3::Database.new('./db/db.sqlite')
            @db.results_as_hash = true
        end
        return @db
    end

    get '/plugs' do
        @plugs = db.execute('SELECT * FROM plugs;')
        erb :plugs
     end

     get '/plugs/:id' do
        plug_id = params['id']
        @plugs = db.execute('SELECT * FROM plugs;').first
        @plug = db.execute("SELECT * FROM plugs WHERE id = #{plug_id};").first
        "Hello Plug #{plug_id}"
        erb:plug_details 
    end
      
    post '/plugs/:id/delete' do |id| 
        db.execute('DELETE FROM plugs WHERE id = ?', id)
            redirect "/plugs"
      end

     post '/plugs/' do
        name = params['name']
        vara = params['vara']
      
        query = 'INSERT INTO plugs (name, vara) VALUES (?, ?)'
      
        begin
          db.execute(query, name, vara)
          redirect '/plugs'
        end
      end
      
end
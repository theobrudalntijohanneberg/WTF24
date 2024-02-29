    
class App < Sinatra::Base

    def db
        if @db == nil
            @db = SQLite3::Database.new('./db/db.sqlite')
            @db.results_as_hash = true
        end
        return @db
    end

    get '/' do
        erb :'varor/index'
    end

    post '/varor/new' do 
        name = params['name'] 
        description = params['description']
        price = params['price'].to_i    
        query = 'INSERT INTO varor (name, description, price) VALUES (?, ?, ?) RETURNING *'
        result = db.execute(query, name, description, price).first 
        redirect "/varor/#{result['id']}" 
    end

    get '/varor/:id/update' do |id|
        @vara = db.execute('SELECT * FROM varor WHERE id = ?', id).first
        
        erb :'varor/update'
    end

    post '/varor/:id/update' do |id| 
        vara_name = params['name']
        vara_description = params['description']
        db.execute('UPDATE varor SET name = ?, description = ? WHERE id = ?', vara_name, vara_description, id)
        redirect "/varor/#{id}" 
    end

    post '/varor/:id/delete' do |id| 
        db.execute('DELETE FROM varor WHERE id = ?', id)
        redirect "/varor"
      end

    get '/varor' do 
        @varor = db.execute('SELECT * FROM varor;')
        erb :'varor/varor'
    end

    get '/varor/:id' do |id|
        @vara = db.execute('SELECT * FROM varor WHERE id = ?', id).first

        erb :'varor/show'
    end

    
end
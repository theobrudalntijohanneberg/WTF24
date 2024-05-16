    
class App < Sinatra::Base

    
    enable :sessions

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
        @user_id = session[:user_id] 

        @vara = db.execute('SELECT * FROM varor WHERE id = ?', id).first

        erb :'varor/show'
    end
    post '/new' do
        username = params['username']
        email = params['email']   
        cleartext_password = params['cleartext_password'] 
        hashed_password = BCrypt::Password.create(cleartext_password)  # Hash the password
        query = 'INSERT INTO customer_data (username, email, hashed_password) VALUES (?, ?, ?) RETURNING *'
        result = db.execute(query, username, email, hashed_password).first 
        redirect "/"
    end

    post '/login' do
        username = params['username']
        cleartext_password= params['cleartext_password'] 

        #hämta användare och lösenord från databasen med hjälp av det inmatade användarnamnet.
        @user = db.execute('SELECT * FROM customer_data WHERE username = ?', username).first
        
        #omvandla den lagrade saltade hashade lösenordssträngen till en riktig bcrypt-hash
        password_from_db = BCrypt::Password.new(@user['hashed_password'])

        #jämför lösenordet från databasen med det inmatade lösenordet
        if password_from_db == cleartext_password 
            session[:user_id] = @user['id'] 
            redirect "/varor"
        else
        redirect "/fel"
        end
        
    end

    get '/fel' do 
        erb :'varor/fel'
       
    end
end
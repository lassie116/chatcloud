require 'mongo'
require 'json'

enable :show_exceptions

ENV_FILE = '/home/dotcloud/environment.json'
DB_NAME = 'admin'

def get_collection
  db = nil
  if File.exist?(ENV_FILE)
    env = JSON.parse(File.read(ENV_FILE))
    host = env['DOTCLOUD_DB_MONGODB_HOST']
    port = env['DOTCLOUD_DB_MONGODB_PORT'].to_i
    user = env['DOTCLOUD_DB_MONGODB_LOGIN']
    pass = env['DOTCLOUD_DB_MONGODB_PASSWORD']
    con = Mongo::Connection.new(host,port)  
    db = con.db(DB_NAME)
    db.authenticate(user,pass)
  else
    con = Mongo::Connection.new
    db = con.db(DB_NAME)
  end
  db["message_list"]
end

post "/post" do
  mes = @params["mes"]
  if mes
    col = get_collection
    col.insert({"mes"=>mes,"time"=>Time.now})
  end
end

get "/get" do
  col = get_collection
  r = [];
  col.find("mes"=>{"$exists"=>true}).sort("time",:desc).each do |e|
    r << "\"#{e["mes"]}\""
  end
  "[" + r.join(",") + "]"
end

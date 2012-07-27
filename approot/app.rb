require 'mongo'
require 'json'
require 'sinatra/base'

ENV_FILE = '/home/dotcloud/environment.json'
DB_NAME = 'admin'

module Utils
  module_function

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
end

class App < Sinatra::Base
  enable :show_exceptions

  post "/post" do
    mes = @params["mes"]
    if mes
      col = Utils.get_collection
      col.insert({"mes"=>mes,"time"=>Time.now})
    end
  end

  get "/js/ws.js" do
    url = "ws://localhost:12345"
    if File.exist?(ENV_FILE)
      env = JSON.parse(File.read(ENV_FILE))
      url = env['DOTCLOUD_WS_WEBSOCKET_URL'].gsub(/^tcp/,"ws")
    end
    "var ws_url = '#{url}';\n"
  end

  get "/get" do
    col = Utils.get_collection
    r = [];
    col.find("mes"=>{"$exists"=>true}).sort("time",:desc).each do |e|
      r << "\"#{e["mes"]}\""
    end
    "[" + r.join(",") + "]"
  end
end

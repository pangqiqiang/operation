require "sinatra"
require 'sass'
require 'digest/md5'
require 'sinatra-websocket'

require './config'
require './libs'

#主页重定向到登陆页面
get '/' do
    redirect to 'login'
end

#登陆页面
get '/login' do
    slim :login
end

#登陆校验
post '/login' do
    if params[:username] == settings.username && Digest::MD5.hexdigest(params[:password]) == settings.passwordmd5
        session[:admin] = true
        session[:role] = 'common'
        redirect to('liantiao')
    elsif params[:username] == settings.admin && Digest::MD5.hexdigest(params[:password]) == settings.passadminmd5
        session[:admin] = true
        session[:role] = 'admin'
        redirect to('prod')
    else
        @invalid = true
        slim :login
    end
end


#主界面
get "/liantiao" do
    halt(401,'Not Authorized') unless session[:admin]
    @role = session[:role]
    @env = "liantiao"
    backend_dir = settings.liantiao_back_path
    frontend_dir = settings.liantiao_front_path
    @backends= get_all_projects(backend_dir, "sh")
    @frontends= get_all_projects(frontend_dir, "sh")
    slim :projects
end

get "/prod" do
    halt(401,'Not Authorized') unless session[:admin]
    @role = session[:role]
    @env = "prod"
    backend_dir = settings.prod_back_path
    frontend_dir = settings.prod_front_path
    @backends= get_all_projects(backend_dir, "sh")
    @frontends= get_all_projects(frontend_dir, "sh")
    slim :projects
end

get "/deploy/:env/:type/:name/:action" do
    env = params["env"]
    type = params["type"]
    script = params["name"]
    action = params['action']

    if !request.websocket?       #common request
        "common request cause time out"
        # stream do |out|
        #     while line = f.gets
        #        out << line + "</br>"
        #     end
        # end
    else
        request.websocket do |ws|
            ws.onopen do
                ws.send("SERVICE START RUNNING!</br>")
                exec_scripts(env, type,script, action)  do |f|
                    f.each_line do |line|
                        line.chomp!
                    #EM.next_tick { settings.sockets.each{|s| s.send(msg)}} 多端同时推送
                        EM.next_tick {ws.send(line + "</br>")} if line.size > 0
                    end
                end
                #settings.sockets << ws  #记录多个ws连接
                ws.close_connection      #完成后主动关闭ws,不然后面的没法执行
            end
            # ws.onmessage do 
            # end
            # ws.onclose do
            #    # warn("Execute completed!")
            #    # settings.sockets.delete(ws) #清除本ws连接，多端情况
            # end
        end
    end
end


#上传文件
post '/upload' do
    unless params[:file] &&
           (tempfile = params[:file][:tempfile]) &&
           (filename = params[:file][:filename])
        @error = 'No file selected'
        redirect to('projects')
    end
    remote = params[:host]
    path = params[:path]
    mode = params[:mode]
    filename = filename.split(/\s+/).join("_")
    target = "#{settings.temp_file_path}/#{filename}"
    p target
    begin
        File.open(target, 'wb') {|f| f.write tempfile.read }
        diliver(target, remote, path, mode)
    rescue
        puts "error:#{$!} at:#{$@}"
        redirect to('projects')
    end
    #File.delete(target)
    stream do |out|
    out << "上传成功</br>" << "目标地址: #{remote} #{path}/#{filename}"
    end
end
require "sinatra"
require 'sass'

#引入rack session 中间件session,失效时间1200S
use Rack::Session::Pool, :expire_after => 1200
#配置信息
configure do
    #启用session
    enable :sessions
    #配置用户信息
    set :username, 'bob' 
    set :passwordmd5, '0efe415c937f6858550a6378f4f3f374'  #'sinatra'
    set :admin, 'root'
    set :passadminmd5, '098f6bcd4621d373cade4e832627b4f6' #'test'
    #绑定服务器
    set :bind, '0.0.0.0'
    set :port, 4567
    #工程部署脚本目录
    set :liantiao_back_path, '/home/ecloud/scripts/liantiao'
    set :prod_back_path, '/home/ecloud/scripts/prod'
    set :liantiao_front_path, '/home/ecloud/scripts/front_liantiao'
    set :prod_front_path, '/home/ecloud/scripts/front_prod'
    #临时文件目录
    set :temp_file_path, '/data/sources/files'
end

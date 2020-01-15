require './config'

#辅助函数,获取工程列表元素
def get_all_projects(path, ext)
    projects = []
    Dir.glob("#{path}/*.#{ext}") do |file|
        script_name = File.split(file)[1]
        projects << script_name.split("_")[0]
    end
    projects
end


#执行部署函数
def exec_scripts(env, type, script, action, &block)
    if env == "liantiao"
        if type == "back"
            path = settings.liantiao_back_path
        elsif type == "front"
            path = settings.liantiao_front_path
        end
    elsif env == "prod"
        if type == "back"
            path = settings.prod_back_path
        elsif type == "front"
            path = settings.prod_front_path
        end
    end
    script = sprintf("%s/%s", path, script)
    puts script
    if action == "deploy"
        IO.popen(["/bin/bash", script], "r",  &block)
        return
    end
    IO.popen(["/bin/bash", script, action], "r", &block)
end

#分发上传文件
def diliver(file, remote, path, mode)
    command = "ansible #{remote} -m copy -a \"src=#{file} dest=#{path} owner=ecloud group=ecloud mode=#{mode} backup=yes\" -b"
    IO.popen(command)
end
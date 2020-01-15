var host = "deploy.ecloudsign.com:4567";
function wsGet(path, env, type, script, sufix, action){
    var outer = document.getElementById('out');
    outer.style.display ="block";
    var url = "ws://" + host + path + "/" + env + "/" + type + "/" + script + sufix + "/" + action;
    var ws = new WebSocket(url);
    ws.onopen = function(){
        outer.innerHTML = "开始执行.......</br>";
    }
    ws.onmessage = function (evt) { 
        outer.innerHTML += evt.data;
    };
}
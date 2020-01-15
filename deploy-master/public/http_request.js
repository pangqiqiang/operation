function httpGet(url){
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open("GET", url, false); // false: wait respond
    xmlHttp.send(null);
    return xmlHttp.responseText;
}

function wsGet(address, env, script, sufix, action){
    document.getElementById('out').style.display ="block"
    var url = address + "/" + env + "/" + script + sufix + "/" + action;
    var url = address + "/" + env + "/" + "test.sh" + "/" + action;
    response = "执行结果</br>" + httpGet(url);
    document.getElementById('out').innerHTML = response;
 }
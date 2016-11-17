// Use new ES6 modules syntax for everything.

import { remote } from 'electron'; // native electron module
import jetpack from 'fs-jetpack'; // module loaded from npm
import $ from "jquery";
import selectize from 'selectize'; // module loaded from npm
import env from './env';
import child_process from "child_process";
import settings from "./helpers/settings";

console.log('Loaded environment variables:', env);
var app = remote.app;
var appDir = jetpack.cwd(app.getAppPath());


console.log('The author of this app is:', appDir.read('package.json', 'json').author);

document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('env-name').innerHTML = env.name;

    $('#select-users').selectize({
        plugins: ['remove_button','restore_on_backspace'],
        delimiter: ';',
        persist: false,
        create: function(input) {
            return {
                value: input,
                text: input
            }
        }
    });

    var buttons = document.getElementsByTagName('button');
    Array.from(buttons).forEach(button => {
        button.addEventListener('click', buttonHandler);
    });

    settings.get().then(val => {
        console.log(val);
    });

});

function buttonHandler(event){
    switch(event.target.id){
        case('get-user-details'):
            //TODO ps script to get user details from AD
            break;
        case('start-groupmembership-script'):
            startGroupMembership();
            //TODO start powershell process with group manager tool
            break;
        case('open-email'):
            //TODO email with recipients form user selection
            break;
        default:
            alert('Button handler not implemented for this button')
    }
}

function startGroupMembership() {
    var spawn =  child_process.spawn,child;
    child = spawn("powershell.exe",["powershell.exe -ExecutionPolicy Bypass c:\\temp\\test.ps1"]);
    child.stdout.on("data",function(data){
        console.log("Powershell Data: " + data);
    });
    child.stderr.on("data",function(data){
        console.log("Powershell Errors: " + data);
    });
    child.on("exit",function(){
        console.log("Powershell Script finished");
    });
    child.stdin.end(); //end input
}



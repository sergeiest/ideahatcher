// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .


function showHiddenIdeas(elementName) {

    var elementName_1 = elementName + "_1";
    var elementName_2 = elementName + "_info";
    var elementName_3 = "following_"+ elementName;
    var invertElementName_1 = elementName + "_invert_1";

    if (document.getElementById(elementName_1).hidden == true) {
        document.getElementById(elementName_1).hidden = false;
        document.getElementById(invertElementName_1).hidden = true;
        document.getElementById(elementName_2).hidden = false;
        document.getElementById(elementName_3).hidden = false;

    } else {
        document.getElementById(elementName_1).hidden = true;
        document.getElementById(invertElementName_1).hidden = false;
        document.getElementById(elementName_2).hidden = true;
        document.getElementById(elementName_3).hidden = true;
    }
}


function showHiddenForm(elementName) {

    var elementName_1 = elementName + "_1";
    var elementName_form = elementName + "_form";

    var invertElementName_1 = elementName + "_invert_1";

    if (document.getElementById(elementName_1).hidden == true) {
        document.getElementById(elementName_1).hidden = false;
        document.getElementById(invertElementName_1).hidden = true;
        document.getElementById(elementName_form).hidden = false;
    } else {
        document.getElementById(elementName_1).hidden = true;
        document.getElementById(invertElementName_1).hidden = false;
        document.getElementById(elementName_form).hidden = true;
        document.getElementById(elementName_form).getElementsByTagName('textarea')[0].value = "";
    }
}




function checkProblem(elementName) {
    if (document.getElementById('check_'+ elementName).checked == true) {
        document.getElementById('check_'+ elementName).checked = false;
        document.getElementById('problem_'+ elementName).style.background =  '#ffffff';
    } else {
        document.getElementById('check_'+ elementName).checked = true;
        document.getElementById('problem_'+ elementName).style.background = '#ecf8ff';
    }
}

function startSlideLightning(barId){
    var bar = document.getElementById('bar_'+barId);
    var slider = document.getElementById('slider_'+barId);
    var info = document.getElementById('info_'+barId);
    var set_perc = ((((event.clientX - bar.offsetLeft -280) / bar.offsetWidth)).toFixed(2));
    slider.style.width = (set_perc * 100) + '%';

}


function stopSlideLightning(barId){
    var bar = document.getElementById('bar_'+ barId);
    var slider = document.getElementById('slider_'+ barId);
    var info = document.getElementById('info_'+ barId);
    var set_perc = ((((event.clientX - bar.offsetLeft -280) / bar.offsetWidth)).toFixed(2));
    slider.style.width = (set_perc * 100) + '%';
    info.style.marginLeft = set_perc * 135 + 'px';
    info.innerText = Math.round(set_perc * 5)/1 ;
    document.getElementById('form_'+ barId).querySelector("#vote_score").value = Math.round(set_perc * 5)/1 ;
    $('#button_'+ barId).click();
}

function startSlideVote(barId, barNode, offsetPoint, totalWidth){
    var set_perc = ((((event.clientX - barNode.offsetLeft - offsetPoint) / barNode.offsetWidth)).toFixed(2));
    barNode.children[0].style.width = (set_perc * 100) + '%';
}


function stopSlideVote(barId, barNode, offsetPoint, totalWidth){
    var set_perc = ((((event.clientX - barNode.offsetLeft - offsetPoint) / barNode.offsetWidth)).toFixed(2));
    barNode.children[0].style.width = (set_perc * 100) + '%';
    var info = document.getElementById('info_'+ barId);
    info.style.marginLeft = (set_perc * barNode.clientWidth * 0.9) + 'px';
    info.innerText = Math.round(set_perc * 5)/1;
    document.getElementById('form_'+ barId).querySelector("#vote_score").value = Math.round(set_perc * 5)/1 ;
    $('#button_'+ barId).click();
}


function MM_changeProp(objId,x,theProp,theValue) { //v9.0
    var obj = null; with (document){ if (getElementById)
        obj = getElementById(objId); }
    if (obj){
        if (theValue == true || theValue == false)
            eval("obj.style."+theProp+"="+theValue);
        else eval("obj.style."+theProp+"='"+theValue+"'");
    }
}

function showLoginForm() {
    $('#login_modal').modal('show');
}

function clearInput (elementNode) {
    elementNode.value = "";
    elementNode.onclick ="";
}

function highlightFrame (elementNode) {
    elementNode.getElementsByClassName('demo-grad')[0].style.opacity = 0;
    elementNode.getElementsByClassName('demo-text')[0].style.opacity = 0.9;
    elementNode.getElementsByClassName('demo-text')[0].style.backgroundColor = "#333333";

}


function whiteFrame (elementNode) {
    elementNode.getElementsByClassName('demo-grad')[0].style.opacity = 0.6;
    elementNode.getElementsByClassName('demo-text')[0].style.opacity = 1;
    elementNode.getElementsByClassName('demo-text')[0].style.backgroundColor = "inherit";
}

function changeGrad (elementNode) {
    elementNode.style.backgroundImage = "-webkit-gradient(linear, right top, left bottom, color-stop(0.17, white), color-stop(0.59, red))";
}

function submitForm (formElement) {
    notes = formElement.children;
    for (var i = 0; i < notes.length; i++) {
        if (notes[i].getAttribute('name') == 'commit') {
            notes[i].click();
        }
    }
}

function showHelp (elementNode) {
    if (elementNode.getElementsByTagName("i")[0].hidden == false) {
        elementNode.style.width = '20%';
        elementNode.getElementsByTagName("i")[0].hidden = true;
        for (var i = 0; i < elementNode.getElementsByTagName("h5").length; i++) {
            elementNode.getElementsByTagName("h5")[i].hidden = false;
        }
        for (var i = 0; i < elementNode.getElementsByTagName("p").length; i++) {
            elementNode.getElementsByTagName("p")[i].hidden = false;
        }
    } else {
        elementNode.style.width = '15px';
        elementNode.getElementsByTagName("i")[0].hidden = false;
        for (var i = 0; i < elementNode.getElementsByTagName("h5").length; i++) {
            elementNode.getElementsByTagName("h5")[i].hidden = true;
        }
        for (var i = 0; i < elementNode.getElementsByTagName("p").length; i++) {
            elementNode.getElementsByTagName("p")[i].hidden = true;
        }
    }

}

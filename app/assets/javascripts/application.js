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

$(document).ready(function() {
    $('#login_modal').on('hidden', function() {
        if(replies_shown == true){
            $('#show-replies-modal').modal('show');
        }
    })
    window.showLoginModal = function(){
        if ($('#show-replies-modal').length != 0){
            replies_shown = $('#show-replies-modal').data('modal').isShown;
            if (replies_shown == true){
                $('#show-replies-modal').modal('hide');
            }
        }
        $('#login_modal').modal('show');
    }
    $('.help-hatch').on('click', function(){
        var panel_open = this.getAttribute("data-openpanel");
        if ($(panel_open).is('.in')){
            this.innerText = '';
            this.innerText = 'Help hatch it!';
            $(panel_open).collapse('hide');
        }
        else{
            this.innerText = '';
            this.innerText = 'Close detailed view';
            $(panel_open).collapse('show');
            var actual_panel = document.getElementById(panel_open.substring(1));
            console.log(actual_panel);
            actual_panel.scrollIntoView();
            var scrolledY = window.scrollY;
            console.log(scrolledY);
            if (scrolledY){
                window.scroll(0, scrolledY-234);
            }

        }
    })
})


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



function startSlideVote(barId, barNode, offsetPoint, totalWidth){
    var set_perc = ((((event.clientX - barNode.offsetLeft - offsetPoint) / barNode.offsetWidth)).toFixed(2));
    var final_val = Math.ceil(set_perc * 5)
    barNode.children[0].style.width = (final_val * 20) + '%';
}

function stopSlideVote(barId, barNode, offsetPoint, totalWidth){
    var set_perc = ((((event.clientX - barNode.offsetLeft - offsetPoint) / barNode.offsetWidth)).toFixed(2));
    var final_val = Math.ceil(set_perc * 5)
    barNode.children[0].style.width = (final_val * 20) + '%';
    var info = document.getElementById('info_'+ barId);
    info.style.marginLeft = (final_val * barNode.clientWidth * 0.2 - 3) + 'px';
    if ( final_val == 0 ||  final_val == 5){
        info.innerText = "";
        info.hidden = true;
    } else {
        info.innerText = final_val;
        info.hidden = false;
    }

    document.getElementById('form_'+ barId).querySelector("#vote_score").value = final_val ;
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

function animationScroll(startPoint, endPoint) {
    animationStepScroll(startPoint, endPoint, 0);
}

function animationStepScroll(startPoint, endPoint, i){
    k = 1 * ((startPoint < endPoint) - (endPoint < startPoint));
    i += k;
    window.scrollBy(0,k);
    scrolldelay = setTimeout(function(){animationStepScroll( startPoint, endPoint, i);},1);
    if ( (startPoint + i) * k >= k * endPoint){clearTimeout(scrolldelay);}
}


function animationCustom(elementNode,attributeName, startPoint, endPoint, toHide) {
    animationStep(elementNode, attributeName, startPoint, endPoint, toHide, 0);
}

function animationStep(elementNode, attributeName, startPoint, endPoint, toHide, i){
    stepSign = ((startPoint < endPoint) - (endPoint < startPoint));
    step = (endPoint - startPoint) / 3
    i += step;
    if (attributeName == "height") {
        elementNode.style.height = startPoint + i + 'px';
    }
    animationDelay = setTimeout(function(){animationStep(elementNode, attributeName, startPoint, endPoint, toHide, i)},500);
    if ( (startPoint + i) * stepSign >= stepSign * endPoint ){
        clearTimeout(animationDelay);
        if (toHide) {
            elementNode.hidden = true
            if (attributeName == "height") {
                elementNode.style.height = startPoint + 'px';
            }
        };
    }
}

function designButtons(){
    notes = document.getElementsByClassName("custom-button");
    for (var i = 0; i < notes.length; i++) {
        notes[i].style.boxShadow = "5px 5px 0px #888888";
        notes[i].onmousedown = function(){customClickDown(this)};
        notes[i].onmouseup = function(){customClickUp(this)};
        notes[i].onmouseout = function(){customClickUp(this)};
    }
}

function customClickDown(elementNode){
    elementNode.style.left = elementNode.offesLeft + 5 +'px';
    elementNode.style.boxShadow = "";
}
function customClickUp(elementNode){
    elementNode.style.left = elementNode.offesLeft - 5 + 'px';
    elementNode.style.boxShadow = "5px 5px 0px #888888";
}

function customHighlightIn(elementNode, colorName){
    if (colorName == null) {elementNode.style.backgroundColor = '#94d500'}
    if (colorName == 'yellow') {elementNode.style.backgroundColor = 'rgba(254, 233, 70, 0.41)'}
    if (colorName == 'green') {elementNode.style.backgroundColor = 'rgba(148, 213, 0, 0.41)'}
    if (colorName == 'orange') {elementNode.style.backgroundColor = 'rgba(251, 176, 59, 0.41)'}
    if (colorName == 'aqua') {elementNode.style.backgroundColor = 'rgba(15, 219, 199, 0.41)'}
}
function customHighlightOut(elementNode){
    elementNode.style.backgroundColor = 'inherit'
}
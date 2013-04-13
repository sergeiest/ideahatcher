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


function showHidden(elementName) {

    var elementName_1 = elementName + "_1";
    var elementName_2 = elementName + "_2";
    var elementName_3 = elementName + "_3";
    var invertElementName_1 = elementName + "_invert_1";
    var invertElementName_2 = elementName + "_invert_2";
    var invertElementName_3 = elementName + "_invert_3";

    if (document.getElementById(elementName_1).hidden == true) {
        document.getElementById(elementName_1).hidden = false;
        document.getElementById(invertElementName_1).hidden = true;
        document.getElementById(elementName_2).hidden = false;
        document.getElementById(elementName_3).hidden = false;
        document.getElementById(invertElementName_2).hidden = true;
        document.getElementById(invertElementName_3).hidden = true;
    } else {
        document.getElementById(elementName_1).hidden = true;
        document.getElementById(invertElementName_1).hidden = false;
        document.getElementById(elementName_2).hidden = true;
        document.getElementById(elementName_3).hidden = true;
        document.getElementById(invertElementName_2).hidden = false;
        document.getElementById(invertElementName_3).hidden = false;
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


function startSlide(barId){
    var bar = document.getElementById('bar_'+barId);
    var slider = document.getElementById('slider_'+barId);
    var info = document.getElementById('info_'+barId);
    var modal = document.getElementById('modal_like');
    var set_perc = ((((event.clientX - bar.offsetLeft - modal.offsetLeft) / bar.offsetWidth)).toFixed(2));
    slider.style.width = (set_perc * 100) + '%';
    }


function stopSlide(barId){
    var bar = document.getElementById('bar_'+ barId);
    var slider = document.getElementById('slider_'+ barId);
    var info = document.getElementById('info_'+ barId);
    var modal = document.getElementById('modal_like');
    var set_perc = ((((event.clientX - bar.offsetLeft - modal.offsetLeft) / bar.offsetWidth)).toFixed(2));
    slider.style.width = (set_perc * 100) + '%';
    info.style.marginLeft = set_perc * 180 + 'px';
    info.innerText = Math.round(set_perc * 5)/1 ;
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
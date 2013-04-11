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


function changeStatusLike(elementId,divName) {
    document.getElementById('like_'+ divName).disabled = false;
    document.getElementById('not_clear_'+ divName).disabled = false;
    document.getElementById('dislike_'+ divName).disabled = false;
    document.getElementById('like_'+ divName).className = "btn btn-mini";
    document.getElementById('not_clear_'+ divName).className = "btn btn-mini";
    document.getElementById('dislike_'+ divName).className = "btn btn-mini";

    document.getElementById(elementId).disabled = true;
    document.getElementById(elementId).className = "btn btn-mini btn-primary";

    this.event.returnValue = false;
    if (elementId.lastIndexOf('dislike_', 0)) {
        $('#modal_'+ elementId).modal('show');
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
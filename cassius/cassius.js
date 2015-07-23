// User settings

var initialPages = 50;

// Do not modify below this line

var pagecount = 0;
var overset = false;
var template = ''
var title = ''

$( document ).ready(function() {
	var metadata = $($('#cassius-metadata').html());

	var title = metadata.find('#cassius-title').html();
	var authors = metadata.find('#cassius-authors').html();
	var affils = metadata.find('#cassius-affiliations').html();
	var publication = metadata.find('#cassius-publication').text();
	var doi = metadata.find('#cassius-doi').text();
	var pdate = metadata.find('#cassius-date').text();

	if (title == '') {
		title = document.title;
	}

	$(".articletitle").html(title);
	$(".authors").text(authors);
	$(".affiliations").text(affils);

	template = '<div class="page"><div class="header"><img src="cassius/images/logo.png"></div><div class="content"></div><div class="footer" id="footer"><i>' + publication + '</i> | DOI: <a href="http://dx.doi.org/' + doi + '">' + doi + '</a> | ' + pdate + '<div class="pagination"><span class="page-number-current"></span> / <span class="page-number-total"></span></div></div></div>'

	// hook the regionfragmentchange event and, when fired, adjust the number of pages and paginate etc.
	document.getNamedFlows()[0].addEventListener('regionfragmentchange', modifyFlow);

	addPages(initialPages, 0, $('#article'));
});
	
function modifyFlow(e) {
	var article  = $('#article'); 
	var pages  = $('.page-region');

	if (document.getNamedFlows()[0].firstEmptyRegionIndex == -1) {

		if (overset == true) {
			pages.find('.page-number-total').text(pagecount);
			return;
		}

		addPages(11, pagecount, $('#article'));

	} else {
		if (overset == false) {
			overset = true;
		}

		removePages(document.getNamedFlows()[0].firstEmptyRegionIndex);

		pages.find('.page-number-total').text(pagecount);
  	}

}

function addPages(number, offset, appendElement) {
	for(var pageCounter=1; pageCounter<number; pageCounter++) {
	    var template_copy = $(template);

	    appendElement.append(template_copy);

	    template_copy.addClass('page-' + (offset + pageCounter)).find('.page-number-current').text(offset + pageCounter).end();
	    template_copy.addClass('page-region');
  	}

  	pagecount = pagecount + number - 1;
}

function removePages(minimum){
	while (pagecount > minimum) {
		$('.page-' + pagecount).remove();
		pagecount = pagecount - 1;
	}
}
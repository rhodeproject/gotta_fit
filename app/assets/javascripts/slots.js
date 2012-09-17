/**
 * Created with JetBrains RubyMine.
 * User: USER1
 * Date: 7/10/12
 * Time: 8:31 PM
 * To change this template use File | Settings | File Templates.
 */
$(document).ready(function(){
    /*Initialize*/
    $('#new_slot').hide();
    $('#recCount').hide();
    $('#lblRecCount').hide();
    $('#slot_date').datepicker({
        minDate: new Date()
    });
    $('#preview').hide();

    /*On Click Events*/
    $('#recurring').click(function event(){
        if ($('#recurring:checked').val() == "true"){
            $('#recCount').fadeIn('slow');
            $('#lblRecCount').fadeIn('slow');
        }else{
            $('#recCount').fadeOut('slow');
            $('#lblRecCount').fadeOut('slow');
        }
    });
    /*Jquery UI Modal*/
    $('#new').click(function event(){
        $('#new_slot').dialog('open');
        return false;
    });
    $('#new_slot').dialog({
        autoOpen: false,
        open: {effect: "fadeIn", duration: 500},
        hide: {effect: "fadeOut", duration: 500},
        height: 500,
        width: 300,
        modal: true,
        buttons: [
            {
                text: "Add",
                click: function(event){
                    if($('#recurring:checkbox').val() == 'true'){
                        addRecurringSlots();
                        $('#preview').fadeIn('slow');
                    }else{
                        var myDate = new Date($('#slot_date').val());
                        submitAjax(mapDay(myDate.getDay()),
                            $('#slot_date').val(),
                            $('#slot_start_time').val(),
                            $('#slot_end_time').val(),
                            $('#slot_spots').val());
                        $('#preview').fadeIn('slow');
                    }
                    $(this).dialog("close");
                    return false;
                }
            },
            {
                text: "Close",
                click: function(){$(this).dialog("close");}
            }
        ]
    });
});

/*Functions*/
function addRecurringSlots(){
    var sDate = $('#slot_date').val();
    var sTime = $('#slot_start_time').val();
    var eTime = $('#slot_end_time').val();
    var sPots = $('#slot_spots').val();
    var myDate = new Date(sDate);
    submitAjax(mapDay(myDate.getDay()),sDate,sTime,eTime,sPots);
    for (var count = $('#recCount').val(); count > 1; count--){
        var addDate = 7 * (count - 1);
        var newDate = new Date();
        newDate.setDate(myDate.getDate()+addDate);
        submitAjax(mapDay(newDate.getDay()),buildDateString(newDate),sTime,eTime,sPots);
    }
}
function buildDateString(dDate){
    var day = dDate.getDate();
    var month = dDate.getMonth() + 1;
    var year = dDate.getFullYear();
    return month + "/" + day + "/" + year;
}

function mapDay(iDay){
    var aDays = new Array("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday");
    return aDays[iDay];
}
function submitAjax(sDay,sDate,sTime,eTime,sPots){
    $.ajax({
        type: "POST",
        url: '/slots',
        data: {slot:{date: sDate,
            start_time: sTime,
            end_time: eTime,
            spots: sPots}},
        error: function(e){
          alert('There was problem saving the session');
        },
        success: function(){
            $('.alert').append('New Rider Session Added');
            $('#tblPreviewSlots').append(
                '<tr><td>'+sDay+" "+sDate+'</td><td>'
                    +sTime+'</td><td>'
                    +eTime+'</td><td>'
                    +sPots+'</td><td>'
                    +sPots+'</td><td>0</td>' +
                    '<td></td></tr>'
            ).fadeIn("slow");
        },
        dataType: "JSON"
    });
}
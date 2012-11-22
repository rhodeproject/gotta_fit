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
    $('#btnSession').hide();
    $('.edit_slot').hide();

    $('#showSlotEdit').click(function(event){
        $('.edit_slot').slideToggle(100);
    });

    /*Add User for Admin*/
    $('#btnAdminAddUser').click(function(event){
       $('#adminAddUser').dialog('open');
        return false;
    });

    $('#adminAddUser').dialog({
        title: "select a user",
        autoOpen: false,
        open: {effect: "fadeIn", duration: 500},
        height: 150,
        width: 300,
        modal: true
    });

    if ($('#slotDate').length > 0 && $('#slotTime').length > 0) {
        currentSlot($('#slotDate').val(),$('#slotTime').val());
    }

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
        height: 550,
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
                        submitAjax($('#slot_description').val(),
                            mapDay(myDate.getDay()),
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
    var sDescription = $('#slot_description').val();
    var sDate = $('#slot_date').val();
    var sTime = $('#slot_start_time').val();
    var eTime = $('#slot_end_time').val();
    var sPots = $('#slot_spots').val();
    var myDate = new Date(sDate);
    submitAjax(sDescription,mapDay(myDate.getDay()),sDate,sTime,eTime,sPots);

    for (var count = $('#recCount').val(); count > 1; count--){

        var addDate = 7 * (count - 1);
        var newDate = new Date(sDate);
        newDate.setDate(newDate.getDate() + addDate);
        submitAjax(sDescription,mapDay(newDate.getDay()),buildDateString(newDate),sTime,eTime,sPots);
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
function submitAjax(sDesc,sDay,sDate,sTime,eTime,sPots){
    $.ajax({
        type: "POST",
        url: '/slots',
        data: {slot:{date: sDate,
            description: sDesc,
            start_time: sTime,
            end_time: eTime,
            spots: sPots}},
        error: function(e){
          alert('There was problem saving the session');
        },
        success: function(data){
            $('#tblPreviewSlots').append(
                '<tr><td>'+sDay+" "+sDate+'</td><td>'
                    +sDesc+'</td><td>'
                    +sTime+'</td><td>'
                    +eTime+'</td><td>'
                    +sPots+'</td><td>'
                    +sPots+'</td><td>0</td>' +
                    '<td></td></tr>'
            ).fadeIn("slow");
        },
        dataType: "JSON",
        async: false
    });
}

function currentSlot(sDate, sTime){
    /*sDate is in format YYYY-MM-DD*/
    /*Split sDate*/
    splitDate = sDate.split('-');
    splitDay = splitDate[2];
    splitMonth = splitDate[1] - 1;
    splitYear = splitDate[0];

    /*sTime is in the format HH:MM:SS*/
    /*split Time*/
    splitTime = sTime.split(':');
    splitHour = splitTime[0];
    splitMinute = splitTime[1];
    splitSecond = splitTime[2];

    window.console && console.log(splitDate);
    window.console && console.log(splitTime);
    window.console && console.log("Split Year" + splitYear);
    dDate = new Date();
    slotDate = new Date(splitYear,splitMonth,splitDay,splitHour,splitMinute,splitSecond);
    window.console && console.log(dDate);
    window.console && console.log(slotDate);
    if (dDate < slotDate){
        $('#btnSession').show();
        $('.edit_slot').fadeIn();
    };
}
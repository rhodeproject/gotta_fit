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

    //show  $('.edit_slot') if the class of the parent div is 'show-edit'
    if($('.edit_slot').length > 0 && $('.edit_slot').parent().hasClass('show-edit')){
        $('.edit_slot').slideToggle(700);
    }

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
                       // $('#preview').fadeIn('slow'); //this is used to add newly added slots to a preview table
                    }else{
                        var myDate = new Date($('#slot_date').val());
                        submitAjax($('#slot_description').val(),
                            mapDay(myDate.getDay()),
                            $('#slot_date').val(),
                            $('#slot_start_time').val(),
                            $('#slot_end_time').val(),
                            $('#slot_spots').val());
                       // $('#preview').fadeIn('slow'); //this is used to add newly added slots to a preview table
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
            //window.console && console.log(data);
            $('#tblShowSlots').append(
                '<tr class="new_slot"><td>'+sDay+" "+sDate+'</td><td>'
                    +data.description+'</td><td>'
                    +formatTime(data.start_time)+'</td><td>'
                    +formatTime(data.end_time)+'</td><td>'
                    +data.spots+'</td><td>'
                    +data.spots+'</td><td>0</td><td>'
                    +'<a href="/slots/'+ data.id +'">View Details</a> | '
                    +'<a data-method="delete" id="slotRemove" href="/slots/'+ data.id +'">Remove</a>'
                    +'</td></tr>'
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

    dDate = new Date();
    slotDate = new Date(splitYear,splitMonth,splitDay,splitHour,splitMinute,splitSecond);

    if (dDate < slotDate){
        $('#btnSession').show();
        $('.edit_slot').fadeIn();
    };
}

//Convert 24 hour time to 12 hour AM/PM
function formatTime(time){
    //Incoming Time format hh:mm:ss
    splitTime = time.split(":");
    hour = splitTime[0];
    minute = splitTime[1];

    //Determine if the hour is AM or PM
    if (hour > 12){
        amPM = "PM";
        hour = hour - 12;
    }else{
        amPM = "AM";
    }

    //return time in hh:mm AM/PM
    return hour +":" + minute + " " + amPM;
}
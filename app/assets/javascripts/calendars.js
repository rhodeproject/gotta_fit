/**
 * Created with JetBrains RubyMine.
 * User: USER1
 * Date: 7/29/12
 * Time: 12:19 PM
 * To change this template use File | Settings | File Templates.
 */
$(document).ready(function(){
    $('#calendar').fullCalendar({
        editable: true,
        theme: true,
        ignoreTimezone: false,
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        startParam: 'start_time',
        endParam: 'end_time',
        weekMode: 'liquid',
        defaultView: 'month',
        height: 500,
        firstHour: 5,
        slotMinutes: 30,

        loading: function(bool){
            if (bool)
                $('#loading').show();
            else
                $('#loading').hide();
        },

        // a future calendar might have many sources.
        eventSources: [{
            url: '/slots/calendar',
            eventColor: '#378006',
            color: 'green',
            textColor: 'black',
            ignoreTimezone: true
        }],

        timeFormat: 'h:mm t{ - h:mm t} ',
        dragOpacity: "0.5",

        //http://arshaw.com/fullcalendar/docs/event_ui/eventDrop/
        eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc){
            updateEvent(event);
        },

        // http://arshaw.com/fullcalendar/docs/event_ui/eventResize/
        eventResize: function(event, dayDelta, minuteDelta, revertFunc){
            updateEvent(event);
        },

        // http://arshaw.com/fullcalendar/docs/mouse/eventClick/
        eventClick: function(event, jsEvent, view){
            // would like a lightbox here.
        }
    });

    function updateEvent(the_event) {
        $.update(
            "/slots/" + the_event.id,
            { event: { title: the_event.title,
                start_time: "" + the_event.start_time,
                end_time: "" + the_event.end_time,
                description: the_event.description
            }
            },
            function (response) { alert('successfully updated task.'); }
        );
    }
    });

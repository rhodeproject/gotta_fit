/**
 * Created with JetBrains RubyMine.
 * User: USER1
 * Date: 7/10/12
 * Time: 8:30 PM
 * To change this template use File | Settings | File Templates.
 */

$(document).ready(function(){
   $('#tblUsers').dataTable({
       "bRetrieve": true,
       "bPaginate": true,
       "bLengthChange": false,
       "bFilter": false,
       "bInfo": true,
       "bAutoWidth": false,
       "aaSorting": [[1, "asc"]]
   });

   //by default hide the inactive key
   $('#inactive_key').hide();

    //call the two functions that will style the table based on data
    //for example, if a user is inactive the text should be red and if a user
    //has negative rides, the ride number is in "the red"
    if($("#tblUsers").length > 0){
        rowColor("tblUsers","inactive");
        negNumber("tblUsers");
    }

    $('#frmLogin').hide();

    $('#btnLogin').click(function(event){
        $('#frmLogin').dialog('open').fadeIn(1000);
        return false;
    });
    $('#btnLoginMain').click(function(event){
       $('#frmLogin').dialog('open').fadeIn(1000);
        return false;
    });

    $('#frmLogin').dialog({
        autoOpen: false,
        open: {effect: "fadeIn", duration: 1000},
        height: 300,
        width: 300,
        modal: true
    });
    /*Help Modal --Should move this*/
    $('#frmHelp').hide();
    $('#frmHelp').dialog({
        autoOpen: false,
        open: {effect: "fadeIn", duration: 500},
        height: 275,
        width: 300,
        modal: true
    });
    $('#btnHelp').click(function(event){
        $('#frmHelp').dialog('open');
        return false;
    });
});

//function for changing the text of a row to red if the user is unactive
function rowColor(tableName, className){
    var rows = document.getElementById(tableName).getElementsByTagName('tr');
    $.each(rows, function(i, row){ //loop through all the rows
        var columns = row.getElementsByTagName('td');
        $.each(columns, function(i, col){
            //logIt($(this));
            if ($(this).hasClass(className)){
                $(this).parent().css('color','red').fadeIn(1000);
                $('#inactive_key').fadeIn(1000);
            }
        });
    });
}

//function for turning negative numbers red in a table
function negNumber(tableName){
    var rows = document.getElementById(tableName).getElementsByTagName('tr');
    $.each(rows, function(i, row){
        var columns = row.getElementsByTagName('td');
        $.each(columns, function(i, col){
            //logIt($(this));
            //logIt($(this).text());
            if($(this).text() < 0){
                $(this).css('color', 'red').fadeIn(1000);
            }
        });
    });
}
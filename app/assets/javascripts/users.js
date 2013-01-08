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
       "aaSorting": [[1, "asc"]],
       "fnRowCallback": function(nRow, aData, iDisplayIndex){ //change the color of text based on cell content
           if (aData[6] < 0){  //if the rides remaining are negative, change text to red
               $('td:eq(6)', nRow).css('color', 'red');
           }
           if (aData[2] == "no"){ //if the user is inactive change the color of the whole row to red
               $('td:eq(0)',nRow).css('color','red'); //First Name
               $('td:eq(1)',nRow).css('color','red'); //Last Name
               $('td:eq(2)',nRow).css('color','red'); //Active
               $('td:eq(3)',nRow).css('color','red'); //Admin
               $('td:eq(4)',nRow).css('color','red'); //Email Address
               $('td:eq(5)',nRow).css('color','red'); //Joined - Days Ago
               $('td:eq(6)',nRow).css('color','red'); //Remaining Rides
           }
           return nRow;

       },
       "fnFooterCallback": function(nRow, aaData, iStart, iEnd, aiDisplay){ //determine if there are inactive users in table
           //Calculate the total number of inactive users
           var iTotalInactive = 0;
           for (var i=0; i<aaData.length; i++){
               if (aaData[i][2] == "no"){
                   iTotalInactive++;
               }
           }
           //Modify the footer
           if (iTotalInactive > 0){ //if there are inactive users display note
               $('#tblUsers_paginate').after("<br><div class='inactive'>*inactive users in red</div>");
           }

       }
   });

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



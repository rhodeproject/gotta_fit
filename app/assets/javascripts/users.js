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
       "bAutoWidth": false
   });
    $('#frmLogin').hide();

    $('#btnLogin').click(function(event){
        $('#frmLogin').dialog('open');
        return false;
    });
    $('#btnLoginMain').click(function(event){
       $('#frmLogin').dialog('open');
        return false;
    });

    $('#frmLogin').dialog({
        autoOpen: false,
        open: {effect: "fadeIn", duration: 500},
        height: 275,
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

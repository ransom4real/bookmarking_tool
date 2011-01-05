
  $j(document).ready(function(){

	$j("#groups").change(function () {
	  
          var str = "";
          $j("#groups option:selected").each(function () {
                str += $j(this).val();
              });
          $j.post("/contacts/select_group_contacts", { id: str},
  function(data){
	if(data.length > 0)
        {
		var err = /ERROR/;
		if(err.test(data))
		{
			 $j("#error").html(data);
			 $j("#group_contacts").html("");
			 $j("#coninfo").html("");
			 $j("#error").fadeIn(3000);
            		 $j("#error").fadeOut(1000);


		}
		else
		{
	    	$j("#Form").html(data);
		}
	}
  });
          
        });

	$j("#addtogrp").click(function () {
	var contacts = "";
	var group = "";
          $j("#contacts option:selected").each(function () {
                contacts += $j(this).val() + ",";
              });
          $j("#groups option:selected").each(function () {
                group += $j(this).val();
              });

	  $j.post("/contacts/add_contact_group", { contacts: contacts, group: group},
  function(data){
	if(data.length > 0)
        {
		var err = /ERROR/;
		if(err.test(data))
		{
			 $j("#error").html(data);
			 $j("#group_contacts").html("");
			 $j("#coninfo").html("");
			 $j("#error").fadeIn(3000);
            		 $j("#error").fadeOut(1000);
			 

		}
		else
		{
	    	$j("#Form").html(data);
		}
	}
  });

        });

	$j("#rmfrmgrp").click(function () {
		var contacts = "";
		var group = "";
          $j("#group_contacts option:selected").each(function () {
                contacts += $j(this).val() + ",";
              });
          $j("#groups option:selected").each(function () {
                group += $j(this).val();
              });

	  $j.post("/contacts/rm_contact_group", { contacts: contacts, group: group},
  function(data){
	if(data.length > 0)
        {
		var err = /ERROR/;
		if(err.test(data))
		{
			 $j("#error").html(data);
			 $j("#group_contacts").html("");
			 $j("#coninfo").html("");
			 $j("#error").fadeIn(3000);
            		 $j("#error").fadeOut(1000);
			 

		}
		else
		{
	    	$j("#Form").html(data);
		}
	}
  });
        });

});


// ########################################################### //
// ############## THESE FUNCTIONS ARE GLOBAL  ################ //
// ########################################################### //

// Hide/Show Deals Pages and Update Payment Info - show on my account and deals 
        $(document).ready(function(){
            $("a.toggle_button").each(function(){
                $(this).click(function(){
                    var currentID = $(this).attr("id");
                    var selectDiv = $("div."+currentID);
                    $(selectDiv).toggle(500);
                    var selectSection = $("section."+currentID);
                    $(selectSection).toggle(500);
                    return false;
                });
            });
        }); 
		

	
	$(document).ready(function() {
		$("a.iframe").fancybox({
			'hideOnContentClick': false,
			'titleShow': false,
			'showCloseButton': false,
			'enableEscapeButton': true,
			'hideOnOverlayClick': false
		});
	});

// ########################################################### //
// ####### THESE FUNCTIONS ARE FOR THE ACCOUNT PAGES  ######## //
// ########################################################### //

// Make it so you can do a sortable UL (categories) - Account pages
	$(function() {
		$( "#sortable" ).sortable();
		$( "#sortable" ).disableSelection();
	});

// Table Sort - Account Pages
            $(document).ready(function(){ 
              $(".sort-business-events").tablesorter({
					sortList: [[6,0]]
			  });
				$('.dateCol').unbind('click');
			    $('.dateCol').bind('click',function(){$('.sortHeader').trigger('click');$('.dateCol').toggleClass('header'); });
          });

		// Table Sort - Account Pages
		            $(document).ready(function(){ 
		              $(".sort").tablesorter();
		          });

// Payment Options - Account pages
        $(document).ready(function(){
            $("#venue_payment").change(function() {
                $(".box").hide();
                var id = $(this).val();
               $("#pay" + id).slideDown(500);
	    });
        });

// Update Payment Info - Account pages
        $(document).ready(function(){
            $("a.edit_payment").each(function(){
                $(this).click(function(){
                    $(".box").hide();
                    var currentID = $(this).attr("id");
                    var selectDiv = $("div."+currentID);
                    $(selectDiv).toggle(500);
                    return false;
                });
            });

        
        });

// Launch a deal - business pages
	$(document).ready(function() {
		var checkCount = $("input.launch-checkbox:checked").length;
		
			if (checkCount == 0 ) {
		
			    $("div#launch-options").fadeOut("medium") ;
		
			} else {
		
			    if ( $("div#launch-options").is(":hidden") ) {
		
				$("div#launch-options").fadeIn ( "medium" ) ;
		
			    }
		
			}

		$(".launch-checkbox").live('change', function () {

			var checkCount = $("input.launch-checkbox:checked").length;
		
			if (checkCount == 0 ) {
		
			    $("div#launch-options").fadeOut("medium") ;
		
			} else {
		
			    if ( $("div#launch-options").is(":hidden") ) {
		
				$("div#launch-options").fadeIn ( "medium" ) ;
		
			    }
		
			}
		});
	});
	
	
// Add New Credit Card - Checkout Page
	$(document).ready(function(){
		var checkCount = $("input.new_card_radio:checked").length;
		if (checkCount > 0)
		{
			$('#new_card_options').fadeIn("medium");
		}
		$('.radio_payment').click(function(){
			if ($(this).attr("id") == "cart_profile_id_new")
			{
				$('#new_card_options').fadeIn("medium");
			} else {
				$("#new_card_options").fadeOut("medium");
			}
		});
		$("#cart_submit").bind("click", function(e) {
			var checkCount = $("input.new_card_radio:checked").length;
			if (checkCount == 0)
			{
				$("#credit_card_form_first_name").val("1");
				$("#credit_card_form_first_name").change();
				$("#credit_card_form_first_name").blur();
				
				$("#credit_card_form_last_name").val("1");
				$("#credit_card_form_last_name").change();
				$("#credit_card_form_last_name").blur();
				
				$("#credit_card_form_card_number").val("1111111111111111");
				$("#credit_card_form_card_number").change();
				$("#credit_card_form_card_number").blur();
				
				$("#credit_card_form_security_code").val("111");
				$("#credit_card_form_security_code").change();
				$("#credit_card_form_security_code").blur();
				
				$("#credit_card_form_expiry_month").val("11");
				$("#credit_card_form_expiry_month").change();
				$("#credit_card_form_expiry_month").blur();
				
				$("#credit_card_form_expiry_year").val("1111");
				$("#credit_card_form_expiry_year").change();
				$("#credit_card_form_expiry_year").blur();
				
				$("#credit_card_form_address").val("1");
				$("#credit_card_form_address").change();
				$("#credit_card_form_address").blur();
				
				$("#credit_card_form_city").val("1");
				$("#credit_card_form_city").change();
				$("#credit_card_form_city").blur();
				
				$("#credit_card_form_zip").val("11111");
				$("#credit_card_form_zip").change();
				$("#credit_card_form_zip").blur();
				
				$('#new_cart').isValid(new_cart.validators);
			}
			$('#new_cart').append('<input type="hidden" name="commit" value="Secure Checkout" />');

			$('#new_cart').submit();
		});
		
		$("#paypal_submit").bind("click", function(e) {
			var checkCount = $("input.new_card_radio:checked").length;
			if (checkCount == 0)
			{
				$("#credit_card_form_first_name").val("1");
				$("#credit_card_form_first_name").change();
				$("#credit_card_form_first_name").blur();
				
				$("#credit_card_form_last_name").val("1");
				$("#credit_card_form_last_name").change();
				$("#credit_card_form_last_name").blur();
				
				$("#credit_card_form_card_number").val("1111111111111111");
				$("#credit_card_form_card_number").change();
				$("#credit_card_form_card_number").blur();
				
				$("#credit_card_form_security_code").val("111");
				$("#credit_card_form_security_code").change();
				$("#credit_card_form_security_code").blur();
				
				$("#credit_card_form_expiry_month").val("11");
				$("#credit_card_form_expiry_month").change();
				$("#credit_card_form_expiry_month").blur();
				
				$("#credit_card_form_expiry_year").val("1111");
				$("#credit_card_form_expiry_year").change();
				$("#credit_card_form_expiry_year").blur();
				
				$("#credit_card_form_address").val("1");
				$("#credit_card_form_address").change();
				$("#credit_card_form_address").blur();
				
				$("#credit_card_form_city").val("1");
				$("#credit_card_form_city").change();
				$("#credit_card_form_city").blur();
				
				$("#credit_card_form_zip").val("11111");
				$("#credit_card_form_zip").change();
				$("#credit_card_form_zip").blur();
				
				$('#new_cart').isValid(new_cart.validators);
			}
			$('#new_cart').append('<input type="hidden" name="commit" value="Paypal" />');

			$('#new_cart').submit();
		});
	});
	
	

// Tabs - Account pages
        $(document).ready(function(){
            $("#tabs,#subtabs").tabs();
            if($("#tabs") && document.location.hash){
                $.scrollTo("#tabs");
            }
            $("#tabs ul").localScroll({
                target:"#tabs",
                duration:0,
                hash:true
                });
            });

// Clearing Payment Id's and what not

      function setPaypal(id, paypalUsername)
	{
		document.getElementById('paypal_profile_id').value=id;
		document.getElementById('paypal_profile_paypal_username').value=paypalUsername;
	}
	
	function setDirectDeposit(id, bankName, accountTypeId, accountNumber, routingNumber)
	{
		document.getElementById('direct_deposit_profile_id').value = id;
		document.getElementById('direct_deposit_profile_bank_name').value = bankName;
		document.getElementById('venue_account_type').selectedIndex = accountTypeId;
		document.getElementById('direct_deposit_profile_account_number').value = accountNumber;
		document.getElementById('direct_deposit_profile_routing_number').value = routingNumber;
	}
	
	function setPaperCheck(id, address, address2, city, state, zip, phone)
	{
		document.getElementById('paper_check_profile_id').value = id;
		document.getElementById('paper_check_profile_street_address').value = address;
		document.getElementById('paper_check_profile_street_address_2').value = address2;
		document.getElementById('paper_check_profile_city').value = city;
		document.getElementById('paper_check_profile_state').value = state;
		document.getElementById('paper_check_profile_zip_code').value = zip;
		document.getElementById('paper_check_profile_phone_number').value = phone;
	}
	
	function resetPaymentTypeDropdown()
	{
		//document.getElementById('venue_payment').selectedIndex = 0;
	}
	
	function clearPaymentProfiles()
	{
		setPaypal('', '');
		setDirectDeposit('', '', '', '', '');
		setPaperCheck('', '', '', '', '', '', '');
	}

// ########################################################### //
// ########## THESE FUNCTIONS ARE FOR DEAL PAGES  ############ //
// ########################################################### //
	
	function codeAddress(address) {
	    geocoder.geocode( { 'address': address}, function(results, status) {
	      if (status == google.maps.GeocoderStatus.OK) {
	        map.setCenter(results[0].geometry.location);
	        var marker = new google.maps.Marker({
	            map: map, 
	            position: results[0].geometry.location
	        });
	      } else {
	        alert("Geocode was not successful for the following reason: " + status);
	      }
	    });
	  }

// ########################################################### //
// ############# THESE FUNCTIONS ARE FOR FORMS  ############## //
// ########################################################### //

// Multiselect Forms - Account pages and signup/login pages
         $(document).ready(function(){
               $("#select_location").multiselect({multiple: false,header: "Select your city",noneSelectedText: "Select City",selectedList: 1, minWidth: '350',height: '225'}).multiselectfilter();;
	       $("#business_state").multiselect({multiple: false,header: "Select your state",noneSelectedText: "Select State",selectedList: 1, minWidth: '307',height: '225' }).multiselectfilter();;
	       $("#venue_state").multiselect({multiple: false,header: "Select your state",noneSelectedText: "Select State",selectedList: 1, minWidth: '307',height: '225' }).multiselectfilter();;
	       $("#venue_categories").multiselect({selectedList: 3,minWidth: '307',height: 'auto',header: "Select whichever categories you fall under",noneSelectedText: "Select Categories"});
               $("#venue_amenities").multiselect({selectedList: 3,minWidth: '307',height: 'auto',header: "Select as many amenities as applicable",noneSelectedText: "Select Amenities"});
               $("#business_contact_info_state").multiselect({multiple: false,header: "Select your state",noneSelectedText: "Select State",selectedList: 1, minWidth: '307',height: '225'}).multiselectfilter();;
	       $(".venue_payments").multiselect({multiple: false,header:false,noneSelectedText: "Select Payment Method",selectedList: 1, minWidth: '307',height: '225'});
	       $("#paper_check_profile_state").multiselect({multiple: false,header: "Select your state",noneSelectedText: "Select State",selectedList: 1, minWidth: '307',height: '225'}).multiselectfilter();;
               $("#venue_pay_state").multiselect({multiple: false,/*header: "Select your state",*/noneSelectedText: "Select State",selectedList: 1, minWidth: '307',height: '225'}).multiselectfilter();;
               $("#venue_city").multiselect({multiple: false,header: "Select your city",noneSelectedText: "Select City",selectedList: 1, minWidth: '307',height: '225'}).multiselectfilter();;
               $("#venue_deal_city").multiselect({multiple: false,header: "Select your city",noneSelectedText: "Select City",selectedList: 1, minWidth: '307',height: '225'}).multiselectfilter();;
               $("#venue_account_type").multiselect({multiple: false,header: "Select your account type",noneSelectedText: "Select Account Type",selectedList: 1, minWidth: '307',height: '225'});
               $("#user_genres").multiselect({minWidth: '307',height: '225',header: "Select the genres that you like",noneSelectedText: "Select Genres",selectedText: "# of # genres selected"});
               $("#user_gender").multiselect({multiple: false,header: "Select your gender",noneSelectedText: "Select Gender",selectedList: 1, minWidth: '307',height: 'auto'});
               $("#user_education").multiselect({multiple: false,header: "Select your education level",noneSelectedText: "Select Education Level",selectedList: 1, minWidth: '307',height: '225'});
               $("#user_employment").multiselect({multiple: false,header: "Select your employment status",noneSelectedText: "Select Employment Status",selectedList: 1, minWidth: '307',height: '225'});
               $("#user_income").multiselect({multiple: false,header: "Select your income level",noneSelectedText: "Select Income Level",selectedList: 1, minWidth: '307',height: '225'});
               $("#user_house").multiselect({multiple: false,header: "Select your home ownership status",noneSelectedText: "Select Living Situation",selectedList: 1, minWidth: '307',height: 'auto'});
               $("#user_relationship").multiselect({multiple: false,header: "Select your relationship status",noneSelectedText: "Select Relationship Status",selectedList: 1, minWidth: '307',height: '225'});
               $("#user_children").multiselect({multiple: false,header: "Select your parental status",noneSelectedText: "Select Parental Status",selectedList: 1, minWidth: '307',height: 'auto'});
               $("#credit_card_form_card_type").multiselect({multiple: false,header: "Select your card type",noneSelectedText: "Select Card Type",selectedList: 1, minWidth: '307',height: '225'});
               $("#user_time_zone").multiselect({multiple: false,header: "Select your time zone",noneSelectedText: "Select Time Zone",selectedList: 1, minWidth: '307',height: '225'});
               $("#credit_card_form_state").multiselect({multiple: false,header: "Select your state",noneSelectedText: "Select State",selectedList: 1, minWidth: '307',height: '225'}).multiselectfilter();;
               $("#user_city").multiselect({multiple: false,header: "Select your city",noneSelectedText: "Select City",selectedList: 1, minWidth: '307',height: '225'}).multiselectfilter();;
               $("#select_location").multiselect({multiple: false,header: "Select your city",noneSelectedText: "Select City",selectedList: 1, minWidth: '307',height: '225'}).multiselectfilter();;
               $("#event_type").multiselect({multiple: false,header: "Select event type",noneSelectedText: "Event Type",selectedList: 1, minWidth: '307',height: 'auto'}).multiselectfilter();;
               $("#venue").multiselect({multiple: false,header: "Select venue location",noneSelectedText: "Venue Location",selectedList: 1, minWidth: '307',height: 'auto'}).multiselectfilter();;
            });


// Calendars - Account pages and signup/login pages
        $(document).ready(function(){	
            $( "#birthday_cal" ).datepicker({
                    changeMonth: true,
                    changeYear: true,
                    yearRange: '1900:1995'
            });
            $( "#event_cal" ).datepicker({
                    showButtonPanel: true,
                    minDate: 0,
                    duration: '',
                    constrainInput: false
            });
	    $( "#deal_cal" ).datepicker({
                    showButtonPanel: true,
                    minDate: 0,
                    duration: '',
                    constrainInput: false,
		    maxDate: "+5D"
            });
	    $('#event_time').timepicker({
		showPeriod: true
	    });
	    var dates = $( "#from_date, #to_date" ).datepicker({
			defaultDate: "+1w",
			changeMonth: true,
			numberOfMonths: 2,
			onSelect: function( selectedDate ) {
				var option = this.id == "from_date" ? "minDate" : "maxDate",
					instance = $( this ).data( "datepicker" ),
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings );
				dates.not( this ).datepicker( "option", option, date );
			}
		});
        });

// Currency Formatter - Account Pages for Forms
		$(document).ready(function()
		{
		    $('.currency').blur(function()
		    {
			$('.currency').formatCurrency();
		    });
		});
                
// Form Transitions - Landing page
	$("document").ready(function() {
		$('.button-landing-1').click(function(){
		$(".form-step1-landing").animate({"left": "-70%","opacity":0.3},1500);
		$(".form-step2-landing").animate({"left": "25%","opacity":1},1500);
		 });
                
	});
        
// ########################################################### //
// ########## THESE FUNCTIONS ARE FOR BIZ LANDING  ########### //
// ########################################################### //

// Photo slideshow - Business static page
      $(document).ready(function() {
           $('#slideshowHolder').jqFancyTransitions({ width: 568, height: 311, delay: 3500, strips: 20, stripDelay: 50, direction: 'fountainAlternate', titleOpacity: .85, navigation: true, links: false });     
      });
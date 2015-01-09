$(document).ready(function () {
  bindEvents();

$('#button1').magnificPopup({
  items: {
      src: '#popup',
      type: 'inline'
  },
});

$('#button2').magnificPopup({
  items: {
      src: '#popup2',
      type: 'inline'
  },
});

$('#button3').magnificPopup({
  items: {
      src: '#popup3',
      type: 'inline'
  },
});

$('#cash_out').magnificPopup({
  items: {
      src: '#popup4',
      type: 'inline'
  },
});

$('#call_in').magnificPopup({
  items: {
      src: '#popup5',
      type: 'inline'
  },
});

populate();


});

function populate() {
    var popRequest = $.ajax({
        type: "POST",
        url: "/populate"
    })
    popRequest.success(function(data) {
        for (i = 0; i < data.length; i++) {
            updateUtilities(data[i].utility)
        }
    })
}

function ajaxAddExpenditure(cost, note) {
	var expenditureRequest = $.ajax({
		type: "POST",
		url: "/add-expenditure",
		data: {cost: cost, note: note}
	})
	expenditureRequest.success(function(data) {
    updateExpenditure(data)
    updateSumTotal()
	})
}

function updateExpenditure(data) {
  var newExpenditure = buildNewUtilityTr(data['note'], data['first_name'], data['amount']).hide()
  $(".utility_table tr:last").after(newExpenditure)
  $(".utility_table tr:last").fadeIn(150)
}

function updateSumTotal() {
    var sumTotalRequest = $.ajax({
        type: "POST",
        url: "/sum-total"
    })
    sumTotalRequest.success(function(data) {
        $('#final_sum td').text("Subtotal: " + data['total'])
        $('#your_share td').text("Your Share: " + data['your_share'])
    })   
}

function ajaxAddUser(first_name, last_name, email, phone, password) {
	var addUserRequest = $.ajax({
		type: "POST",
		url: "/add-user",
		data: {first_name: first_name, last_name: last_name, email: email, phone: phone, password: password}
	})
	addUserRequest.success(function(data) {

	})
}

function updateUtilities(data) {
  var newUtility = buildNewUtilityTr(data['utility_type'], data['provider'], data['amount']).hide()
  $(".utility_table tr:last").after(newUtility)
  $(".utility_table tr:last").fadeIn(150)
}

function ajaxAddUtility(utility_type, provider, amount) {
	var addUtilityRequest = $.ajax({
		type: "POST",
		url: "/create-utility",
		data: {utility_type: utility_type, provider: provider, amount: amount}
	})
	addUtilityRequest.success(function(data) {
		updateUtilities(data)
        updateSumTotal()
	})
}

function wipeSlate() {
    $(".utility_table td").fadeOut(150)
    $(".utility_table td").remove()
    updateSumTotal()
}

//Message Sending

function sendCashOutMsg() {
	var cashOutMsg = $.ajax({
		type: "POST",
		url: "/cash-out"
	})
    wipeSlate()
}

function sendCallInMsg() {
    var callInMsg = $.ajax({
        type: "POST",
        url: "/call-in"
    })
}

function clearFields() {
	$('input')
	.not(':button, :submit, :reset, :hidden')
	.val('')
	.removeAttr('checked')
	.removeAttr('selected');
}


function bindEvents() {
    $('#subl').on('click', function(e) {
        e.preventDefault()
        cost = $(this).eq(0).siblings().eq(1).val()
        note = $(this).eq(0).siblings().eq(3).val()
        console.log(cost)
        console.log(note)
        ajaxAddExpenditure(cost, note)
        clearFields()
        var magnificPopup = $.magnificPopup.instance;
        magnificPopup.close()
    })

    $('#submit_new_user').on('click', function(e) {
        e.preventDefault()
        first_name = $('#register_user input').eq(0).val()
        last_name = $('#register_user input').eq(1).val()
        email = $('#register_user input').eq(2).val()
        phone = $('#register_user input').eq(3).val()
        password = $('#register_user input').eq(4).val()
        ajaxAddUser(first_name, last_name, email, phone, password)
        clearFields()
        var magnificPopup = $.magnificPopup.instance;
        magnificPopup.close()
    })

    $('#submit_utility').on('click', function(e) {
    	e.preventDefault()
    	utility_type = $('#add_utility input').eq(0).val()
    	provider = $('#add_utility input').eq(1).val()
    	amount = $('#add_utility input').eq(2).val()
    	ajaxAddUtility(utility_type, provider, amount)
    	clearFields()
    	var magnificPopup = $.magnificPopup.instance;
        magnificPopup.close()
    })

    $('#cash_out').on('click', function(e) {
    	e.preventDefault()
    })

    $('#call_in').on('click', function(e) {
        e.preventDefault()
    })

    $('#yessure').on('click', function(e) {
      sendCashOutMsg()
      var magnificPopup = $.magnificPopup.instance;
      magnificPopup.close()
    })

    $('#yessure_call_in').on('click', function(e) {
      sendCallInMsg()
      var magnificPopup = $.magnificPopup.instance;
      magnificPopup.close()
    })

    $('#notsure').on('click', function(e) {
      var magnificPopup = $.magnificPopup.instance;
      magnificPopup.close()
    })

}



function buildNewUtilityTr(name, utility_type, amount) {
  var utilityTableTemplate = $.trim($('#table_row_template').html());
  var $utility = $(utilityTableTemplate).find('tr')
  $utility.find('td:nth-child(1)').text(name);
  $utility.find('td:nth-child(2)').text(utility_type);
  $utility.find('td:nth-child(3)').text(amount);
  return $utility;
}




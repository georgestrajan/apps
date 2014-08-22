
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("SendEmail", function(request, response) {
	var Mandrill = require('mandrill');
	Mandrill.initialize('oPxtcJ8N5A3rH27-ro505g');
	
	Mandrill.sendEmail({
	  message: {
	    text: request.params.text,
	    subject: request.params.subject,
	    from_email: "notification@cominghome.com",
	    from_name: "Coming home notification",
	    to: [
	      {
	        email: "george.strajan@gmail.com",
	        name: "No name"
	      }
	    ]
	  },
	  async: true
	},{
	  success: function(httpResponse) {
	    console.log(httpResponse);
	    response.success("Email sent!");
	  },
	  error: function(httpResponse) {
	    console.error(httpResponse);
	    response.error("Uh oh, something went wrong");
	  }
	});
	
	response.success("Success");
});

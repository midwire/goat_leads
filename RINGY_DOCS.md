Ringy API documentation

URL:https://app.ringy.com/api/public/leads/new-lead
Method:POST
Content-Type:application/json

This API will be expecting the following fields to be in the post body for each lead:

{
  "sid": "***************************",
  "authToken": "**********************",
  "phone_number": "Phone number",
  "first_name": "First name",
  "last_name": "Last name",
  "email": "Email",
  "city": "City",
  "state": "State",
  "zip_code": "Zip code",
  "birthday": "Birthday",
  "street_address": "Street address",
  "zip_code": "ZIP code",
  "lead_source": "Lead source",
  "cost_of_lead": "Cost of lead",
  "notes": "Notes"
}

Response type: JSON

Response data: { "vendorResponseId": "someUniqueString" }

Response HTTP status codes

    200 (ok): The API keys are valid and the request was successful. There is no need to verify that it worked with the Ringy team.

    400 (bad request): The API key fields (sid, authToken) are not set, or the request body is in an invalid format.

    401 (unauthorized): The request body is valid, but the API keys are incorrect or invalid.

    508 (resource limit reached): The request was valid, but you have submitted the maximum number of leads set for this API key within a 24 hour period.

Common mistakes

    If you receive a BAD REQUEST response, verify that the request body is in JSON format, and that the content-type is set to application/json, as described above.

    If your customer says that not all of the fields you sent went through, verify the fields being POSTed matches the fields above. If you are unable to change the field name being POSTed on your end, tell your customer to change it within their Ringy account. Users are able to customize the name of their fields to whatever they want.

    If you believe the Ringy API is not working because you can't access the above URL from the browser, please note that URL only accepts POST requests, not GET requests.

    If you receive a BAD REQUEST and you believe your request is valid, verify you have escaped any special characters in the JSON object.



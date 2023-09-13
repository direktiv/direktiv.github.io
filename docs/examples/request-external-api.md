# Request API 
 [Request API on Github](https://github.com/direktiv/direktiv-examples/tree/main/request-external-api)

This example shows how we can write a flow to communicate with a external API service. In this flowflow we will use the Direktiv request image to make a HTTP GET request to https://fakerapi.it/ and fetch the details of a fake person. A transform is also used to clean up the returned value from the action, but it can be commented out to see the full return value.



```yaml title="API Request"
direktiv_api: workflow/v1

# Example Output:
# {
#   "person": {
#     "address": {
#       "buildingNumber": "8422",
#       "city": "Ashleytown",
#       "country": "Ethiopia",
#       "county_code": "AD",
#       "id": 0,
#       "latitude": -21.509297,
#       "longitude": -48.162169,
#       "street": "47933 Kennedi View Apt. 395",
#       "streetName": "Margie Stream",
#       "zipcode": "44788"
#     },
#     "birthday": "1944-09-28",
#     "email": "qmetz@gmail.com",
#     "firstname": "Gabriella",
#     "gender": "female",
#     "id": 1,
#     "image": "http://placeimg.com/640/480/people",
#     "lastname": "Steuber",
#     "phone": "+5542223225627",
#     "website": "http://wiza.com"
#   }
# }

description: |
  Execute a HTTP request to generate a persons details from the fake data API fakerapi. 
functions:
- id: http-request
  image: direktiv/http-request:dev
  type: knative-workflow
states:
#
# HTTP GET Fake person from fakerapi
# Transform data to get data out of body
#
- id: get-fake-persons
  transform: "jq({person: .return[0].result.data[0]})"
  type: action
  action:
    function: http-request
    input: 
      method: "GET"
      url: "https://fakerapi.it/api/v1/persons?_quantity=1"

```



```json title="Output"
{
  "person": {
    "address": {
      "buildingNumber": "8422",
      "city": "Ashleytown",
      "country": "Ethiopia",
      "county_code": "AD",
      "id": 0,
      "latitude": -21.509297,
      "longitude": -48.162169,
      "street": "47933 Kennedi View Apt. 395",
      "streetName": "Margie Stream",
      "zipcode": "44788"
    },
    "birthday": "1944-09-28",
    "email": "qmetz@gmail.com",
    "firstname": "Gabriella",
    "gender": "female",
    "id": 1,
    "image": "http://placeimg.com/640/480/people",
    "lastname": "Steuber",
    "phone": "+5542223225627",
    "website": "http://wiza.com"
  }
}
```


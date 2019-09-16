# MINI GEO JSON API

## Fetch given areas
Used to take given areas in GeoJson format

**URL** : `/api/v1/given_areas`

**Method** : `GET`

**Request example** : `GET https://shrouded-everglades-94970.herokuapp.com/api/v1/given_areas`
### Success Response
**Code** : `200 OK`

## Create location
Used to create location with some name

**URL** : `/api/v1/locations`

**Method** : `GET`

**Params** : `"name": "LOCATION NAME"`

**Request example** : `POST https://shrouded-everglades-94970.herokuapp.com/api/v1/locations/?name=Tokio`
### Success Response
**Code** : `200 OK`

**Content example**
```json
{
  "location_id": 1
}
```
### Error Response
**Condition** : `name param is missing or is empty`

**Code** : `400 BAD REQUEST`

**Content example**
```json
{
  "error": {
    "name": [
      "is missing"
    ]
  }
}
```

## Fetch location
Used to get information about given name location

**URL** : `/api/v1/locations#{id}`

**Method** : `GET`

**Request example** : ` GET https://shrouded-everglades-94970.herokuapp.com/api/v1/locations/1`
### Success Response
**Code** : `200 OK`

**Content example** `where "inside?" keys descirbes if the locations is inside given areas`
```json
{
  "name": "Tokio",
  "latitude": 35.6803997,
  "longitude": 139.7690174,
  "inside?": false
}
```
### Unsuccess Response
**Condition** : `Information about location still not set, please try in a moment`

**Code** : `204 NO CONTENT`
### Error Response
**Condition** : `API was not able to set information about location`

**Code** : `422 UNPROCESSABLE ENTITY`
### Error Response
**Condition** : `No id location in the system`

**Code** : `417 EXPECTATION FAILED`

**Content example**
```json
{
  "error": {
    "id": [
      "Couldn't find Location with 'id'=4"
    ]
  }
}
```

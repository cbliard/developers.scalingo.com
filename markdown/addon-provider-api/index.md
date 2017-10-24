# Addon provider API

To plug your service to our platorm you need to define how we can communicate
with it. We are expecting a few endpoints to be present on your side, they are
detailed in this page.

In this page, examples are using the endpoint `addonhost.com/scalingo/resources`,
but this is completely confirgurable thanks to [the manifest](/addon-provider-api/manifest.html).

--- row ---

## Addon provisioning

Provisioning consists in allocating what your service is providing. For
instance, a Database as a Service would create and initialize the database and
return the correct credentials. The user should be able to use the addon almost
instantly.

--- row ---

`POST https://user:password@addonhost.com/scalingo/resources`

Parameters:

* `plan`: `string - mandatory` - Name of the requested plan by the user
* `app_id`: `string - mandatory` - ID of the application that's the ID you have to use to update the configuration.
* `options`: `object - optional` - Hash of the option defined for a given plan (see the [/addon-provider-api/manifest](manifest))

Response:

Status __200 OK__, __201 Created__ or __202 Accepted__

* `id`: `string - mandatory` - ID of the provisioned resource, that is the
  identifier we will user in our request to update or deprovision the addon, it
  has to be unique and to identify clearly the resource on your side. It shall
  not be longer than 255 characters
* `message`: `string - optional` - Message which will be displayed to the user
  after the provisioning
* `config`: `object - optional` - Hash of the configuration variable to inject
  in the application environment
* `log_drain_url`: `string - optional` - If the `log_drain` attribute is true
  in the manifest, all the logs will be send to this endpoint (http/https)

||| col |||

Request:

```
POST https://youraddon.com/resources
```

```json
{
  "plan": "free",
  "app_id": "app-name-id",
  "options": {}
}
```

Response:

Status: 201 Created

```json
{
  "id": "addon-id-1",
  "config_vars": {"EXAMPLE_VAR1": "VALUE"},
  "message": "Addon has been provisioned"
}
```

--- row ---

## Plan modification

When a user want to choose a new plan for its addon, this endpoint is called.

--- row ---

`PUT https://user:password@addonhost.com/scalingo/resources/:id`

Parameters:

* `plan`: `string - mandatory` - Plan requested by the user
* `options`: `object - optional` - Hash of the option defined for the new plan (see the [/addon-provider-api/manifest](manifest))

Response:

Status __200 OK__

* `message`: `string - optional` - Message to display to the user after the plan change
* `config`: `object - optional` - Configuration variable to modify once the resource has been upgraded

||| col |||

Request:

```
PUT https://youraddon.com/resources/addon-id-1
```

```json
{
  "plan": "premium",
  "options": {}
}
```

Response:

Status: 200 OK

```json
{
  "config_vars": {"EXAMPLE_VAR1": "VALUE_UPDATED"},
  "message": "Addon has been updated"
}
```


--- row ---

## Addon deprovisioning

--- row ---

`DELETE https://user:password@addonhost.com/scalingo/resources/:id`

Response:

Status __204 No content__

# Events

Events are generated automatically according to your actions,
thanks to them, you can have an overview of the activity of your
applications.

--- row ---

**Event attributes**

{:.table}
| field      | type   | description                              |
| ---------- | ------ | ---------------------------------------- |
| id         | string | unique ID of event                       |
| created_at | date   | date of creation                         |
| user       | object | embedded user who generated the event    |
| type       | string | type of event (see below for the values) |
| app_name   | string | app name the event belongs to.           |

Note: `app_name` is not modified when an application is renamed, it's
frozen in the event.

According to the `type` field, extra data will be included
in the structure in a `type_data` attribute:

||| col |||

Example object:

* Base event

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at": "2015-02-12T18:05:14.226+01:00",
  "user": {
      "username": "johndoe",
      "email": "john@doe.com",
      "id": "51e6bc626edfe40bbb000001"
  },
  "app_id": "5343eccd646173000a140000",
  "type": "typename"
}
```

--- row ---

* **New app event**

_When:_ When the application is created
`type=new_app`

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at": "2015-02-12T18:05:14.226+01:00",
  "user": {
      "username": "johndoe",
      "email": "john@doe.com",
      "id": "51e6bc626edfe40bbb000001"
  },
  "app_id": "5343eccd646173000a140000",
  "type": "new_app"
}
```

--- row ---

* **Rename app event**

_When:_ When the application is renamed to a new name
`type=rename_app`

{:.table}
| field    | type   | description                 |
| -------- | ------ | --------------------------- |
| old_name | string | Old name of the application |
| new_name | string | New name of the application |

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at": "2015-02-12T18:05:14.226+01:00",
  "user": {
      "username": "johndoe",
      "email": "john@doe.com",
      "id": "51e6bc626edfe40bbb000001"
  },
  "app_id": "5343eccd646173000a140000",
  "type": "rename_app",
  "type_data": {
      "old_name": "old-app-name",
      "new_name": "new-app-name"
  }
}
```

--- row ---

* **Transfer app event**

_When:_ When the application is transfered to a new owner
`type=transfer_app`

{:.table}
| field              | type   | description                    |
| ------------------ | ------ | ------------------------------ |
| old_owner.id       | string | ID of the previous owner       |
| old_owner.email    | string | Email of the previous owner    |
| old_owner.username | string | Username of the previous owner |
| new_owner.id       | string | ID of the new owner            |
| new_owner.email    | string | Email of the new owner         |
| new_owner.username | string | Username of the new owner      |

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at": "2015-02-12T18:05:14.226+01:00",
  "user": {
      "username": "johndoe",
      "email": "john@doe.com",
      "id": "51e6bc626edfe40bbb000001"
  },
  "app_id": "5343eccd646173000a140000",
  "type": "rename_app",
  "type_data": {
      "old_owner": {
          "username": "johndoe",
          "email": "john@doe.com",
          "id": "51e6bc626edfe40bbb000001"
      },
      "new_owner": {
          "username": "new-johndoe",
          "email": "new-john@doe.com",
          "id": "51e6bc626edfe40bbb000002"
      }
  }
}
```
--- row ---

* **Restart event**

_When:_ The application or some containers have been restarted
`type=restart`

{:.table}
| field      | type  | description                           |
| ---------- | ----- | ------------------------------------- |
| scope      | array | The scope of the restart, null is all |

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at" : "2015-02-12T18:05:14.226+01:00",
  "user" : {
      "username" : "johndoe",
      "email" : "john@doe.com",
      "id" : "51e6bc626edfe40bbb000001"
  },
  "app_id" : "5343eccd646173000a140000",
  "type" : "restart",
  "type_data": {
    "scope" : ["web", "worker"]
  }
}
```

--- row ---

* **Scale event**

_When:_ The application has been scaled out 
`type=scale`

{:.table}
| field               | type   | description                        |
| ------------------- | ------ | ---------------------------------- |
| previous_containers | object | The formation before the operation |
| containers          | object | The formation after the request    |

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at" : "2015-02-12T18:05:14.226+01:00",
  "user" : {
      "username" : "johndoe",
      "email" : "john@doe.com",
      "id" : "51e6bc626edfe40bbb000001"
  },
  "app_id" : "5343eccd646173000a140000",
  "type": "scale",
  "type_data": {
      "previous_containers" : {
          "web" : 1,
          "worker": 0
      },
      "containers" : {
          "web" : 2,
          "worker" : 1 
        }
    }
}
```
--- row ---

* **Deployment event**

_When:_ A deployment has been done
`type=deployment`

{:.table}
| field      | type   | description                                                |
| ---------- | -------| ---------------------------------------------------------- |
| deployment | object | The [Deployment](/deployment.html) associated to the event |

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at" : "2015-02-12T18:05:14.226+01:00",
  "user" : {
      "username" : "johndoe",
      "email" : "john@doe.com",
      "id" : "51e6bc626edfe40bbb000001"
  },
  "app_id" : "5343eccd646173000a140000",
  "type": "deployment",
  "type_data": {
      "deployment" : {
          "id" : "5343eccd646aa3012a140230",
          "push": "johndoe",
          "git_ref" : "0123456789abcdef"
        }
    }
}
```

--- row ---

* **Run event**

_When:_ Someone runs `scalingo run` from the [CLI](http://cli.scalingo.com)
`type=run`

{:.table}
| field      | type   | description                           |
| ---------- | ------ | ------------------------------------- |
| command    | string | The command run by the user           |

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at": "2015-02-12T18:05:14.226+01:00",
  "user": {
      "username": "johndoe",
      "email": "john@doe.com",
      "id": "51e6bc626edfe40bbb000001"
  },
  "app_id": "5343eccd646173000a140000",
  "type": "run",
  "type_data": {
      "command": "bundle exec rake db:migrate"
  }
}
```

--- row ---

* **New Domain event**

_When:_ Each time a custom domain name is added to the app
`type=new_domain`

{:.table}
| field     | type    | description                        |
| --------- | ------- | ---------------------------------- |
| hostname  | string  | Hostname of the custom domain      |
| ssl       | boolean | Custom SSL certificate added       |

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at": "2015-02-12T18:05:14.226+01:00",
  "user": {
      "username": "johndoe",
      "email": "john@doe.com",
      "id": "51e6bc626edfe40bbb000001"
  },
  "app_id": "5343eccd646173000a140000",
  "type": "new_domain",
  "type_data": {
      "name" : "example.com",
      "ssl" : false
  }
}
```

--- row ---

* **Edit Domain event**

_When:_ When a domain is updated, (set or remove SSL)
`type=edit_domain`

{:.table}
| field     | type    | description                       |
| --------- | ------- | --------------------------------- |
| hostname  | string  | Hostname of the custom domain     |
| ssl       | boolean | Custom SSL certificate added      |
| old_ssl   | boolean | Previous state of the SSL cert    |

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at": "2015-02-12T18:05:14.226+01:00",
  "user": {
      "username": "johndoe",
      "email": "john@doe.com",
      "id": "51e6bc626edfe40bbb000001"
  },
  "app_id": "5343eccd646173000a140000",
  "type": "edit_domain",
  "type_data": {
      "hostname" : "example.com",
      "old_ssl" : false
      "ssl" : true
  }
}
```

--- row ---

* **Delete Domain event**

_When:_ Remove a custom domain from an app
`type=delete domain`

{:.table}
| field     | type    | description                        |
| --------- | ------- | ---------------------------------- |
| hostname  | string  | Hostname of the custom domain      |
| ssl       | boolean | Custom SSL certificate added       |

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at": "2015-02-12T18:05:14.226+01:00",
  "user": {
      "username": "johndoe",
      "email": "john@doe.com",
      "id": "51e6bc626edfe40bbb000001"
  },
  "app_id": "5343eccd646173000a140000",
  "type": "delete_domain",
  "type_data": {
      "hostname" : "example.com",
      "ssl" : true
  }
}
```

--- row ---

* **New Addon event**

_When:_ Each time an addon is added to the app
`type=new_addon`

{:.table}
| field               | type   | description                         |
| ------------------- | ------ | ----------------------------------- |
| addon_provider_name | string | Name of the addon provider          |
| plan_name           | string | Plan associated to the addon        |
| resource_id         | string | Resource ID given by addon provider |

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at": "2015-02-12T18:05:14.226+01:00",
  "user": {
      "username": "johndoe",
      "email": "john@doe.com",
      "id": "51e6bc626edfe40bbb000001"
  },
  "app_id": "5343eccd646173000a140000",
  "type": "new_addon",
  "type_data": {
      "addon_provider_name": "scalingo-mysql",
      "plan_name" : "free",
      "resource_id": "0abcdef-123456-bcccde-1bcdef"
  }
}
```

--- row ---

* **Upgrade Addon event**

_When:_ The plan of the addon has been changed
`type=upgrade_addon`

{:.table}
| field               | type   | description                         |
| ------------------- | ------ | ----------------------------------- |
| addon_provider_name | string | Name of the addon provider          |
| old_plan_name       | string | Previous plan of the addon          |
| plan_name           | string | Plan associated to the addon        |
| resource_id         | string | Resource ID given by addon provider |

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at": "2015-02-12T18:05:14.226+01:00",
  "user": {
      "username": "johndoe",
      "email": "john@doe.com",
      "id": "51e6bc626edfe40bbb000001"
  },
  "app_id": "5343eccd646173000a140000",
  "type": "new_addon",
  "type_data": {
      "addon_provider_name": "scalingo-mysql",
      "old_plan_name" : "free",
      "plan_name" : "1g",
      "resource_id": "0abcdef-123456-bcccde-1bcdef"
  }
}
```

--- row ---

* **Delete Addon event**

_When:_ The addon has been removed from the app
`type=delete_addon`

{:.table}
| field               | type   | description                         |
| ------------------- | ------ | ----------------------------------- |
| addon_provider_name | string | Name of the addon provider          |
| plan_name           | string | Plan associated to the addon        |
| resource_id         | string | Resource ID given by addon provider |

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at": "2015-02-12T18:05:14.226+01:00",
  "user": {
      "username": "johndoe",
      "email": "john@doe.com",
      "id": "51e6bc626edfe40bbb000001"
  },
  "app_id": "5343eccd646173000a140000",
  "type": "new_addon",
  "type_data": {
      "addon_provider_name": "scalingo-mysql",
      "plan_name" : "1g",
      "resource_id": "0abcdef-123456-bcccde-1bcdef"
  }
}
```

--- row ---

* **New Collaborator event**

_When:_ Each time a collaboration invitation is sent
`type="new_collaborator"`

{:.table}
| field                 | type   | description                            |
| --------------------- | ------ | -------------------------------------- |
| collaborator.id       | string | ID of the invited user if user exists  |
| collaborator.username | string | Username of the invited user if exists |
| collaborator.email    | string | Email of the invited person            |

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at": "2015-02-12T18:05:14.226+01:00",
  "user": {
      "username": "johndoe",
      "email": "john@doe.com",
      "id": "51e6bc626edfe40bbb000001"
  },
  "app_id": "5343eccd646173000a140000",
  "type": "new_collaborator",
  "type_data": {
      "collaborator": {
          "email": "test@example.com"
      }
  }
}
```

--- row ---

* **Accept Collaborator event**

_When:_ The invitee accepts the collaboration invitation for an app
`type="accept_collaborator"`

{:.table}
| field                         | type   | description                            |
| ----------------------------- | ------ | -------------------------------------- |
| collaborator.id               | string | ID of the invited user if user exists  |
| collaborator.email            | string | Email of the invited person            |
| collaborator.username         | string | Username of the invited person         |
| collaborator.inviter.email    | string | Email of the inviter                   |
| collaborator.inviter.username | string | Username of the inviter                |

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at": "2015-02-12T18:05:14.226+01:00",
  "user": {
      "username": "test-example",
      "email": "test@example.com",
      "id": "51e6bc626edfe40bbb000002"
  },
  "app_id": "5343eccd646173000a140000",
  "type": "edit_collaborator",
  "type_data": {
      "collaborator": {
          "id": "51e6bc626edfe40bbb000001"
          "email": "test@example.com",
          "username": "text-example",
          "inviter": {
              "email": "john@doe.com",
              "username": "johndoe"
          }
      }
  }
}
```

--- row ---

* **Delete Collaborator event**

_When:_ The collaborator has been removed from the app
`type="delete_collaborator"`

{:.table}
| field                         | type   | description                  |
| ----------------------------- | ------ | ---------------------------- |
| collaborator.id               | string | ID of the collaborator       |
| collaborator.email            | string | Email of the collaborator    |
| collaborator.username         | string | Username of the collaborator |

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at": "2015-02-12T18:05:14.226+01:00",
  "user": {
      "username": "johndoe",
      "email": "john@doe.com",
      "id": "51e6bc626edfe40bbb000001"
  },
  "app_id": "5343eccd646173000a140000",
  "type": "delete_collaborator",
  "type_data": {
      "collaborator": {
          "id": "51e6bc626edfe40bbb000002",
          "username": "test-example",
          "email": "test@example.com"
      }
  }
}
```

--- row ---

* **New Variable event**

_When:_ Each time a variable is added to the application
`type=new_variable`

{:.table}
| field     | type   | description                        |
| --------- | ------ | ---------------------------------- |
| name      | string | Name of the newly created variable |
| value     | string | Value of the new variable          |

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at": "2015-02-12T18:05:14.226+01:00",
  "user": {
      "username": "johndoe",
      "email": "john@doe.com",
      "id": "51e6bc626edfe40bbb000001"
  },
  "app_id": "5343eccd646173000a140000",
  "type": "new_event",
  "type_data": {
      "name" : "VAR1",
      "value" : "VAL1"
  }
}
```

--- row ---

* **Edit Variable event**

_When:_ Each time a variable is modified
`type=edit_variable`

{:.table}
| field     | type   | description                             |
| --------- | ------ | --------------------------------------- |
| name      | string | Name of the modified variable           |
| value     | string | New value of the modified variable      |
| old_value | string | Previous value of the modified variable |

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at": "2015-02-12T18:05:14.226+01:00",
  "user": {
      "username": "johndoe",
      "email": "john@doe.com",
      "id": "51e6bc626edfe40bbb000001"
  },
  "app_id": "5343eccd646173000a140000",
  "type": "edit_variable",
  "type_data": {
      "name" : "VAR1",
      "old_value" : "VAL1",
      "value" : "VAL2"
  }
}
```

--- row ---

* **Edit multiple variables event**

_When:_ Each time the bulk updates is used
`type=edit_variables`

{:.table}
| field                    | type   | description                         |
| ------------------------ | ------ | ----------------------------------- |
| new_vars                 | array  | List of the newly created variables |
| updated_vars             | array  | List of the updated variables       |
| new_vars[].name          | string | Name of the variable                |
| new_vars[].value         | string | Value of the variable               |
| updated_vars[].name      | string | Name of the variables               |
| updated_vars[].old_value | string | Old value of the updated variable   |
| updated_vars[].value     | string | New value of the updated variable   |

||| col |||

Example object

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at": "2015-02-12T18:05:14.226+01:00",
  "user": {
      "username": "johndoe",
      "email": "john@doe.com",
      "id": "51e6bc626edfe40bbb000001"
  },
  "app_id": "5343eccd646173000a140000",
  "type": "edit_variable",
  "type_data": {
      "updated_vars": [{
          "name": "VAR1",
          "value": "VAL1"
      }],
      "new_vars": [{
          "name": "VAR2",
          "value": "VAL2",
          "old_value": "OLD_VAL2"
      }]
  }
}
```

--- row ---

* **Delete variable event**

_When:_ Each time a variable is deleted
`type=delete_variable`

{:.table}
| field | type   | description                   |
| ----- | ------ | ----------------------------- |
| name  | string | Name of the deleted variable  |
| value | string | Value of the deleted variable |

||| col |||

Example object:

```json
{
  "id": "54dcdd4a73636100011a0000",
  "created_at": "2015-02-12T18:05:14.226+01:00",
  "user": {
      "username": "johndoe",
      "email": "john@doe.com",
      "id": "51e6bc626edfe40bbb000001"
  },
  "app_id": "5343eccd646173000a140000",
  "type": "delete_variable"
  "type_data": {
      "name" : "VAR1",
      "value" : "VAL2"
  }
}
```

--- row ---

## List the events of an app

--- row ---

With this list of events, you can reconstruct the timeline of an application.

`GET https://api.scalingo.com/v1/apps/[:app]/events`

> Feature: pagination

||| col |||

Example

```shell
curl -H "Accept: application/json" -H "Content-Type: application/json" -u :$AUTH_TOKEN https://api.scalingo.com/v1/apps/[:app]/events
```

Returns 200 OK

Response

```json
{
    "events": [
    {
        "id": "54dcdd4a73636100011a0000",
        "created_at": "2015-02-12T18:05:14.226+01:00",
        "user": {
            "username": "johndoe",
            "email": "john@doe.com",
            "id": "51e6bc626edfe40bbb000001"
        },
        "app_id": "5343eccd646173000a140000",
        "type": "run",
	"type_data": {
            "command": "rake db:migrate"
	}
    }, {
        "id": "54dcdc0073636100011b0000",
        "created_at": "2015-02-12T17:59:44.962+01:00",
        "user": {
            "username": "johndoe",
            "email": "john@doe.com",
            "id": "51e6bc626edfe40bbb000001"
        },
        "app_id": "5343eccd646173000a140000",
        "type": "deployment",
        "type_data": {
            "deployment": {
                "id": "54dcdc0073636100011a0000",
                "pusher": "johndoe",
                "git_ref": "737c22bde6b05d3262d9908727c54c7692888eef"
            }
        }
    }, (...)],
    "meta": {
        "pagination": {
            "current_page": 1,
            "next_page": 2,
            "prev_page": null,
            "total_pages": 4,
            "total_count": 61
        }
    }
}
```




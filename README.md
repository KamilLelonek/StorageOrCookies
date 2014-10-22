## Prepare

`nmp install .`

## Usage

This library offers 2 types of persistency: `Cookies` or `LocalStorage`. They can be used independly.<br>
`Persistency` object manages persistency in `Cookies` with `LocalStorage` fallback if cookies are disabled.

Save data:
```
Cookies.set key, value
Storage.set key, value
Persistency.set key, value
```

Read data:
```
Cookies.get key
Storage.get key
Persistency.get key
```

Delete data:
```
Cookies.remove key
Storage.remove key
Persistency.remove key
```

Clear all data:
```
Cookies.clearAll()
Storage.clearAll()
Persistency.clearAll()
```

## Tests
`./node_modules/karma/bin/karma start test/karma.conf.coffee`

class @Cookies
  @set : (key, value, days = 365) ->
    expire = new Date()
    expire.setTime new Date().getTime() + 3600000 * 24 * days
    document.cookie = "#{key}=#{escape(value)};expires=#{expire.toGMTString()}"
    document.cookie = "_#{key}=#{escape(Date.now())};expires=#{expire.toGMTString()}"

  @get : (key) ->
    regex = new RegExp("[; ]#{key}=([^\\s;]*)")
    matchingResult = (' ' + document.cookie).match regex
    if key and matchingResult then unescape(matchingResult[1]) else ''

  @remove : (key) ->
    cookie = "#{key}=;expires=Thu, 01 Jan 1970 00:00:00 GMT"
    document.cookie = cookie
    document.cookie = "_#{cookie}"

  @clearAll : ->
    cookies = document.cookie.split ';'
    cookies.forEach (cookie) ->
      separator = cookie.indexOf '='
      name = if separator isnt -1 then cookie.substr(0, separator) else cookie
      Cookies.remove name

  @enabled : ->
    return false unless Cookies.navigatorCookies()
    return true if document.cookie
    name = 'cookietest'
    Cookies.set name, 1
    result = Cookies.get name
    Cookies.remove name
    !!result

  @navigatorCookies : -> navigator.cookieEnabled

class @Storage
  @set : (key, value) ->
    localStorage.setItem key, value
    localStorage.setItem "_#{key}", Date.now()

  @get : (key) ->
    localStorage.getItem(key) || ''

  @remove : (key) ->
    localStorage.removeItem key
    localStorage.removeItem "_#{key}"

  @clearAll : ->
    localStorage.clear()

  @enabled : ->
    return false unless Storage.windowLocalStorage()
    item = 'whatever'
    try
      localStorage.setItem item, item
      localStorage.removeItem item
      true
    catch
      false

  @windowLocalStorage : -> localStorage?

class @Persistency
  @set : (key, value) ->
    if Cookies.enabled()
      Cookies.set(key, value)
      Cookies.set("_#{key}", Date.now())
    else if Storage.enabled()
      Storage.set(key, value)
      Storage.set("_#{key}", Date.now())

  @get : (key) ->
    return Cookies.get key if Cookies.enabled() and not Storage.enabled()
    return Storage.get key if Storage.enabled() and not Cookies.enabled()
    if Storage.enabled() and Cookies.enabled()
      cookieVal  = Cookies.get key
      storageVal = Storage.get key
      return cookieVal if cookieVal and not storageVal
      return storageVal if storageVal and not storageVal
      if storageVal and cookieVal
        cookieTime  = parseInt(Cookies.get "_#{key}")
        storageTime = parseInt(Storage.get "_#{key}")
        return if cookieTime > storageTime then cookieVal else storageVal
    ''

  @remove : (key) ->
    if Cookies.enabled()
      Cookies.remove key
    if Storage.enabled()
      Storage.remove key

  @clearAll : ->
    if Cookies.enabled()
      Cookies.clearAll()
    if Storage.enabled()
      Storage.clearAll()

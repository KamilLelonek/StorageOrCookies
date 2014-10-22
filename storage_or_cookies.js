(function() {
  this.Cookies = (function() {
    function Cookies() {}

    Cookies.set = function(key, value, days) {
      var expire;
      if (days == null) {
        days = 365;
      }
      expire = new Date();
      expire.setTime(new Date().getTime() + 3600000 * 24 * days);
      document.cookie = "" + key + "=" + (escape(value)) + ";expires=" + (expire.toGMTString());
      return document.cookie = "_" + key + "=" + (escape(Date.now())) + ";expires=" + (expire.toGMTString());
    };

    Cookies.get = function(key) {
      var matchingResult, regex;
      regex = new RegExp("[; ]" + key + "=([^\\s;]*)");
      matchingResult = (' ' + document.cookie).match(regex);
      if (key && matchingResult) {
        return unescape(matchingResult[1]);
      } else {
        return '';
      }
    };

    Cookies.remove = function(key) {
      var cookie;
      cookie = "" + key + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT";
      document.cookie = cookie;
      return document.cookie = "_" + cookie;
    };

    Cookies.clearAll = function() {
      var cookies;
      cookies = document.cookie.split(';');
      return cookies.forEach(function(cookie) {
        var name, separator;
        separator = cookie.indexOf('=');
        name = separator !== -1 ? cookie.substr(0, separator) : cookie;
        return Cookies.remove(name);
      });
    };

    Cookies.enabled = function() {
      var name, result;
      if (!Cookies.navigatorCookies()) {
        return false;
      }
      if (document.cookie) {
        return true;
      }
      name = 'cookietest';
      Cookies.set(name, 1);
      result = Cookies.get(name);
      Cookies.remove(name);
      return !!result;
    };

    Cookies.navigatorCookies = function() {
      return navigator.cookieEnabled;
    };

    return Cookies;

  })();

  this.Storage = (function() {
    function Storage() {}

    Storage.set = function(key, value) {
      localStorage.setItem(key, value);
      return localStorage.setItem("_" + key, Date.now());
    };

    Storage.get = function(key) {
      return localStorage.getItem(key) || '';
    };

    Storage.remove = function(key) {
      localStorage.removeItem(key);
      return localStorage.removeItem("_" + key);
    };

    Storage.clearAll = function() {
      return localStorage.clear();
    };

    Storage.enabled = function() {
      var item;
      if (!Storage.windowLocalStorage()) {
        return false;
      }
      item = 'whatever';
      try {
        localStorage.setItem(item, item);
        localStorage.removeItem(item);
        return true;
      } catch (_error) {
        return false;
      }
    };

    Storage.windowLocalStorage = function() {
      return typeof localStorage !== "undefined" && localStorage !== null;
    };

    return Storage;

  })();

  this.Persistency = (function() {
    function Persistency() {}

    Persistency.set = function(key, value) {
      if (Cookies.enabled()) {
        Cookies.set(key, value);
        return Cookies.set("_" + key, Date.now());
      } else if (Storage.enabled()) {
        Storage.set(key, value);
        return Storage.set("_" + key, Date.now());
      }
    };

    Persistency.get = function(key) {
      var cookieTime, cookieVal, storageTime, storageVal;
      if (Cookies.enabled() && !Storage.enabled()) {
        return Cookies.get(key);
      }
      if (Storage.enabled() && !Cookies.enabled()) {
        return Storage.get(key);
      }
      if (Storage.enabled() && Cookies.enabled()) {
        cookieVal = Cookies.get(key);
        storageVal = Storage.get(key);
        if (cookieVal && !storageVal) {
          return cookieVal;
        }
        if (storageVal && !storageVal) {
          return storageVal;
        }
        if (storageVal && cookieVal) {
          cookieTime = parseInt(Cookies.get("_" + key));
          storageTime = parseInt(Storage.get("_" + key));
          if (cookieTime > storageTime) {
            return cookieVal;
          } else {
            return storageVal;
          }
        }
      }
      return '';
    };

    Persistency.remove = function(key) {
      if (Cookies.enabled()) {
        Cookies.remove(key);
      }
      if (Storage.enabled()) {
        return Storage.remove(key);
      }
    };

    Persistency.clearAll = function() {
      if (Cookies.enabled()) {
        Cookies.clearAll();
      }
      if (Storage.enabled()) {
        return Storage.clearAll();
      }
    };

    return Persistency;

  })();

}).call(this);

//# sourceMappingURL=storage_or_cookies.map

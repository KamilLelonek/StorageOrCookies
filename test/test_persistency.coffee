describe 'Persistency', ->
  describe 'Both enabled', ->
    beforeEach ->
      Persistency.clearAll()

    it 'should not get value', ->
      expect(Persistency.get 'persistency').toBeUndefined

    it 'should set value', ->
      Persistency.set 'value', 'value'
      expect(Persistency.get 'value').not.toBe ''

    it 'should remove value', ->
      Persistency.set 'value', 'value'
      expect(Persistency.get 'value').not.toBe ''
      Persistency.remove 'value'
      expect(Persistency.get 'value').toBe ''

    it 'should remove all values', ->
      Persistency.set 'value', 'value'
      expect(Persistency.get 'value').not.toBe ''
      Persistency.clearAll()
      expect(Persistency.get 'value').toBe ''

  describe 'Switch from localstorage to cookie', ->
    beforeEach ->
      Persistency.clearAll()

    it 'should use localstorage and then cookies', ->
      Persistency.set 'value', 'storage'
      expect(Persistency.get 'value').toBe 'storage'
      expect(Storage.get 'value').toBe 'storage'
      spyOn(Storage, 'enabled').and.returnValue false
      expect(Persistency.get 'value').toBe ''
      expect(Cookies.get 'value').toBe ''
      Persistency.set 'value', 'cookie'
      expect(Persistency.get 'value').toBe 'cookie'
      expect(Cookies.get 'value').toBe 'cookie'

    it 'should override persistency by cookies', ->
      Persistency.set 'value', 'storage'
      expect(Persistency.get 'value').toBe 'storage'
      expect(Storage.get 'value').toBe 'storage'
      Cookies.set 'value', 'cookie'
      expect(Persistency.get 'value').toBe 'cookie'

  describe 'Switch from cookie to localstorage', ->
    beforeEach ->
      Persistency.clearAll()

    it 'should use localstorage and then cookies', ->
      storageSpy = spyOn(Storage, 'enabled').and.returnValue false
      Persistency.set 'value', 'cookie'
      expect(Persistency.get 'value').toBe 'cookie'
      expect(Cookies.get 'value').toBe 'cookie'
      expect(Storage.get 'value').toBe ''
      storageSpy.and.returnValue true
      expect(Storage.get 'value').toBe ''
      Persistency.set 'value', 'storage'
      expect(Storage.get 'value').toBe 'storage'

    it 'should override persistency by storage', ->
      storageSpy = spyOn(Storage, 'enabled').and.returnValue false
      Persistency.set 'value', 'cookie'
      expect(Persistency.get 'value').toBe 'cookie'
      expect(Cookies.get 'value').toBe 'cookie'
      storageSpy.and.returnValue true
      Storage.set 'value', 'storage'
      expect(Persistency.get 'value').toBe 'storage'

  describe 'Both disabled', ->
    beforeEach ->
      Persistency.clearAll()
      spyOn(Storage, 'windowLocalStorage').and.returnValue false
      spyOn(Cookies, 'navigatorCookies').and.returnValue false

    it 'should not stored any value', ->
      Persistency.set 'value', 'value'
      expect(Persistency.get 'value').toBe ''

describe 'Cookie', ->
  beforeEach ->
    Cookies.clearAll()

  it 'should have cookies enabled', ->
    expect(Cookies.enabled()).toBe true

  it 'should not have cookies enabled', ->
    spyOn(Cookies, 'navigatorCookies').and.returnValue false
    expect(Cookies.enabled()).toBe false

  it 'should not get cookie', ->
    expect(Cookies.get 'cookie').toBe ''

  it 'should set cookie', ->
    Cookies.set 'cookie', 'cookie'
    expect(Cookies.get 'cookie').not.toBe ''

  it 'should remove cookie', ->
    Cookies.set 'cookie', 'cookie'
    expect(Cookies.get 'cookie').not.toBe ''
    Cookies.remove 'cookie'
    expect(Cookies.get 'cookie').toBe ''

  it 'should remove all cookies', ->
    Cookies.set 'cookie', 'cookie'
    expect(Cookies.get 'cookie').not.toBe ''
    Cookies.clearAll()
    expect(Cookies.get 'cookie').toBe ''
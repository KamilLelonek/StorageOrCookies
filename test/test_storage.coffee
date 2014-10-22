describe 'Storage', ->
  beforeEach ->
    Storage.clearAll()

  it 'should have LocalStorage enabled', ->
    expect(Storage.enabled()).toBe true

  it 'should not have LocalStorage enabled', ->
    spyOn(Storage, 'windowLocalStorage').and.returnValue false
    expect(Storage.enabled()).toBe false

  it 'should not get value', ->
    expect(Storage.get 'storage').toBe ''

  it 'should set value', ->
    Storage.set 'storage', 'storage'
    expect(Storage.get 'storage').not.toBe ''

  it 'should remove value', ->
    Storage.set 'storage', 'storage'
    expect(Storage.get 'storage').not.toBe ''
    Storage.remove 'storage'
    expect(Storage.get 'storage').toBe ''

  it 'should remove all values', ->
    Storage.set 'storage', 'storage'
    expect(Storage.get 'storage').not.toBe ''
    Storage.clearAll()
    expect(Storage.get 'storage').toBe ''
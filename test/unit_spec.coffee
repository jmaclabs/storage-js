describe "Storage exisited", ->
  s = new StorageJS "localStorage"

  it "constructor", ->
    expect(s).toBeDefined()
    expect(s).not.toBeNull()
    expect(s.storageType).toEqual("localStorage")

  it "setItem", ->
    val = s.setItem("hola", "hey!")
    expect(val).not.toBeNull()

  it "getItem", ->
    val = s.getItem("hola")
    expect(val).toEqual("hey!")

    val = s.getItem("hola_wrong!")
    expect(val).toBeNull()

  it "clear", ->
    s.clear()
    val = s.getItem("hola")
    expect(val).toBeNull()
  
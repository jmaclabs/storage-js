###
storage-js - Web Storage
v0.0.1
###
class StorageJS
  # default storage engine type:
  constructor: (@storageType) ->
    @storageType = "localStorage"
    @storage = ""

    if window[@storageType] isnt "undefined"
      @storage = window[@storageType]
    else if window.sessionStorage isnt "undefined"
      @storageType = "sessionStorage"
      @storage = window[@storageType]
    else
      # implement userData
      console.log 'TODO implement userData polyfill'

  setItem: (key, val) ->
    @storage.setItem(key, val)
    # console.log "setItem: ", "#{@prefix}:#{key}", val

  getItem: (key) ->
    @storage.getItem(key)
    # console.log "getItem: #{@prefix}:#{key}"

  clear: ->
    @storage.clear()

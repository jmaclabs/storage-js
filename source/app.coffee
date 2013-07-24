storage = new Storage "localStorage"

now = new Date().getTime()
storage.setItem("username", "kien")
storage.setItem("timestamp", now)

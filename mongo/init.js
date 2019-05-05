use admin

db.createUser({
    user: "admin",
    pwd: "a1.b2.c3*",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ] }
)

use rplexus

db.createUser({
    user: "rpadmin",
    pwd: "rp12345*",
    roles: [ { role: "readWrite", db: "rplexus" }]}
)


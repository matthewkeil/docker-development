const admin = db.getSiblingDB("admin");
admin.createUser({
  user: "admin",
  pwd: "pass",
  roles: [{ role: "root", db: "admin" }]
});
const uc = db.getSiblingDB("uc");
uc.createUser({
  user: "ucApi",
  pwd: "ucApi",
  roles: [{ role: "dbOwner", db: "uc" }]
});

// ROOT_USER=${MONGO_ROOT_USERNAME}
// ROOT_PASSWORD=${MONGO_ROOT_PASSWORD}
// # ROOT_PASSWORD=${MONGO_ROOT_PASSWORD:-$(pwgen -s -1 16)}
// ROOT_DB="admin"
// ROOT_ROLE=${MONGO_ROOT_ROLE}

// USER=${MONGO_USERNAME}
// PASSWORD=${MONGO_PASSWORD}
// DB=${MONGO_DB}
// ROLE=${MONGO_ROLE}

// echo "Strating MongoDB to add users and roles"
// /user/bin/mongod &
// while ! nc -vz localhost 27017; do sleep 1; done

// if [[ -n $ROOT_USER ]] && [[ -n $ROOT_PASS ]] && [[ -n $ROOT_ROLE ]]
// then
//     echo "Creating root user: \"$ROOT_USER\"..."
//     mongo $ROOT_DB --eval "db.createUser({ user: '$ROOT_USER', pwd: '$ROOT_PASSWORD', roles: [{ role: '$ROOT_ROLE' }] })"

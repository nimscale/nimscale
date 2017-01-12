
import db_sqlite
import subexes

type
  MemDB* = ref object
    db: db_sqlite.DbConn

proc create*(): MemDB=
    var memdb = MemDB()
    # memdb.db=open(":memory:", nil, nil, nil)
    memdb.db=open("/tmp/sqlitetmp.db", nil, nil, nil)
    result = memdb

proc destroy*(memdb:MemDB, name:string)=
    memdb.db.exec(sql("Drop table if exists " & name & ";"))

proc init*(memdb:MemDB, name:string, sqlstr:string, indexes:seq[string])=
    #sqlstr SSOMETHING LIKE:
    #          Id    VARCHAR(10) PRIMARY KEY,
    #          Name  VARCHAR(200) NOT NULL,
    #          i     INT(11),
    #          f     DECIMAL(18,10)
    destroy(memdb,name)
    var sqlstr2 = subex"""
    create table $1 (
    $2
    );"""%(@[name,sqlstr])
    memdb.db.exec(sql(sqlstr2))
    memdb.db.exec(sql"BEGIN")
    if indexes != @[]:
        var sqlindex=subex"CREATE INDEX $1_index1 ON $1 ($','{2..});" % (@[name] & indexes)
        # echo sqlindex
        memdb.db.exec(sql(sqlindex))








#
#
# theDb.exec(sql"Drop table if exists myTestTbl;")
# theDb.exec(sql"""
#     create table myTestTbl (
#          Id    VARCHAR(10) PRIMARY KEY,
#          Name  VARCHAR(200) NOT NULL,
#          i     INT(11),
#          f     DECIMAL(18,10));
#
#     """)
# theDb.exec(sql"CREATE INDEX myTestTbl_index1 ON myTestTbl (Name,i,f);")
# theDb.exec(sql"BEGIN")
#
# for i in 1..10000:
#   theDb.exec(sql"INSERT INTO myTestTbl (id,name,i,f) VALUES (?,?,?,?)",
#         "a#" & $i,"Item some more text#" & $i, i, sqrt(i.float))
# theDb.exec(sql"COMMIT")
#
# # for x in theDb.fastRows(sql"select * from myTestTbl"):
# #   echo x
#
# let id = theDb.tryInsertId(sql"INSERT INTO myTestTbl (id,name,i,f) VALUES (?,?,?,?)",
#       "idx","Item#1001", 1001, sqrt(1001.0))
# let id2=theDb.tryInsertId(sql"INSERT INTO myTestTbl (id,name,i,f) VALUES (?,?,?,?)",
#     "idx","Item#1001", 1001, sqrt(1001.0))
#
# echo id
# echo id2
# echo "Inserted item: ", theDb.getValue(sql"SELECT name FROM myTestTbl WHERE id=?", id)
#
# echo("1")
# sleep(100000)
# echo("2")
#
# theDb.close()
#
# let p = new(Job)
#
# let llog=new(Job_LogEntry)
# llog.epoch=2323
# llog.log="alog message"
# p.logs = @[]
#
# for i in 0 .. <5:
#     p.logs.add llog
#
# let packed = packPointer(p)
# # echo packed.repr
#
# let unpacker = newUnpackerFlat(packed)
# let res = unpacker.unpackPointer(0, Job)
#
# var resJson = ""
# json.toJSON(resJson,res)
#
# echo (resJson)
